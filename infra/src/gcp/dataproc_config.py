from google.cloud.dataproc_v1beta2.types.shared import Component
from datetime import timedelta
from google.protobuf.duration_pb2 import Duration

"""

Dataproc RPC reference: 
https://cloud.google.com/dataproc/docs/reference/rpc/google.cloud.dataproc.v1beta2#top_of_page

Init actions:
https://github.com/GoogleCloudDataproc/initialization-actions/blob/master/kafka/README.md
https://github.com/GoogleCloudDataproc/initialization-actions/blob/master/oozie/README.md
"""


def create_dataproc_config(project_id, cluster_name, region, staging_bucket=None, tmp_bucket=None):
    return {
        "project_id": project_id,
        "cluster_name": cluster_name,
        "config": {
            "config_bucket": staging_bucket,
            "temp_bucket": tmp_bucket,
            "master_config": {
                "num_instances": 1,
                "machine_type_uri": "n2-standard-8",
                "disk_config": {
                    "boot_disk_size_gb": 500,
                    "num_local_ssds": 0
                }
            },
            "gce_cluster_config": {
                "zone_uri": f"https://www.googleapis.com/compute/v1/projects/{project_id}/zones/{region}-a",
                "service_account_scopes": [
                    "https://www.googleapis.com/auth/cloud-platform",
                    "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
                    "https://www.googleapis.com/auth/devstorage.read_write",
                    "https://www.googleapis.com/auth/logging.write"
                ],
                "metadata": {
                    "run-on-master": "true",
                    "kafka-enable-jmx": "true"
                },
                "subnetwork_uri": f"https://www.googleapis.com/compute/v1/projects/{project_id}/regions/{region}/subnetworks/default"
            },
            "worker_config": {
                "num_instances": 2,
                "machine_type_uri": "n2-standard-8",
                "disk_config": {
                    "boot_disk_size_gb": 500,
                    "num_local_ssds": 0
                }
            },
            "software_config": {
                "image_version": '1.5-ubuntu18',
                "properties": {
                    # https://cloud.google.com/dataproc/docs/concepts/configuring-clusters/cluster-properties
                },
                "optional_components": [
                    Component.ANACONDA,
                    # Component.JUPYTER,
                    Component.ZEPPELIN,
                    Component.ZOOKEEPER,
                    Component.SOLR
                ]
            },
            "initialization_actions": [
                {
                    "executable_file": f'gs://goog-dataproc-initialization-actions-{region}/kafka/kafka.sh',
                    "execution_timeout": Duration().FromTimedelta(timedelta(minutes=10))
                },
                {
                    "executable_file": f'gs://goog-dataproc-initialization-actions-{region}/oozie/oozie.sh',
                    "execution_timeout": Duration().FromTimedelta(timedelta(minutes=10))
                }
            ],
            "endpoint_config": {
                "enable_http_port_access": True
            },
            'lifecycle_config': {
                'idle_delete_ttl': Duration().FromTimedelta(timedelta(hours=1))
            }
        },
    }
