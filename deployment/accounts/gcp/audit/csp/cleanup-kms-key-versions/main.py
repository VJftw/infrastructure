
def cleanup(event, context):
    """Background Cloud Function to be triggered by Pub/Sub.
    Args:
         event (dict):  The dictionary with data specific to this type of
                        event. The `@type` field maps to
                         `type.googleapis.com/google.pubsub.v1.PubsubMessage`.
                        The `data` field maps to the PubsubMessage data
                        in a base64-encoded string. The `attributes` field maps
                        to the PubsubMessage attributes if any is present.
         context (google.cloud.functions.Context): Metadata of triggering event
                        including `event_id` which maps to the PubsubMessage
                        messageId, `timestamp` which maps to the PubsubMessage
                        publishTime, `event_type` which maps to
                        `google.pubsub.topic.publish`, and `resource` which is
                        a dictionary that describes the service API endpoint
                        pubsub.googleapis.com, the triggering topic's name, and
                        the triggering event type
                        `type.googleapis.com/google.pubsub.v1.PubsubMessage`.
    Returns:
        None. The output is written to Cloud Logging.
    """
    from google.cloud import kms
    import os

    client = kms.KeyManagementServiceClient()

    crypto_key_id = os.getenv("CRYPTO_KEY_ID")

    # get primary crypto key version from crypto key
    crypto_key = client.get_crypto_key(
        request=kms.GetCryptoKeyRequest(
            name=crypto_key_id,
        ),
    )
    primary_crypto_key_version = crypto_key.primary
    

    # list current crypto key versions
    list_resp = client.list_crypto_key_versions(
        request=kms.ListCryptoKeyVersionsRequest(
            parent=crypto_key_id,
            page_size=100,
        ),
    )

    most_recent_non_primary_version = None

    # determine the most recent non-primary version
    for crypto_key_version in list_resp.crypto_key_versions:
        if crypto_key_version.name == primary_crypto_key_version.name:
            # skip the primary version
            continue
        
        if (
            most_recent_non_primary_version == None or 
            crypto_key_version.create_time.rfc3339() > most_recent_non_primary_version.create_time.rfc3339()
            ):
            most_recent_non_primary_version = crypto_key_version

    print(f"keeping primary: {primary_crypto_key_version.name}")
    print(f"keeping most-recent non-primary: {most_recent_non_primary_version.name}")
        
    # destroy keys which are not the primary or most-recent non-primary version
    for crypto_key_version in list_resp.crypto_key_versions:
        if crypto_key_version.name == primary_crypto_key_version.name:
            # skip the primary version
            continue
        if crypto_key_version.name == most_recent_non_primary_version.name:
            # skip the most-recent non-primary version
            continue

        # skip if already scheduled for destroy or destroyed
        if crypto_key_version.state == kms.CryptoKeyVersion.CryptoKeyVersionState.DESTROY_SCHEDULED:
            continue
        if crypto_key_version.state == kms.CryptoKeyVersion.CryptoKeyVersionState.DESTROYED:
            continue

        print(f"destroying: {crypto_key_version.name}")
        destroy_resp = client.destroy_crypto_key_version(
            request=kms.DestroyCryptoKeyVersionRequest(
                name=crypto_key_version.name,
            ),
        )
