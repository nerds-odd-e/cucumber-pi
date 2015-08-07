#!/bin/bash

cat > /usr/bin/keyipinglun <<EOF
#!/bin/bash
set -ex

wp option set default_comment_status open
EOF

chmod +x /usr/bin/keyipinglun
