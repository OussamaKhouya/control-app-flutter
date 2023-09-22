import 'package:flutter/material.dart';
import '../services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {

  bool isAuthenticated = false;
  late String token;
  late ApiService apiService;

  AuthProvider() {
    init();
  }

  Future<void> init() async {
    token = await getToken();
    if (token.isNotEmpty) {
      isAuthenticated = true;
    }
    apiService = ApiService(token);
    notifyListeners();
  }

  Future<void> register(String name, String username, String role, String password,
      String passwordConfirm, String deviceName) async {
    token = await apiService.register(
        name, username, role, password, passwordConfirm, deviceName);
    setToken(token);
    isAuthenticated = true;
    notifyListeners();
  }

  Future<void> login(String username, String password, String deviceName) async {
    token = await apiService.login(username, password, deviceName);
    setToken(token);
    isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logOut() async {
    token = '';
    setToken(token);
    isAuthenticated = false;
    notifyListeners();
  }

  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }
}
