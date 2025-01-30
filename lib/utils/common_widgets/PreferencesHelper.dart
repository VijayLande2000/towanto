import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static Future<void> saveString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
// Method to remove a key-value pair
  static Future<void> removeKey(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> clearSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

 //  static Future<void> saveBool(String key, bool value) async {
 //    final SharedPreferences prefs = await SharedPreferences.getInstance();
 //
 //    await prefs.setBool(key, value);
 //  }
 //
 //  static Future<bool?> getBool(String key) async {
 //    final SharedPreferences prefs = await SharedPreferences.getInstance();
 //
 //    return prefs.getBool(key);
 //  }
 //
 //  static Future<void> clearAllData() async {
 //    final SharedPreferences prefs = await SharedPreferences.getInstance();
 //    await prefs.clear();
 //  }
 //
 //
 //
 //
 //
 // // static const String _propertyDetailsKey = 'property_details';
 //
 //
 //
 //  // Save the property details map
 //  static Future<void> savePropertyDetails(Map<String, dynamic> propertyDetails, String _propertyDetailsKey) async {
 //    final SharedPreferences prefs = await SharedPreferences.getInstance();
 //
 //    // Convert Sets to Lists
 //    Map<String, dynamic> jsonCompatibleMap = propertyDetails.map((key, value) {
 //      if (value is Set) {
 //        return MapEntry(key, value.toList());
 //      }
 //      return MapEntry(key, value);
 //    });
 //
 //    String jsonString = json.encode(jsonCompatibleMap);
 //    await prefs.setString(_propertyDetailsKey, jsonString);
 //  }
 //
 //
 //  // Retrieve the property details map
 //  static Future<Map<String, dynamic>> getPropertyDetails( String _propertyDetailsKey) async {
 //    final SharedPreferences prefs = await SharedPreferences.getInstance();
 //    String? jsonString = prefs.getString(_propertyDetailsKey);
 //    if (jsonString != null) {
 //      return json.decode(jsonString) as Map<String, dynamic>;
 //    }
 //    return {};
 //  }
 //
 //
 //
 //  // Get a specific value from the property details map
 //  static Future<dynamic> getPropertyDetail(String key, String _propertyDetailsKey) async {
 //    Map<String, dynamic> propertyDetails = await getPropertyDetails(_propertyDetailsKey);
 //    return propertyDetails[key];
 //  }
 //
 //
 //  // Clear the property details map
 //  static Future<void> clearPropertyDetails( String _propertyDetailsKey) async {
 //    final SharedPreferences prefs = await SharedPreferences.getInstance();
 //    await prefs.remove(_propertyDetailsKey);
 //  }
 //

}
