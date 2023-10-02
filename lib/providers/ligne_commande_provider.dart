import 'package:flutter/cupertino.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import '../models/ligne_c.dart';
import '../services/api.dart';


class LigneCProvider extends ChangeNotifier{
  List<LigneC> ligne_commands=[];
  String selectedLigne = '';
  late ApiService apiService;
  late AuthProvider authProvider;

  LigneCProvider(AuthProvider authProvider) {
    this.authProvider = authProvider;
    apiService = ApiService(authProvider.token);
  }

  Future<List<LigneC>> fetchLigneC(numpiece) async {
    var list = apiService.fetchLigneC(numpiece);
    ligne_commands = await list;
    print(ligne_commands[0].numpiece);
    print(ligne_commands.length);
    notifyListeners();
    return list;
  }

  Future<List<String>> getImagesUrl(String numpiece, String numero) async {
    return await apiService.getImagesUrl(numpiece, numero);
  }


}