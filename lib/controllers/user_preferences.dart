import 'package:shared_preferences/shared_preferences.dart';

class UserPrederences {
  static SharedPreferences _preferences;
  static const _keyToken = 'token';
  static const _keyIsLogic = 'is_login';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
    await _preferences.setBool(_keyIsLogic, false);
  }


  Future setToken(String token) async {
    await _preferences.setString(_keyToken, token);
  }

  static String getToken() => _preferences.getString(_keyToken);

  Future setIsLogin(bool isLogin) async => await _preferences.setBool(_keyIsLogic, isLogin);

  static bool isLogin() => _preferences.getBool(_keyIsLogic);
}