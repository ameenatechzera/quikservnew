class ApiConstants {
  // -------------------
  // Dynamic Endpoints
  // -------------------

  /// Returns the full URL for Register / Get Company endpoint
  static String getRegisterServerPath(String baseUrl) {
    return '$baseUrl/company/get-company';
  }

  /// Returns the full URL for Login endpoint
  static String getLoginPath(String baseUrl) {
    return '$baseUrl/login';
  }

  ///for units fetching
  static String getUnitsPath(String baseUrl) {
    return '$baseUrl/unit/units';
  }

  ///for vats fetching
  static String getVatPath(String baseUrl) {
    return '$baseUrl/vat/vat';
  }

  ///for groups fetching
  static String getGroupsPath(String baseUrl) {
    return '$baseUrl/group/groups';
  }

  ///for products fetching
  static String getProductsPath(String baseUrl) {
    return '$baseUrl/product/productsNew/1';
  }

  ///for settings fetching
  static String getSettingsPath(String baseUrl) {
    return '$baseUrl/settings/all-settings';
  }

  ///for categories fetching
  static String getCategoriesPath(String baseUrl) {
    return '$baseUrl/category/categories';
  }

  ///for saving sales
  static String getSaveSalePath(String baseUrl) {
    return '$baseUrl/salesmaster/save-salesmaster';
  }

  ///for sales report
  static String getFetchSalesReportPath(String baseUrl) {
    return '$baseUrl/salesmaster/get-salesmaster-date';
  }

  ///for sales details
  static String getFetchSalesDetailsReportPath(String baseUrl) {
    return '$baseUrl/salesmaster/get-salesmaster';
  }
}
