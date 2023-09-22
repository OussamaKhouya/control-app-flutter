import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/models/ligne_c.dart';
import 'package:http/http.dart' as http;
import '../models/commande.dart';
class ApiService{



ApiService();

final String baseurl="http://192.168.1.10:4200/api";

Future<List<Commande>> fetchCommands() async {
  http.Response response= await http.get(Uri.parse('$baseurl/commandes'));
  List commandes = jsonDecode(response.body);
  return commandes.map((commande) => Commande.fromJson(commande)).toList();
}

Future<List<LigneC>> fetchLigneC() async{
  http.Response response = await http.get(Uri.parse('$baseurl/ligne-commandes'));
  List ligneCmd= jsonDecode(response.body);
  return ligneCmd.map((ligneC) => LigneC.fromJson(ligneC)).toList();
}

}

