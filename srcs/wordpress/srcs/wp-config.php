<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
define( 'DB_USER', 'root' );

/** MySQL database password */
define( 'DB_PASSWORD', 'root' );

/** MySQL hostname */
define( 'DB_HOST', 'mysql-service' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '-B;Z=BECyj1:!-!W+n9%-k-<W.)>x(=Pe2!!CcHRamw5mxDGu^ya#euwzv<y*Hm>');
define('SECURE_AUTH_KEY',  '`p}HA,N^JM}R67-2x+[_?Z4_Hj  S+]:,!,+E?|/U/3 :1K4x^2%A/&e[,+W{2q3');
define('LOGGED_IN_KEY',    'pmmlypgZv;)h0qG{wYH`V+.PUQ1CPZ3CX AKd}sVU3al{iaNcH<-}g:FC}KK]+x{');
define('NONCE_KEY',        'KUy^IQb_85`8x?f4bJh:qZg=(+KM.|>mJ&+rsUZw5(sVOeogx(4:pbX!YO$mn4PC');
define('AUTH_SALT',        '3p76eKG[;`gaL!B)Q#gJ5Ho*%6jQC=!kx0@vk!-V;,U6O+yz^[Fs|g+pD!RdQpt@');
define('SECURE_AUTH_SALT', 'h,pbH|goEcTZ]@>0AJv{^4btjq!<uDQ}i[[b6G-a1=SkwBxp[sa<RJHH~S?bC29X');
define('LOGGED_IN_SALT',   '-9S1,%W6|[)M~%gN#7Nq4 LCl<{I-g6`S2W,eF8omC?WOpgDWB+[lPEp-YBal#7!');
define('NONCE_SALT',       '>q{&X/APkgEEQppBp4idIF]]sb}3OAm1Q3FUHhXS3vy=M+iFr}5OX^TSlS|8qjoL');


/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', true );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
