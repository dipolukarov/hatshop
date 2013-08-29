<?php
/**
 * Business tier class for reading product catalog information
 */
class Catalog
{

	// Retrieves all departments
	public static function GetDepartments()
	{
		// Build SQL query
		$sql = 'SELECT * FROM catalog_get_departments_list();';

		// Prepare the statement with PDO-specific functionality
		$result = DatabaseHandler::Prepare($sql);

		// Execute the query and return the results
		return DatabaseHandler::GetAll($result);
	}

	// Retrieves complete details for the specified department
	public static function GetDepartmentDetails($departmentId)
	{
		// Build SQL query
		$sql = 'SELECT * FROM catalog_get_department_details(:department_id);';
		// Build the parameters array
		$params = [':department_id' => $departmentId];
		// Prepare the statement with PDO-specific functionality
		$result = DatabaseHandler::Prepare($sql);

		// Execute the query and return the results
		return DatabaseHandler::GetRow($result, $params);
	}

	// Retrieves list of categories that belong to a department
	public static function GetCategoriesInDepartment($departmentId)
	{
		// Build SQL query
		$sql = 'SELECT * FROM catalog_get_categories_list(:department_id);';
		// Build the parameters array
		$params = [':department_id' => $departmentId];
		// Prepare the statement with PDO-specific functionality
		$result = DatabaseHandler::Prepare($sql);

		// Execute the query and return the results
		return DatabaseHandler::GetAll($result, $params);
	}

	// Retrieves complete details for the specified category
	public static function GetCategoryDetails($categoryId)
	{
		// Build SQL query
		$sql = 'SELECT * FROM catalog_get_category_details(:categoryId);';
		// Build the parameters array
		$params = [':categoryId' => $categoryId];
		// Prepare the statement with PDO-specific functionality
		$result = DatabaseHandler::Prepare($sql);

		// Execute the query and return the results
		return DatabaseHandler::GetRow($result, $params);
	}

	// Calculates how many pages of products could be filled by the number of products returned by the $countSql query
	public static function HowManyPages($countSql, $countSqlParams)
	{
		// Create a hash for the sql query
		$queryHashCode = md5($countSql . var_export($countSqlParams, TRUE));

		// Verify if we have the query results in cache
		if (isset($_SESSION['last_count_hash']) && isset($_SESSION['how_many_pages']) && $_SESSION['last_count_hash'] === $queryHashCode) {
			// Retrieve the cached value
			$how_many_pages = $_SESSION['how_many_pages'];
		} else {
			// Execute the query
			$prepared = DatabaseHandler::Prepare($countSql);
			$items_count = DatabaseHandler::GetOne($prepared, $countSqlParams);

			// Calculate the number of pages
			$how_many_pages = ceil($items_count / PRODUCTS_PER_PAGE);

			// Save the query and its count result in the session
			$_SESSION['last_count_hash']	= $queryHashCode;
			$_SESSION['how_many_pages']	= $how_many_pages;
		}

		// Return the number of pages
		return $how_many_pages;
	}

	// Retrieves list of products that belong to a category
	public static function GetProductsInCategory($categoryId, $pageNo, &$rHowManyPages)
	{
		// Query that returns the number of products in the category
		$sql = 'SELECT catalog_count_products_in_category(:category_id);';
		$params = [':category_id' => $categoryId];
		// Calculate the number of pages required to display the products
		$rHowManyPages = Catalog::HowManyPages($sql, $params);
		// Calculate the start item
		$start_item = ($pageNo - 1) * PRODUCTS_PER_PAGE;

		// Retrieve the list of products
		$sql = 'SELECT * FROM catalog_get_products_in_category(:category_id, :short_product_description_length, :products_per_page, :start_item);';
		$params = [
			':category_id'				=> $categoryId,
			':short_product_description_length'	=> SHORT_PRODUCT_DESCRIPTION_LENGTH,
			':products_per_page'			=> PRODUCTS_PER_PAGE,
			':start_item'				=> $start_item
		];
		$result = DatabaseHandler::Prepare($sql);

		// Execute the query and return the results
		return DatabaseHandler::GetAll($result, $params);
	}

	// Retrieves the list of products for the department page
	public static function GetProductsOnDepartmentDisplay($departmentId, $pageNo, &$rHowManyPages)
	{
		// Query that returns the number of products in the department page
		$sql = 'SELECT catalog_count_products_on_department(:department_id);';
		$params = [':department_id' => $departmentId];
		// Calculate the number of pages required to display the products
		$rHowManyPages = Catalog::HowManyPages($sql, $params);
		// Calculate the start item
		$start_item = ($pageNo - 1) * PRODUCTS_PER_PAGE;

		// Retrieve the list of products
		$sql = 'SELECT * FROM catalog_get_products_on_department(:department_id, :short_product_description_length, :products_per_page, :start_item);';
		$params = [
			':department_id'			=> $departmentId,
			':short_product_description_length'	=> SHORT_PRODUCT_DESCRIPTION_LENGTH,
			':products_per_page'			=> PRODUCTS_PER_PAGE,
			':start_item'				=> $start_item
		];
		$result = DatabaseHandler::Prepare($sql);

		// Execute the query and return the results
		return DatabaseHandler::GetAll($result, $params);
	}

	// Retrieves the list of products on catalog display
	public static function GetProductsOnCatalogDisplay($pageNo, &$rHowManyPages)
	{
		// Query that returns the number of products for the front catalog page
		$sql = 'SELECT catalog_count_products_on_catalog();';
		// Calculate the number of pages required to display the products
		$rHowManyPages = Catalog::HowManyPages($sql, NULL);
		// Calculate the start item
		$start_item = ($pageNo - 1) * PRODUCTS_PER_PAGE;

		// Retrieve the list of products
		$sql = 'SELECT * FROM catalog_get_products_on_catalog(:short_product_description_length, :products_per_page, :start_item);';
		$params = [
			':short_product_description_length'	=> SHORT_PRODUCT_DESCRIPTION_LENGTH,
			':products_per_page'			=> PRODUCTS_PER_PAGE,
			':start_item'				=> $start_item
		];
		$result = DatabaseHandler::Prepare($sql);

		// Execute the query and return the results
		return DatabaseHandler::GetAll($result, $params);
	}

	// Retrieves complete product details
	public static function GetProductsDetails($productId)
	{
		// Build SQL query
		$sql = 'SELECT * FROM catalog_get_product_details(:product_id);';
		// Build the parameters array
		$params = [':product_id' => $productId];
		// Prepare the statement with PDO-specific functionality
		$result = DatabaseHandler::Prepare($sql);

		// Execute the query and return the results
		return DatabaseHandler::GetRow($result, $params);
	}

}

