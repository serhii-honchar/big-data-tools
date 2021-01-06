from google.cloud import dataproc_v1 as dataproc
from dataproc_config import create_dataproc_config
from gcs_bucket import create_bucket_if_not_exists, delete_bucket


def create_cluster(project_id, region, cluster_name, create_buckets=None):
    # Create a client with the endpoint set to the desired cluster region.
    cluster_client = dataproc.ClusterControllerClient(
        client_options={"api_endpoint": f"{region}-dataproc.googleapis.com:443"}
    )

    staging_bucket = None
    tmp_bucket = None
    if create_buckets:
        staging_bucket = create_bucket_if_not_exists(project_id, region, f'{cluster_name}-staging')
        tmp_bucket = create_bucket_if_not_exists(project_id, region, f'{cluster_name}-tmp')

    # Create the cluster config.
    cluster = create_dataproc_config(project_id, cluster_name, region, staging_bucket, tmp_bucket)

    # Create the cluster.
    operation = cluster_client.create_cluster(
        request={"project_id": project_id, "region": region, "cluster": cluster}
    )
    result = operation.result()

    # Output a success message.
    print(f"Cluster created successfully: {result.cluster_name}")


def shutdown_cluster(project_id, region, cluster_name, delete_buckets=False):
    cluster_client = dataproc.ClusterControllerClient(
        client_options={"api_endpoint": f"{region}-dataproc.googleapis.com:443"}
    )
    operation = cluster_client.delete_cluster(
        request={"project_id": project_id, "region": region, "cluster_name": cluster_name}
    )
    operation.result()

    print("Cluster {} successfully deleted.".format(cluster_name))

    if delete_buckets:
        delete_bucket(project_id, region, f'{cluster_name}-staging')
        delete_bucket(project_id, region, f'{cluster_name}-tmp')
        print("Buckets for dataproc cluster {} were successfully deleted.".format(cluster_name))


if __name__ == "__main__":
    from argparse import ArgumentParser
    parser = ArgumentParser()
    subparsers = parser.add_subparsers(dest='command')
    create_cluster_parser = subparsers.add_parser('create-cluster')
    create_cluster_parser.add_argument('--project-id', required=True)
    create_cluster_parser.add_argument('--region', required=True)
    create_cluster_parser.add_argument('--cluster-name', required=True)
    create_cluster_parser.add_argument('--create-buckets', action='store_true')

    shutdown_cluster_parser = subparsers.add_parser('shutdown-cluster')
    shutdown_cluster_parser.add_argument('--project-id', required=True)
    shutdown_cluster_parser.add_argument('--region', required=True)
    shutdown_cluster_parser.add_argument('--cluster-name', required=True)
    shutdown_cluster_parser.add_argument('--delete-buckets', action='store_true')

    args = parser.parse_args()
    if args.command == 'create-cluster':
        create_cluster(args.project_id, args.region, args.cluster_name, args.create_buckets)
    if args.command == 'shutdown-cluster':
        shutdown_cluster(args.project_id, args.region, args.cluster_name, args.delete_buckets)

