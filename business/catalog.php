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
	public static function GetProductDetails($productId)
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

	// Flags stop words in search query
	public static function FlagStopWords($words)
	{
		// build SQL query
		$sql = 'SELECT * FROM catalog_flag_stop_words(:words);';
		// Build the parameters array
		$params = [':words' => '{' . implode(', ', $words) . '}'];
		// Prepare the statement with PDO-specific functionality
		$result = DatabaseHandler::Prepare($sql);

		// Execute the query
		$flags = DatabaseHandler::GetAll($result, $params);

		$search_words = ['accepted_words' => [], 'ignored_words' => []];

		for ($i = 0; $i < count($flags); $i++)
			if ($flags[$i]['catalog_flag_stop_words'])
				$search_words['ignored_words'][] = $words[$i];
			else
				$search_words['accepted_words'][] = $words[$i];

		return $search_words;
	}

	// Search the catalog
	public static function Search($searchString, $allWords, $pageNo, &$rHowManyPages)
	{
		// The search results will be an array of this form
		$search_result = ['accepted_words' => [], 'ignored_words' => [], 'products' => []];
		// Return void result if the search string is void
		if (empty($searchString))
			return $search_result;

		// Search string delimiters
		$delimiters = ',.; ';
		// Use strtok to get the first word of the search string
		$word = strtok($searchString, $delimiters);
		$words = [];

		// Build words array
		while ($word) {
			$words[] = $word;
			// Get the next word of the search string
			$word = strtok($delimiters);
		}

		// Split the search words in two categories: accepted and ignored
		$search_words = Catalog::FlagStopWords($words);
		$search_result['accepted_words'] = $search_words['accepted_words'];
		$search_result['ignored_words'] = $search_words['ignored_words'];

		// Return void result if all words are stop words
		if (count($search_result['accepted_words']) == 0)
			return $search_result;

		// Count the number of search results
		$sql = 'SELECT catalog_count_search_result(:words, :all_words);';
		$params = [
			':words'	=> '{' . implode(', ', $search_result['accepted_words']) . '}',
			':all_words'	=> $allWords
		];
		// Calculate the number of pages required to displey the products
		$rHowManyPages = Catalog::HowManyPages($sql, $params);
		// Calculate the start item
		$start_item = ($pageNo - 1) * PRODUCTS_PER_PAGE;

		// Retrieve the list of matching products
		$sql = 'SELECT * FROM catalog_search(:words, :all_words, :short_product_description_length, :products_per_page, :start_page);';
		$params = [
			':words'				=> '{' . implode(', ', $search_result['accepted_words']) . '}',
			':all_words'				=> $allWords,
			':short_product_description_length'	=> SHORT_PRODUCT_DESCRIPTION_LENGTH,
			':products_per_page'			=> PRODUCTS_PER_PAGE,
			':start_page'				=> $start_item
		];

		// Prepare and execute the query, and return the results
		$result = DatabaseHandler::Prepare($sql);
		$search_result['products'] = DatabaseHandler::GetAll($result, $params);
		return $search_result;
	}

	// Retrieves all departments with their descriptions
	public static function GetDepartmentsWithDescriptions()
	{
		// Build the SQL query
		$sql = ' SELECT * FROM catalog_get_departments(); ';
		// Prepare the statement with PDO-specific functionality
		$result = DatabaseHandler::Prepare($sql);

		return DatabaseHandler::GetAll($result);
	}

	// Updates department details
	public static function UpdateDepartment($departmentId, $departmentName, $departmentDescription)
	{
		// Build the SQL query
		$sql = ' SELECT catalog_update_department(:department_id, :department_name, :department_description); ';
		// Build the parameters array
		$params = [
			':department_id'		=> $departmentId,
			':department_name'		=> $departmentName,
			':department_description'	=> $departmentDescription
		];
		// Prepare the statement with PDO-specific functionality
		$result = DatabaseHandler::Prepare($sql);

		// Execute the query
		return DatabaseHandler::Execute($result, $params);
	}

	// Deletes a department
	public static function DeleteDepartment($departmentId)
	{
		// Build the SQL query
		$sql = ' SELECT catalog_delete_department(:department_id); ';
		// Build the parameters array
		$params = [':department_id' => $departmentId];
		// Prepare the statement with PDO-specific functionality
		$result = DatabaseHandler::Prepare($sql);

		// Execute the query and return the results
		return DatabaseHandler::GetOne($result, $params);
	}

	// Add a department
	public static function AddDepartment($departmentName, $departmentDescription)
	{
		// Build the SQL query
		$sql = ' SELECT catalog_add_department(:department_name, :department_description); ';
		// Build the parameters array
		$params = [
			':department_name'		=> $departmentName,
			':department_description'	=> $departmentDescription
		];
		// Prepare the statement with PDO-specific functionality
		$result = DatabaseHandler::Prepare($sql);

		// Execute the query
		return DatabaseHandler::Execute($result, $params);
	}

}

