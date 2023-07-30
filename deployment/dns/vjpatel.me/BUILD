subinclude("//build/defs:terraform")

terraform_root(
    name = "vjpatel.me",
    srcs = [
        "aws.tf",
        "gcp.tf",
        "gcp_project_domains.yaml",
        "gsuite.tf",
        "legacy_homomorphic-encryption.tf",
        "main.tf",
        "root.tf",
    ],
    account_auths = {
        "//accounts/aws:vjp-dns_auth": {
            "branches": {
                "main": "administrator",
            },
            "pull_request": "reader",
        },
        "//accounts/aws:vjp-management_auth": {
            "branches": {
                "main": "administrator",
            },
            "pull_request": "reader",
        },
        "//accounts/aws:vjp-website_auth": {
            "branches": {
                "main": "reader",
            },
            "pull_request": "reader",
        },
        "//accounts/gcp:vjp-dns_auth": {
            "branches": {
                "main": "administrator",
            },
            "pull_request": "reader",
        },
        "//accounts/gcp:vjp-remote-ws_auth": {
            "branches": {
                "main": "administrator",
            },
            "pull_request": "reader",
        },
    },
)

# re-import
"""
$ plz run //deployment/dns/vjpatel.me:vjpatel.me -- bash
terraform init
export aws_zone="$(AWS_PROFILE="vjp-dns" aws route53 list-hosted-zones --output=text | grep "aws." | awk '{ print $3 }' | cut -f3 -d/)"
export root_zone="$(AWS_PROFILE="vjp-management" aws route53 list-hosted-zones --output=text | grep "vjpatel.me." | awk '{ print $3 }' | cut -f3 -d/)"
terraform import "aws_route53_zone.aws" "$aws_zone"
terraform import "google_project_service.dns" "vjp-dns/dns.googleapis.com"
terraform import "google_dns_managed_zone.gcp" "projects/vjp-dns/managedZones/vjp-dns"
terraform import "aws_route53_record.mx" "${root_zone}_vjpatel.me_MX"
terraform import "aws_route53_record.txt" "${root_zone}_vjpatel.me_TXT"
terraform import "aws_route53_record.dmarc" "${root_zone}__dmarc.vjpatel.me_TXT"
terraform import "aws_route53_record.gsuite_domain_key" "${root_zone}_google._domainkey.vjpatel.me_TXT"
terraform import "aws_route53_record.gsuite_service[\"drive\"]" "${root_zone}_drive.vjpatel.me_CNAME"
terraform import "aws_route53_record.gsuite_service[\"calendar\"]" "${root_zone}_calendar.vjpatel.me_CNAME"
terraform import "aws_route53_record.gsuite_service[\"mail\"]" "${root_zone}_mail.vjpatel.me_CNAME"
terraform import "aws_route53_zone.root" "${root_zone}"
terraform import "aws_route53_record.aws" "${root_zone}_aws.vjpatel.me_NS"
terraform import "aws_route53_record.gcp" "${root_zone}_gcp.vjpatel.me_NS"
terraform import "aws_route53_record.vjp_website[\"A\"]" "${root_zone}_vjpatel.me_A"
terraform import "aws_route53_record.vjp_website[\"AAAA\"]" "${root_zone}_vjpatel.me_AAAA"
"""
