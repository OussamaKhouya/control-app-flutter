import 'package:flutter/cupertino.dart';

import '../models/commande.dart';
import '../services/api.dart';


class CommandProvider extends ChangeNotifier{
 List<Commande> commands=[];
 late ApiService apiService;

 CommandProvider(){
apiService=ApiService();
init();
 }

 Future init() async{
  commands = await apiService.fetchCommands();
  notifyListeners();
 }


}