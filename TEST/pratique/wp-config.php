<?php
// ===================================================
// Database settings - from docker-compose/.env
// ===================================================
define( 'DB_NAME', getenv('WORDPRESS_DB_NAME') ?: 'inception' );
define( 'DB_USER', getenv('WORDPRESS_DB_USER') ?: 'dbuser' );
define( 'DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD') ?: 'dbPass' );
define( 'DB_HOST', getenv('WORDPRESS_DB_HOST') ?: 'mariadb:3306' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

// ===================================================
// Security Keys (à générer avec https://api.wordpress.org/secret-key/1.1/salt/)
// ===================================================
define('AUTH_KEY',         'replace-me');
define('SECURE_AUTH_KEY',  'replace-me');
define('LOGGED_IN_KEY',    'replace-me');
define('NONCE_KEY',        'replace-me');
define('AUTH_SALT',        'replace-me');
define('SECURE_AUTH_SALT', 'replace-me');
define('LOGGED_IN_SALT',   'replace-me');
define('NONCE_SALT',       'replace-me');

// ===================================================
// Table prefix
// ===================================================
$table_prefix = 'wp_';

// ===================================================
// Debug mode
// ===================================================
define( 'WP_DEBUG', false );

// ===================================================
// Absolute path
// ===================================================
if ( !defined('ABSPATH') ) {
    define('ABSPATH', __DIR__ . '/');
}
require_once ABSPATH . 'wp-settings.php';
