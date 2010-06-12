<?php 
set_include_path(implode(PATH_SEPARATOR, array(
	'/usr/share/php',
	'/usr/share/php/Zend/trunk/library',
	'/usr/share/php/KontorX/trunk'
)));

// Define path to application directory
defined('APPLICATION_PATH')
    || define('APPLICATION_PATH', realpath(dirname(__FILE__) . '/../../application'));

// Define application environment
defined('APPLICATION_ENV')
    || define('APPLICATION_ENV', (getenv('APPLICATION_ENV') ? getenv('APPLICATION_ENV') : 'testing'));

require_once 'Zend/Loader/Autoloader.php';
$autoload = Zend_Loader_Autoloader::getInstance();
spl_autoload_register(array($autoload,'autoload'));