"""
gcloud Reference: https://cloud.google.com/sdk/gcloud/reference/composer/environments
Composer GCS bucket policy https://cloud.google.com/composer/docs/concepts/cloud-storage
"""


def create_env(region, env_name):
    from subprocess import check_output
    check_output([
        'gcloud',
        'composer',
        'environments',
        'create',
        f'{env_name}',
        f'--location={region}',
        '--disk-size=20GB',
        '--image-version=composer-1.12.0-airflow-1.10.10',
        '--machine-type=n1-standard-2',
        f'--zone={region}-a',
        '--network=default',
        '--node-count=3',
        '--python-version=3'
    ])

    print(f'Env created successfully: {env_name}')


def shutdown_env(region, env_name):
    from subprocess import check_output
    check_output([
        'gcloud',
        'composer',
        'environments',
        'delete',
        f'{env_name}',
        f'--location={region}',
        '--quiet'
    ])
    print('Env {} successfully deleted.'.format(env_name))


if __name__ == '__main__':
    from argparse import ArgumentParser

    parser = ArgumentParser()
    subparsers = parser.add_subparsers(dest='command')
    create_env_parser = subparsers.add_parser('create-env')
    create_env_parser.add_argument('--region', required=True)
    create_env_parser.add_argument('--env-name', required=True)

    shutdown_env_parser = subparsers.add_parser('shutdown-env')
    shutdown_env_parser.add_argument('--region', required=True)
    shutdown_env_parser.add_argument('--env-name', required=True)

    args = parser.parse_args()
    if args.command == 'create-env':
        create_env(args.region, args.env_name)
    if args.command == 'shutdown-env':
        shutdown_env(args.region, args.env_name)
