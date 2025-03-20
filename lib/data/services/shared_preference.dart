import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {

  // RETRIEVING ACCOUNT
  static Future<Map<String, String>> retrieveSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('username') ?? '';
    String password = prefs.getString('password') ?? '';
    return {'username': email, 'password': password};
  }

  // SAVING ACCOUNT
  static Future<void> saveCredentials(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', email);
    await prefs.setString('password', password);
  }
}