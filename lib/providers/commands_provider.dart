import 'package:flutter/cupertino.dart';
import 'package:flutter_app/providers/auth_provider.dart';

import '../models/commande.dart';
import '../services/api.dart';

class CommandProvider extends ChangeNotifier {
  List<Commande> commands = [];
  late ApiService apiService;
  late AuthProvider authProvider;

  CommandProvider(AuthProvider authProvider) {
    this.authProvider = authProvider;
    apiService = ApiService(authProvider.token);
    init();
  }

  Future<void> updateCommande(Commande Cmd) async {
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

  Future<List<Commande>> fetchCommands() async {
    commands = await apiService.fetchCommands();
    notifyListeners();
    return commands;
  }
}
