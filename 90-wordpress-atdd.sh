#!/bin/bash
set -e

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

add_atdd_script tianjiayonghu <<EOF
#!/bin/bash
set -e
WPUSER="\$1"
WPUSERROLE="\${2:-subscriber}"
WPUSERPASSWD="\${WPUSER}1234"
if [[ -z "\$WPUSER" ]]; then
    echo "Usage:"
    echo "    \$(basename "\$0") username [subscriber|contributor|author|editor|administrator]"
    exit 1
fi

wp user create "\$WPUSER" "\$WPUSER"@example.com --role="\${WPUSERROLE}" --user_pass="\$WPUSERPASSWD"
echo "  Username: \$WPUSER"
echo "  Password: \$WPUSERPASSWD"
echo "      Role: \$WPUSERROLE"
EOF

add_atdd_script xinzengbianjiyonghu <<EOF
#!/bin/bash
set -e
WPUSER="\$1"
if [[ -z "\$WPUSER" ]]; then
    echo "Usage:"
    echo "    \$(basename "\$0") username"
    exit 1
fi
tianjiayonghu "\${WPUSER}" editor
EOF

add_atdd_script shanchuyonghu <<EOF
#!/bin/bash
set -e
WPUSER="\$1"
if [[ -z "\$WPUSER" ]]; then
    echo "Usage:"
    echo "    \$(basename "\$0") username"
    exit 1
fi

wp user delete "\$WPUSER" --yes
EOF
