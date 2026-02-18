import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ValueNotifier<int> itemTapBehaviorNotifier = ValueNotifier<int>(1);

class SharedPreferenceHelper {
  static const String _baseUrlKey = 'base_url';
  static const String _tokenKey = 'auth_token';
  static const String _databaseNameKey = 'database_name';
  static const String _vatStatusKey = 'vat_status';
  static const String _vatTypeKey = 'vat_type';
  static const _itemTapBehaviorKey = 'itemTapBehavior';
  static const _paymentOptionKey = 'payment_option';
  static const _kCashLedgerId = 'cash_ledger_id';
  static const _kCardLedgerId = 'card_ledger_id';
  static const _kBankLedgerId = 'bank_ledger_id';

  static const _kAppVersion = 'app_version';
  // ✅ GLOBAL NOTIFIER (this is what HomeScreen listens to)

  /// ------------------ BASE URL ------------------
  Future<void> setBaseUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_baseUrlKey, url);
  }

  Future<String?> getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_baseUrlKey);
  }

  /// ------------------ TOKEN ------------------
  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// ------------------ BranchID ------------------
  Future<bool> setBranchId(String branchId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString("branchId", branchId);
  }

  Future<String> getBranchId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("branchId") ?? '';
  }

  /// ------------------ Subscription Code ------------------
  Future<bool> setSubscriptionCode(String subCode) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString("subCode", subCode);
  }

  Future<String> getSubscriptionCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("subCode") ?? '';
  }

  ///companyname
  Future<void> setCompanyName(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('company_name', value);
  }

  Future<String?> getCompanyName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('company_name');
  }

  ///company Address 1
  Future<void> setCompanyAddress1(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('company_address_1', value);
  }

  Future<String?> getCompanyAddress1() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('company_address_1');
  }

  ///company Logo
  Future<void> setCompanyLogo(String? value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('company_logo', value!);
  }

  Future<String?> getCompanyLogo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('company_logo');
  }

  ///current Date
  Future<void> setCurrentDate(String? value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_date', value!);
  }

  Future<String?> getCurrentDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('current_date');
  }

  ///company Address 2
  Future<void> setCompanyAddress2(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('company_address_2', value);
  }

  Future<String?> getCompanyAddress2() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('company_address_2');
  }

  ///company Phone
  Future<void> setCompanyPhoneNo(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('company_phone', value);
  }

  Future<String?> getCompanyPhoneNo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('company_phone');
  }


  /// ------------------ setStaffName ------------------
  Future<bool> setStaffName(String staffName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString("staffName", staffName);
  }

  Future<String> getStaffName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("staffName") ?? '';
  }

  /// ------------------ setLogoutStatus ------------------
  Future<bool> setLogoutStatus(String logoutStatus) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString("logoutStatus", logoutStatus);
  }

  Future<String> getLogoutStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("logoutStatus") ?? '';
  }

  /// ------------------ DATABASE NAME ------------------
  Future<void> setDatabaseName(String dbName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_databaseNameKey, dbName);
  }

  Future<String?> getDatabaseName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_databaseNameKey);
  }

  //printer
  Future<bool> saveSelectedPrinter(String selectedPrinter) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString("selectedPrinter", selectedPrinter);
  }

  Future<String?> loadSelectedPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("selectedPrinter");
  }

  //printer
  Future<bool> saveSelectedPrinterSize(String printerSize) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString("printerSize", printerSize);
  }

  Future<String?> loadSelectedPrinterSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("printerSize");
  }

  //Company Font
  Future<bool> saveCompanyNameFontSize(String companyFontSize) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString("companyFontSize", companyFontSize);
  }

  Future<String?> fetchCompanyNameFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("companyFontSize");
  }


  //Description
  Future<bool> saveDescriptionPrint(String description) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString("description", description);
  }

  Future<String?> fetchDescriptionPrint() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("description");
  }

  //Company Address Font
  Future<bool> saveCompanyAddressInPrintStatus(bool addressStatus) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool("addressStatus", addressStatus);
  }

  Future<bool?> fetchCompanyAddressInPrintStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("addressStatus");
  }

  //Company PhoneNo Font
  Future<bool> saveCompanyPhoneInPrintStatus(bool phoneNoStatus) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool("phoneNoStatus", phoneNoStatus);
  }

  Future<bool?> fetchCompanyPhoneInPrintStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("phoneNoStatus");
  }

  //Company Logo width
  Future<bool> saveLogoWidth(double logoWidth) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setDouble("logoWidth", logoWidth);
  }

  Future<double?> fetchLogoWidth() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble("logoWidth");
  }

  //Company Logo height
  Future<bool> saveLogoHeight(double logoHeight) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setDouble("logoHeight", logoHeight);
  }

  Future<double?> fetchLogoHeight() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble("logoHeight");
  }

  /// ------------------ VAT STATUS ------------------
  Future<void> setVatStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vatStatusKey, status);
  }

  Future<bool> getVatStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_vatStatusKey) ?? false;
  }

  /// ------------------ VAT TYPE ------------------
  Future<void> setVatType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_vatTypeKey, type);
  }

  Future<String> getVatType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_vatTypeKey) ?? '';
  }

  /// ------------------ Expiry Date ------------------
  Future<void> setExpiryDate(String expiryDate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('expiryDate', expiryDate);
  }

  Future<String> getExpiryDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('expiryDate') ?? '';
  }

  // /// ------------------ Expiry Date ------------------
  // Future<void> setExpiryDateCheckStatus(String expiryDate) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('expiryDate', expiryDate);
  // }
  //
  // Future<String> getExpiryDate() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('expiryDate') ?? '';
  // }

  /// ------------------ LEDGERS ------------------
  Future<void> saveLedgers({
    required int cashLedgerId,
    required String cashLedgerName,
    required int cardLedgerId,
    required String cardLedgerName,
    required int bankLedgerId,
    required String bankLedgerName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cashLedgerId', cashLedgerId);
    await prefs.setString('cashLedgerName', cashLedgerName);
    await prefs.setInt('cardLedgerId', cardLedgerId);
    await prefs.setString('cardLedgerName', cardLedgerName);
    await prefs.setInt('bankLedgerId', bankLedgerId);
    await prefs.setString('bankLedgerName', bankLedgerName);
  }

  Future<Map<String, dynamic>> getLedgers() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'cashLedgerId': prefs.getInt('cashLedgerId'),
      'cashLedgerName': prefs.getString('cashLedgerName'),
      'cardLedgerId': prefs.getInt('cardLedgerId'),
      'cardLedgerName': prefs.getString('cardLedgerName'),
      'bankLedgerId': prefs.getInt('bankLedgerId'),
      'bankLedgerName': prefs.getString('bankLedgerName'),
    };
  }

  Future<void> saveItemTapBehavior(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_itemTapBehaviorKey, value);
    // ✅ update instantly for live screens
    itemTapBehaviorNotifier.value = value;
  }

  Future<int> getItemTapBehavior() async {
    final prefs = await SharedPreferences.getInstance();
    final v = prefs.getInt(_itemTapBehaviorKey) ?? 1;
    itemTapBehaviorNotifier.value = v;
    return v;
  }

  Future<void> savePaymentOption(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_paymentOptionKey, value);
  }

  Future<int> getPaymentOption() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_paymentOptionKey) ?? 0; // CASH default
  }

  Future<void> setCashLedgerId(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCashLedgerId, value);
  }

  Future<void> setCardLedgerId(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCardLedgerId, value);
  }

  Future<void> setBankLedgerId(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kBankLedgerId, value);
  }

  Future<void> setAppVersion(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAppVersion, value);
  }

  // Optional getters
  Future<String> getCashLedgerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kCashLedgerId) ?? '';
  }

  Future<String> getCardLedgerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kCardLedgerId) ?? '';
  }

  Future<String> getBankLedgerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kBankLedgerId) ?? '';
  }

  Future<String> getAppVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kAppVersion) ?? '';
  }
}
