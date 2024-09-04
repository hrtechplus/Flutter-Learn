import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Necessary for using jsonEncode and jsonDecode

class LocalStorageService {
  static Future<void> saveMedicalDetails(
      String key, Map<String, dynamic> data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(data));
  }

  static Future<Map<String, dynamic>?> loadMedicalDetails(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(key);
    return data != null ? jsonDecode(data) : null;
  }
}
