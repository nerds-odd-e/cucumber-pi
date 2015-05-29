#!/bin/bash
set -e

LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get --force-yes -y install php5 php5-mysql
