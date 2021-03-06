<?php
// SITE_ROOT contains the full path to the hatshop folder
define('SITE_ROOT', dirname(dirname(__FILE__)));

// Application directories
define('PRESENTATION_DIR', SITE_ROOT . '/presentation/');
define('BUSINESS_DIR', SITE_ROOT . '/business/');

// Settings needed to configure the Smarty template engine
define('SMARTY_DIR', SITE_ROOT . '/libs/smarty/');
define('TEMPLATE_DIR', PRESENTATION_DIR . '/templates/');
define('COMPILE_DIR', PRESENTATION_DIR . '/templates_c/');
define('CONFIG_DIR', SITE_ROOT . '/include/configs');

// These should be true while developing the web site
define('IS_WARNING_FATAL', TRUE);
define('DEBUGGING', TRUE);

// The error types to be reported
define('ERROR_TYPES', E_ALL);

// Settings about mailing the error massages to admin
define('SEND_ERROR_MAIL', FALSE);
define('ADMIN_ERROR_MAIL', 'dipolukarov@gmail.com');
define('SENDMAIL_FROM', 'errors@example.com');
ini_set('sendmail_from', SENDMAIL_FROM);

// By default we don't log errors to a file
define('LOG_ERRORS', FALSE);
define('LOG_ERRORS_FILE', '/var/tmp/hatshop_errors.log');

// Generic error message to be displayed instead of debug info (when DEBUGGING is false)
define('SITE_GENERIC_ERROR_MESSAGE', '<h2>HatShop Error!</h2>');

// Database login info
define('DB_PERSISTENCY', 'true');
define('DB_SERVER', 'localhost');
define('DB_USERNAME', 'hatshopadmin');
define('DB_PASSWORD', '777');
define('DB_DATABASE', 'hatshop');
define('PDO_DSN', 'pgsql:host=' . DB_SERVER . ';dbname=' . DB_DATABASE);

// Server HTTP port (can omit if the default 80 is used)
define('HTTP_SERVER_PORT', '80');
/* Name of the virtual directory the site runs in, for example:
 * '/hatshop/' if the site runs at http://www.example.com/hatshop/
 * '/' is the site runs at http://www.example.com/
 */
define('VIRTUAL_LOCATION', '/hatshop/');
// We enable and enforce SSL when this is set to anything alse than 'no'
define('USE_SSL', 'yes');

// Configure product lists display options
define('SHORT_PRODUCT_DESCRIPTION_LENGTH', 150);
define('PRODUCTS_PER_PAGE', 4);

// Administration login information
define('ADMIN_USERNAME', 'hatshopadmin');
define('ADMIN_PASSWORD', '777');

