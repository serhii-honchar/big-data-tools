set -euxo pipefail

readonly SQOOP_HOME='/usr/lib/sqoop'
readonly MYSQL_JAR='/usr/share/java/mysql.jar'

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

function main() {
  local role
  role="$(/usr/share/google/get_metadata_value attributes/dataproc-role)"

  # Only run the installation on master nodes
  if [[ "${role}" == 'Master' ]]; then
    execute_with_retries "apt-get install -y -q sqoop"
    # Sqoop will use locally available MySQL JDBC driver
    ln -s "${MYSQL_JAR}" "${SQOOP_HOME}/lib/mysql.jar"
  fi
}

main
