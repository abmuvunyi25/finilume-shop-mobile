// lib/services/local_storage_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _sessionKey = 'sessionId';
  static const String _customerNameKey = 'customerName';
  static const String _customerEmailKey = 'customerEmail';
  static const String _customerPhoneKey = 'customerPhone';

  /// Save sessionId locally
  Future<void> saveSessionId(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, sessionId);
  }

  /// Retrieve sessionId
  Future<String?> getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionKey);
  }

  /// Clear sessionId (e.g. after checkout)
  Future<void> clearSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  /// Save customer info
  Future<void> saveCustomerInfo({
    required String name,
    required String email,
    required String phone,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_customerNameKey, name);
    await prefs.setString(_customerEmailKey, email);
    await prefs.setString(_customerPhoneKey, phone);
  }

  /// Retrieve customer info
  Future<Map<String, String?>> getCustomerInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_customerNameKey),
      'email': prefs.getString(_customerEmailKey),
      'phone': prefs.getString(_customerPhoneKey),
    };
  }

  /// Clear customer info
  Future<void> clearCustomerInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_customerNameKey);
    await prefs.remove(_customerEmailKey);
    await prefs.remove(_customerPhoneKey);
  }
}
