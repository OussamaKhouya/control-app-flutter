import 'package:flutter/cupertino.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import '../models/lcmd.dart';
import '../services/api.dart';


class LCmdProvider extends ChangeNotifier{
  List<LCmd> ligne_commands=[];
  String selectedLigne = '';
  late ApiService apiService;
  late AuthProvider authProvider;

  LCmdProvider(AuthProvider authProvider) {
    this.authProvider = authProvider;
    apiService = ApiService(authProvider.token);
  }

  Future<void> updateTransaction(LCmd ligneC) async {
    try {
      await apiService.updateLignCmd(ligneC);
      notifyListeners();
    } catch (Exception) {
      print(Exception);
    }
  }


  Future<List<LCmd>> fetchLigneC(numpiece) async {
    var list = apiService.fetchLigneC(numpiece);
    ligne_commands = await list;
    notifyListeners();
    return list;
  }

  Future<List<String>> getImagesUrl(String numpiece, String numero) async {
    var list = await apiService.getImagesUrl(numpiece, numero);
    notifyListeners();
    return list;
  }

}