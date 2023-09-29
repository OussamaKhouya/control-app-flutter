import 'package:flutter/cupertino.dart';
import 'package:flutter_app/providers/auth_provider.dart';

import '../models/compte.dart';
import '../services/api.dart';

class CompteProvider extends ChangeNotifier {
 // List<Compte> compte = [];
  Compte compte= Compte(name: "marouane", role: "role", username: "username");
  late ApiService apiService;
  late AuthProvider authProvider;

  CompteProvider(AuthProvider authProvider) {
    this.authProvider = authProvider;
    apiService = ApiService(authProvider.token);
    init();
  }

  Future init() async {
    compte = await apiService.fetchCompte();
    notifyListeners();
  }
}
