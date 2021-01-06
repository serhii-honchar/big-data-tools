from google.cloud import storage
from google.cloud.storage.constants import STANDARD_STORAGE_CLASS


def _compose_bucket_name(project_id, region, name):
    return f'{project_id}-{region}-{name}'


def create_bucket_if_not_exists(project_id, region, name):
    bucket_name = _compose_bucket_name(project_id, region, name)
    client = storage.Client()
    bucket = client.lookup_bucket(bucket_name)
    if not bucket:
        bucket = storage.Bucket(client, bucket_name)
        bucket.location = region
        bucket.storage_class = STANDARD_STORAGE_CLASS

        bucket = client.create_bucket(bucket)
    return bucket_name


def delete_bucket(project_id, region, name):
    client = storage.Client()
    bucket_name = _compose_bucket_name(project_id, region, name)
    bucket = client.lookup_bucket(bucket_name)
    try:
        bucket.delete_blobs(blobs=bucket.list_blobs())
    except Exception as e:
        print(e)

    bucket.delete(force=True)

