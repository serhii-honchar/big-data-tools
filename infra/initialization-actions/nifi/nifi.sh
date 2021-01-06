#!/bin/bash

set -euxo pipefail

function get_metadata_attribute() {
  local -r attribute_name=$1
  local -r default_value=$2
  /usr/share/google/get_metadata_value "attributes/${attribute_name}" || echo -n "${default_value}"
}

readonly DEFAULT_NIFI_VERSION="1.12.1"
readonly NIFI_VERSION=$(get_metadata_attribute 'nifi-version' ${DEFAULT_NIFI_VERSION})

readonly "BASE_URL=https://archive.apache.org/dist"
readonly NIFI_BINARY_PATH=/nifi/${NIFI_VERSION}/nifi-${NIFI_VERSION}-bin.tar.gz
readonly NIFI_TOOLKIT_BINARY_PATH=/nifi/${NIFI_VERSION}/nifi-toolkit-${NIFI_VERSION}-bin.tar.gz

readonly NIFI_BASE_DIR=/opt/nifi
readonly NIFI_HOME=${NIFI_BASE_DIR}/nifi-current
readonly NIFI_TOOLKIT_HOME=${NIFI_BASE_DIR}/nifi-toolkit-current
readonly NIFI_PROPS_FILE=${NIFI_HOME}/conf/nifi.properties

function execute_with_retries() {
  local -r cmd=$1
  for ((i = 0; i < 10; i++)); do
    if eval "$cmd"; then
      return 0
    fi
    sleep 5
  done
  return 1
}

function retry_apt_command() {
  cmd="$1"
  for ((i = 0; i < 10; i++)); do
    if eval "$cmd"; then
      return 0
    fi
    sleep 5
  done
  return 1
}

function update_apt_get() {
  retry_apt_command "apt-get update"
}

function install_apt_get() {
  pkgs="$@"
  retry_apt_command "apt-get install -y $pkgs"
}

function prop_replace () {
  target_file=${3:-${NIFI_PROPS_FILE}}
  echo 'replacing target file ' ${target_file}
  sed -i -e "s|^$1=.*$|$1=$2|"  ${target_file}
}

function install_and_configure_nifi() {
    # Setup NiFi user and create necessary directories
    useradd --shell /bin/bash -m nifi
    mkdir -p ${NIFI_BASE_DIR}
    chown -R nifi:nifi ${NIFI_BASE_DIR}

    update_apt_get
    install_apt_get jq xmlstarlet procps

    # Download, validate, and expand Apache NiFi Toolkit binary.
    wget -nv --timeout=30 --tries=5 --retry-connrefused \
        ${BASE_URL}/${NIFI_TOOLKIT_BINARY_PATH} \
        -O ${NIFI_BASE_DIR}/nifi-toolkit-${NIFI_VERSION}-bin.tar.gz
    echo "$(curl ${BASE_URL}/${NIFI_TOOLKIT_BINARY_PATH}.sha256) *${NIFI_BASE_DIR}/nifi-toolkit-${NIFI_VERSION}-bin.tar.gz" | sha256sum -c -
    tar -xf ${NIFI_BASE_DIR}/nifi-toolkit-${NIFI_VERSION}-bin.tar.gz -C ${NIFI_BASE_DIR}
    rm ${NIFI_BASE_DIR}/nifi-toolkit-${NIFI_VERSION}-bin.tar.gz
    mv ${NIFI_BASE_DIR}/nifi-toolkit-${NIFI_VERSION} ${NIFI_TOOLKIT_HOME}
    ln -s ${NIFI_TOOLKIT_HOME} ${NIFI_BASE_DIR}/nifi-toolkit-${NIFI_VERSION}
    chown -R nifi.nifi ${NIFI_TOOLKIT_HOME}

    # Download, validate, and expand Apache NiFi binary.
    wget -nv --timeout=30 --tries=5 --retry-connrefused \
        ${BASE_URL}/${NIFI_BINARY_PATH} \
        -O ${NIFI_BASE_DIR}/nifi-${NIFI_VERSION}-bin.tar.gz
    echo "$(curl ${BASE_URL}/${NIFI_BINARY_PATH}.sha256) *${NIFI_BASE_DIR}/nifi-${NIFI_VERSION}-bin.tar.gz" | sha256sum -c -
    tar -xf ${NIFI_BASE_DIR}/nifi-${NIFI_VERSION}-bin.tar.gz -C ${NIFI_BASE_DIR}
    rm ${NIFI_BASE_DIR}/nifi-${NIFI_VERSION}-bin.tar.gz
    mv ${NIFI_BASE_DIR}/nifi-${NIFI_VERSION} ${NIFI_HOME}
    ln -s ${NIFI_HOME} ${NIFI_BASE_DIR}/nifi-${NIFI_VERSION}
    chown -R nifi.nifi ${NIFI_HOME}

    # Configure web port
    prop_replace 'nifi.web.http.port' '8081'

    # Install NiFi Service
    cat <<EOF >/etc/systemd/system/nifi.service
[Unit]
Description=Apache NiFi
After=network.target

[Service]
Type=forking
User=nifi
Group=nifi
ExecStart=/opt/nifi/nifi-current/bin/nifi.sh start
ExecStop=/opt/nifi/nifi-current/bin/nifi.sh stop
ExecRestart=/opt/nifi-current/bin/nifi.sh restart

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload || err 'Unable to reload daemons.'
}

function main() {
  local role
  role="$(/usr/share/google/get_metadata_value attributes/dataproc-role)"

  # Only run the installation on master nodes
  if [[ "${role}" == 'Master' ]]; then
    install_and_configure_nifi
    systemctl start nifi || err 'Unable to start nifi service.'
  fi
}

main