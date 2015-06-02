#!/bin/bash
set -e

adding_public_key() {
    _USER=$1
    _HOME=$2

    id "$_USER" || return 0
    [[ -d "${_HOME}" ]] || return 0

    _SSH_DIR=${_HOME}/.ssh
    _AUTH_FILE=${_SSH_DIR}/authorized_keys

    mkdir -p "${_SSH_DIR}"
    [[ -f "${_AUTH_FILE}" ]] || touch "${_AUTH_FILE}"

fgrep chaifeng "${_AUTH_FILE}" || cat >> "${_AUTH_FILE}" <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDtKJbO7d17s72xTSLl6jL11aFvQWyCbwjQ5pZ1LmGRCHcS7iKM3YOV6e+U4eWQICSEkCFelrlxcMywOBRf9LycUoTBZDcrQyg3r91ekc1F4NeUy0KZre021OG89y8byNVPJUKKCCoOSR04A8yjhDlgGXb31QA22vZwr5Bet6D9Sx/LczDZ4IYe0ow2NAsCTHOxukHKBY+PDXVrdwN1wdop+FbmbMYjB/jbmjC2zwpD0JWHn7HidAmexOSrG1N2OWcfjWJbnVVt5y2uWjZTJxFR82Zjz4ZKZlZcEus6HSpxc2qbhhNrwAaP2TpksIqssfRUF6IVFz+xwzJQWiKNBCKN8P/4vHP1OLEc+dvnAwaF2EKkcxs1i6Yt+TrDGKVNqbn7TsKPWedCXveK+S0kAR48pLwmX5kN95of8SMoegjAcp4QP0GKZz6DVvlzUg5uObAQ8l9C5On6LRPQ2Bi6jLMpJDoX5l6jPQHmpFOURts29+s2ZaZcXvmxpXbANaFj8L38IZCv3/46rUcWtBWH1/uXArHTOBwNnA79ZRWljwZA3XnG+vEseU9yytkV+/ggfPn9/NilPZWBOxsbcWLaiQxf3mLinMG0MmOBRWqSH2FYqIHqM1fJutAH5MnWkB/8/IwC4X0mKtAhjTHyp2HVjOT1aVOil2OwjU9paWh0UFhq+Q== chaifeng
EOF

    chown -R $_USER ${_SSH_DIR}
    chmod -R go-rwx ${_SSH_DIR}
}


adding_public_key root     /root
adding_public_key pi       /home/pi
adding_public_key vagrant  /home/vagrant
