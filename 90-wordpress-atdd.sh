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

add_atdd_script shanchupinglun <<EOF
#!/bin/bash
set -e
if [[ -z "\$1" ]]; then
    echo "Usage:"
    echo "    \$(basename "\$0") user@example.com"
    exit 1
fi
wp comment delete \$(wp comment list --format=ids --author_email="\$1") --force
EOF

add_atdd_script xinzengbianjiyonghu <<EOF
#!/bin/bash
set -e
WPUSER="$1"
if [[ -z "\$WPUSER" ]]; then
    echo "Usage:"
    echo "    \$(basename "\$0") username"
    exit 1
fi

wp user create "$WPUSER" "$WPUSER"@example.com --role=editor --user_pass="$WPUSER"1234
EOF
