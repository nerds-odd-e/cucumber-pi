#!/bin/bash
set -ex

function add_atdd_script() {
    ATDD_SCRIPT_NAME="$1"

    cat > /usr/bin/"$ATDD_SCRIPT_NAME"

    chmod +x /usr/bin/"$ATDD_SCRIPT_NAME"
}

add_atdd_script keyipinglun <<EOF
#!/bin/bash
set -ex
wp post update 1 6 7 8 9 --comment_status=open
wp option set default_comment_status open
EOF

add_atdd_script jinzhipinglun <<EOF
#!/bin/bash
set -ex
wp post update 1 6 7 8 9 --comment_status=closed
wp option set default_comment_status closed
EOF
