#!/bin/bash

set -euxo pipefail

BIGDATA_TOOLS_DIR=/opt/bigdata-tools
BITSTAMP_TRUSTSTORE_URL="https://storage.googleapis.com/bigdata-tools/bigdata-tools/bitstamp.truststore"

function install_and_configure() {
    mkdir ${BIGDATA_TOOLS_DIR}
    chmod 775 ${BIGDATA_TOOLS_DIR}
    wget -P ${BIGDATA_TOOLS_DIR} ${BITSTAMP_TRUSTSTORE_URL}
    chmod 644 ${BIGDATA_TOOLS_DIR}/bitstamp.truststore
}

function main() {
  local role
  role="$(/usr/share/google/get_metadata_value attributes/dataproc-role)"

  # Only run the installation on master nodes
  if [[ "${role}" == 'Master' ]]; then
    install_and_configure
  fi
}

main