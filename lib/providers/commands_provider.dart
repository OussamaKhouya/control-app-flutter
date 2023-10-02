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

  Future init() async {
    await fetchCommands();
  }

  Future<void> fetchCommands() async {
    commands = await apiService.fetchCommands();
    notifyListeners();
  }
}
