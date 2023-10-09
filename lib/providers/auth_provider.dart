import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/user.dart';
import '../services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {

  bool isAuthenticated = false;
  late String token;
  late ApiService apiService;
  late User currUser;

  AuthProvider() {
    init();
  }

  Future<void> init() async {
    token = await getToken();
    if (token.isNotEmpty) {
      currUser = await getUser();
      isAuthenticated = true;
    }
    apiService = ApiService(token);
    notifyListeners();
  }

  Future<void> register(String name, String username, String role, String password,
      String passwordConfirm, String deviceName) async {
    Map<String, dynamic> user = await apiService.register(
        name, username, role, password, passwordConfirm, deviceName);
    token = user['token'];
    setToken(token);
    currUser = User(name: user['name'], username: user['username'], role: user['role']);
    setUser(currUser);
    isAuthenticated = true;
    notifyListeners();
  }

  Future<void> login(String username, String password, String deviceName) async {
    Map<String, dynamic> user = await apiService.login(username, password, deviceName);
    token = user['token'];
    setToken(token);
    currUser = User(name: user['name'], username: user['username'], role: user['role']);
    setUser(currUser);
    isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logOut() async {
    token = '';
    setToken(token);
    clearUser();
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

  Future<void> setUser(User u) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> user = {'name': u.name, 'username': u.username, 'role': u.role};
    print(jsonEncode(user));
    await prefs.setString('user', jsonEncode(user));
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user','');
  }


  Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    late User user;
    try {
       Map<String,dynamic> userMap = jsonDecode(prefs.getString('user')?? '') as Map<String, dynamic>;
       user = User.fromJson(userMap);
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    return user;
  }


}
