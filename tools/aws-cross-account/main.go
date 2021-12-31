package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/VJftw/org-infra/internal/logging"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/organizations"
	"github.com/aws/aws-sdk-go/service/sts"
	"github.com/go-ini/ini"
	"github.com/jessevdk/go-flags"
)

type opts struct {
	CredentialsFile string `long:"credentials_file" default:"~/.aws/credentials"`
	
	AccountName string `long:"account_name" required:"yes"`
	PullRequestRoleName string `long:"pull_request_role_name"`
	BranchRoleName []string `long:"branch_role_name"`
	RoleName string `long:"role_name"`
}

func main() {
	opts := &opts{}
	if _, err := flags.Parse(opts); err != nil {
		logging.Logger.Fatal().Err(err).Msg("could not parse flags")
	}
	opts.CredentialsFile = absoluteHomedir(opts.CredentialsFile)
	if err := ensureIniFile(opts.CredentialsFile); err != nil {
		logging.Logger.Fatal().Err(err).Msg("could not ensure AWS Credentials file")
	}

	// determine which RoleName to use
	sess := session.Must(session.NewSession())
	roleName := resolveRoleName(opts, sess)
	profileName := fmt.Sprintf("%s_%s", opts.AccountName, roleName)

	iniCredentialsFile, err := ini.Load(opts.CredentialsFile)
	if err != nil {
		logging.Logger.Fatal().Err(err).Msg("could not load AWS Credentials file")
	}

	if iniCredentialsFile.HasSection(profileName) {
		iniCredentialsFile.DeleteSection(profileName)
	}

	credentialsAccountSection, err := iniCredentialsFile.NewSection(profileName)
	if err != nil {
		logging.Logger.Fatal().Err(err).Str("section", profileName).Msg("could not create credentials profile")
	}

	sourceProfileName := fmt.Sprintf("sourceprofile_%s", profileName)

	if iniCredentialsFile.HasSection(sourceProfileName) {
		iniCredentialsFile.DeleteSection(sourceProfileName)
	}
	
	sourceProfileSection, err := iniCredentialsFile.NewSection(sourceProfileName)
	if err != nil {
		logging.Logger.Fatal().Err(err).Str("section", sourceProfileName).Msg("could not create sourceprofile profile")
	}

	
	orgSvc := organizations.New(sess)
	listAccountsOutput, err := orgSvc.ListAccounts(&organizations.ListAccountsInput{})
	if err != nil {
		logging.Logger.Fatal().Err(err).Msg("could not list accounts in organization")
	}

	accountsByAccountName := map[string]*organizations.Account{}
	for _, account := range listAccountsOutput.Accounts {
		accountsByAccountName[aws.StringValue(account.Name)] = account
	}

	if _, ok := accountsByAccountName[opts.AccountName]; !ok {
		logging.Logger.Fatal().Err(err).Str("account_name", opts.AccountName).Msg("account not found")
	}

	targetAccount := accountsByAccountName[opts.AccountName]
	credentialsAccountSection.NewKey("role_arn", fmt.Sprintf(
		"arn:aws:iam::%s:role/%s", 
		aws.StringValue(targetAccount.Id), 
		roleName,
	))
	credentialsAccountSection.NewKey("source_profile", sourceProfileName)

	creds, err := sess.Config.Credentials.Get()
	if err != nil {
		logging.Logger.Fatal().Err(err).Msg("could not get AWS credentials for source profile")
	}
	
	if creds.AccessKeyID != "" {
		sourceProfileSection.NewKey("aws_access_key_id", creds.AccessKeyID)
	}

	if creds.SecretAccessKey != "" {
		sourceProfileSection.NewKey("aws_secret_access_key", creds.SecretAccessKey)
	}

	if creds.SessionToken != "" {
		sourceProfileSection.NewKey("aws_session_token", creds.SessionToken)
	}


	if err := iniCredentialsFile.SaveTo(opts.CredentialsFile); err != nil{
		logging.Logger.Fatal().Err(err).Msg("could not save AWS credentials file")
	}

	logging.Logger.Info().Msg("done")

	if err := json.NewEncoder(os.Stdout).Encode(map[string]string{
		"profile": profileName,
	}); err != nil {
		logging.Logger.Fatal().Err(err).Msg("could not write json result")
	}
}

func absoluteHomedir(path string) string {
	if path[0] == '~' {
		if homeDir, err := os.UserHomeDir(); err != nil {
			return filepath.Join(homeDir, path[2:])
		}

		return filepath.Join(os.Getenv("HOME"), path[2:])
	}

	return path
}

func ensureIniFile(path string) error {
	if _, err := os.Stat(path); errors.Is(err, os.ErrNotExist) {
		if err := os.MkdirAll(filepath.Dir(path), 0644); err != nil {
			return err
		}

		if err := ini.Empty().SaveTo(path); err != nil {
			return err
		}	
	}

	if err := os.Chmod(path, 0600); err != nil {
		return err
	}

	return nil
}


func resolveRoleName(opts *opts, session *session.Session) string {

	stsSvc := sts.New(session)
	callerIdentityOut, err := stsSvc.GetCallerIdentity(&sts.GetCallerIdentityInput{})
	if err != nil {
		logging.Logger.Warn().Err(err).Msg("could not get AWS caller identity")
		return opts.RoleName
	}

	arn := aws.StringValue(callerIdentityOut.Arn) 
	if strings.Contains(arn, "role/ghapr") {
		return opts.PullRequestRoleName
	}

	if strings.Contains(arn, "role/gha") {
		branchRoleNames := map[string]string{}
		for _, branchRoleName := range opts.BranchRoleName {
			branch := strings.Split(branchRoleName, ":")[0]
			roleName := strings.Split(branchRoleName, ":")[1]
			branchRoleNames[branch] = roleName
		}

		if roleName, ok := branchRoleNames[os.Getenv("GITHUB_REF_NAME")]; ok {
			return roleName
		}
	}


	return opts.RoleName
}
