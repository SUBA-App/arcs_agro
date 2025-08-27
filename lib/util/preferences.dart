import 'dart:convert';
import 'package:arcs_agro/api/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Preferences {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> saveStatusCheckIn(int value) async {
    await _preferences?.setInt(_statusCheckKey, value);
  }

  static Future<void> saveSession(String token, User user) async {

    await _preferences?.setString(_tokenKey, token);
    await _preferences?.setString(_userKey, jsonEncode(user.toJson()));
  }
  static Future<void> saveUser(User user) async {
    await _preferences?.setString(_userKey, jsonEncode(user.toJson()));
  }


  static String token() {
    return _preferences?.getString(_tokenKey) ?? '';
  }

  static int statusCheckIn() {
    return _preferences?.getInt(_statusCheckKey) ?? 0;
  }

  static User? getUser() {
    return _preferences?.getString(_userKey) == null ? null : User.fromJson(jsonDecode(_preferences?.getString(_userKey) ?? ''));
  }

  static void clear() {
    _preferences?.clear();
  }

  static const _tokenKey = 'tokenKey';
  static const _userKey = 'userKey';
  static const _statusCheckKey = 'statusCheckKey';
}