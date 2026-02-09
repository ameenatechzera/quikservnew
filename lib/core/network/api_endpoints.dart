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
    return '$baseUrl/salesmaster/save-salesmasterNew';
  }

  ///for sales report
  static String getFetchSalesReportPath(String baseUrl) {
    return '$baseUrl/salesmaster/get-salesmaster-date';
  }

  ///for sales details
  static String getFetchSalesDetailsReportPath(String baseUrl) {
    return '$baseUrl/salesmaster/get-salesmaster';
  }

  //for Saveunit
  static String saveUnitPath(String baseUrl) {
    return '$baseUrl/unit/save-unit';
  }

  //for Saveunit
  static String deleteUnitPath(String baseUrl, int unitId) {
    return '$baseUrl/unit/delete-unit/$unitId';
  }

  static String editUnitPath(String baseUrl, int unitId) {
    return '$baseUrl/unit/update-unit/$unitId';
  }

  static String saveProductGroupPath(String baseUrl) {
    return '$baseUrl/group/save-group';
  }

  static String deleteProductGroupPath(String baseUrl, int groupId) {
    return '$baseUrl/group/delete-group/$groupId';
  }

  static String editProductGroupPath(String baseUrl, int groupId) {
    return '$baseUrl/group/update-group/$groupId';
  }

  static String addVatPath(String baseUrl) {
    return '$baseUrl/vat/save-vat';
  }

  static String deleteVatPath(String baseUrl, int vatId) {
    return '$baseUrl/vat/delete-vat/$vatId';
  }

  static String editVatPath(String baseUrl, int vatId) {
    return '$baseUrl/vat/update-vat/$vatId';
  }

  static String saveCategoryPath(String baseUrl) {
    return '$baseUrl/category/save-category';
  }

  //reset sales Token
  static String resetSalesTokenPath(String baseUrl) {
    return '$baseUrl/salesmaster/reset-sales-token/1';
  }

  static String fetchSalesTokenPath(String baseUrl) {
    return '$baseUrl/settings/fetch-salesToken/1';
  }

  static String updateSalesTokenPath(String baseUrl) {
    return '$baseUrl/settings/update-salesToken';
  }

  static String deleteSalesByMasterIdPath(String baseUrl, String masterId) {
    return '$baseUrl/salesmaster/delete-salesmaster/$masterId';
  }

  static String deleteCategoryPath(String baseUrl, int categoryId) {
    return '$baseUrl/category/delete-category/$categoryId';
  }

  static String editCategoryPath(String baseUrl, int categoryId) {
    return "$baseUrl/category/update-category/$categoryId";
  }

  ///for userTypes fetching
  static String getUserTypesPath(String baseUrl) {
    return '$baseUrl/user/fetch-usertypes';
  }

  ///for user save
  static String saveUserPath(String baseUrl) {
    return '$baseUrl/user/save-user';
  }

  ///for Product save
  static String saveProductPath(String baseUrl) {
    return '$baseUrl/product/save-product';
  }

  ///for Product delete
  static String deleteProductPath(String baseUrl, int productCode) {
    return '$baseUrl/product/delete-product/$productCode';
  }

  static String updateProductPath(String baseUrl, int productCode) {
    return "$baseUrl/product/update-product/$productCode";
  }

  ///for fethcingaccountledger
  static String getAccountLedgerPath(String baseUrl) {
    return '$baseUrl/accountledger/all-account-ledgers';
  }

  static String deleteAccountLedgerPath(String baseUrl, int ledgerId) {
    return "$baseUrl/accountledger/delete-account-ledger/$ledgerId";
  }

  ///for cashier fetch
  static String fetchCashierListPath(String baseUrl) {
    return '$baseUrl/user/fetch-cashiers';
  }

  ///for suppliers fetch
  static String fetchSupplierListPath(String baseUrl) {
    return '$baseUrl/user/fetch-suppliers';
  }

  ///for itemwise report
  static String getFetchItemWiseReportPath(String baseUrl) {
    return '$baseUrl/salesmaster/item-wise-sales-summary';
  }

  ///for Day close report
  static String getDayCloseReportPath(String baseUrl) {
    return '$baseUrl/salesmaster/summary-report-payment-mode';
  }

  ///for Account Groups
  static String getAccountGroupsPath(String baseUrl) {
    return '$baseUrl/accountgroup/accountgroups';
  }

  ///for Save Account Groups
  static String getSaveAccountGroupsPath(String baseUrl) {
    return '$baseUrl/accountgroup/save-accountgroup';
  }

  //for Delete Account Groups
  static String getDeleteAccountGroupsPath(
    String baseUrl,
    String st_accountGroupId,
  ) {
    return '$baseUrl/accountgroup/delete-accountgroup/' + st_accountGroupId;
  }

  ///for Update Account Groups
  static String getUpdateAccountGroupsPath(
    String baseUrl,
    String st_accountGroupId,
  ) {
    return '$baseUrl/accountgroup/update-accountgroup/' + st_accountGroupId;
  }

  ///for Save Account Groups
  static String saveAccountLedgerPath(String baseUrl) {
    return '$baseUrl/accountledger/save-account-ledger';
  }

  static String updateAccountLedgerPath(String baseUrl, int ledgerId) {
    return "$baseUrl/accountledger/update-account-ledger/$ledgerId";
  }

  ///for Save Account settings

  static String saveAccountSettingsPath(String baseUrl, int id) {
    return '$baseUrl/settings/update-ledger_settings/$id';
  }

  ///for fethcing bank accountledger
  static String getBankAccountLedgerPath(String baseUrl) {
    return '$baseUrl/accountledger/bank-account-ledgers';
  }

  ///for changepassword
  static String getChangePasswordPath(String baseUrl) {
    return '$baseUrl/change-password';
  }
}
