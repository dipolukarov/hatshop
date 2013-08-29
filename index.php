<?php
// Load Smarty library and config files
require_once 'include/app_top.php';

// Load Smarty template file
$page = new Page;

// Define the template file for the page contents
$pageContentsCell = 'blank.tpl';

// Define the template file for the categories cell
$categoriesCell = 'blank.tpl';

// Load department details if visiting a department
if (isset($_GET['DepartmentID'])) {
	$pageContentsCell	= 'department.tpl';
	$categoriesCell		= 'categories_list.tpl';
}

// Assign a template file to the page contents cell
$page->assign('pageContentsCell', $pageContentsCell);
$page->assign('categoriesCell', $categoriesCell);

// Display the page
$page->display('index.tpl');

// Load app_bottom which closes the database connection
require_once 'include/app_bottom.php';

