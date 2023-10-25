import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/providers/auth_provider.dart';

import '../models/cmd.dart';
import '../services/api.dart';

class CmdProvider extends ChangeNotifier {
  List<Cmd> commands = [];
  late ApiService apiService;
  late AuthProvider authProvider;

  CmdProvider(AuthProvider authProvider) {
    this.authProvider = authProvider;
    apiService = ApiService(authProvider.token);
    init();
  }

  Future<void> updateCommande(Cmd Cmd) async {
    try {
      await apiService.updateCommande(Cmd);
      notifyListeners();
    } catch (Exception) {
      print(Exception);
    }
  }

  Future init() async {
    await fetchCommands();
  }

  Future<List<Cmd>> fetchCommands() async {
    commands = await apiService.fetchCommands();
    notifyListeners();
    return commands;
  }

}
