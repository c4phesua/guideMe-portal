import 'package:shared_preferences/shared_preferences.dart';

class UserPrederences {
  static SharedPreferences _preferences;
  static const _keyToken = 'token';
  static const _keyIsLogic = 'is_login';
  static const _keyTokenType = 'token_type';
  static const _keyUserId = 'user_id';
  static const _keyUserEmail = 'user_email';
  static const _keyUserFullName = 'user_full_name';
  static const _keyUserAvatar = 'user_avatar';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }



  static Future setToken(String token) async {
    await _preferences.setString(_keyToken, token);
  }

  static String getToken() => _preferences.getString(_keyToken);

  static Future setTokenType(String tokenType) async {
    await _preferences.setString(_keyTokenType, tokenType);
  }

  static String getTokenType() => _preferences.getString(_keyTokenType);

  static Future setUserID(int userId) async {
    await _preferences.setInt(_keyUserId, userId);
  }

  static int getUserID() => _preferences.getInt(_keyUserId);

  static Future setUserFullName(String fullName) async {
    await _preferences.setString(_keyUserFullName, fullName);
  }

  static String getUserFullName() => _preferences.getString(_keyUserFullName);

  static Future setUserEmail(String email) async {
    await _preferences.setString(_keyUserEmail, email);
  }

  static String getUserEmail() => _preferences.getString(_keyUserEmail);

  static Future setUserAvatar(String avatar) async {
    await _preferences.setString(_keyUserAvatar, avatar);
  }

  static String getUserAvatar() => _preferences.getString(_keyUserAvatar);

  static Future setIsLogin(bool isLogin) async {
    await _preferences.setBool(_keyIsLogic, isLogin);
  }

  static bool isLogin() => _preferences.getBool(_keyIsLogic);
}