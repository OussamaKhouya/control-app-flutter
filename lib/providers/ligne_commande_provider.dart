import 'package:flutter/cupertino.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import '../models/ligne_c.dart';
import '../services/api.dart';


class LigneCProvider extends ChangeNotifier{
  List<LigneC> ligne_commands=[];
  late ApiService apiService;
  late AuthProvider authProvider;

  LigneCProvider(AuthProvider authProvider) {
    this.authProvider = authProvider;
    apiService = ApiService(authProvider.token);
    init();
  }

  Future init() async{
    ligne_commands = await apiService.fetchLigneC();
    notifyListeners();
  }


}