import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static const String _baseUrlKey = 'base_url';
  static const String _tokenKey = 'auth_token';
  static const String _databaseNameKey = 'database_name';
  static const String _vatStatusKey = 'vat_status';
  static const String _vatTypeKey = 'vat_type';

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

  /// ------------------ setStaffName ------------------
  Future<bool> setStaffName(String staffName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString("staffName", staffName);
  }

  Future<String> getStaffName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("staffName") ?? '';
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
}
