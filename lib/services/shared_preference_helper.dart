import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static const String _baseUrlKey = 'base_url';
  static const String _tokenKey = 'auth_token';
  static const String _databaseNameKey = 'database_name';

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

  /// ------------------ DATABASE NAME ------------------
  Future<void> setDatabaseName(String dbName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_databaseNameKey, dbName);
  }

  Future<String?> getDatabaseName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_databaseNameKey);
  }

  //paper size
  Future<bool> saveSelectedPrinter(String selectedPrinter) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString("selectedPrinter", selectedPrinter);
  }

  Future<String?> loadSelectedPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("selectedPrinter");
  }
}
