#!/bin/bash
set -e

WP_CLI_CMD=wp

$WP_CLI_CMD option update default_comment_status closed
$WP_CLI_CMD option update default_ping_status closed
$WP_CLI_CMD option update default_pingback_flag ''
$WP_CLI_CMD option update comment_registration  1
$WP_CLI_CMD option update comment_moderation    ''
$WP_CLI_CMD option update comment_whitelist     ''
$WP_CLI_CMD option update comments_notify   ''
$WP_CLI_CMD option update moderation_notify ''
$WP_CLI_CMD option update show_avatars      ''
$WP_CLI_CMD option update permalink_structure  "/%postname%/"
$WP_CLI_CMD post update 1 2 3 4 5 6 7 8 9 --comment_status=closed
$WP_CLI_CMD post update 1 2 3 4 5 6 7 8 9 --ping_status=closed
