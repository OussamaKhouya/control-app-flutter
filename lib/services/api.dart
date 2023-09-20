import 'dart:convert';
import 'dart:io';
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

}

