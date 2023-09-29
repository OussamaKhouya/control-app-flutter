import 'dart:convert';
import 'dart:io';

import 'package:flutter_app/models/compte.dart';
import 'package:flutter_app/models/ligne_c.dart';
import 'package:http/http.dart' as http;

import '../models/commande.dart';

class ApiService {
  late String token;

  ApiService(String token) {
    this.token = token;
  }

  final String baseurl = "http://192.168.1.100:4300/api";



  Future<Compte> fetchCompte() async {
    http.Response response = await http.get(Uri.parse('$baseurl/auth/find/oussama'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        }
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> compteData = jsonDecode(response.body);
      Compte compte = Compte.fromJson(compteData);
      return compte;
    } else {
      // Handle error cases here if needed.
      throw Exception('Failed to fetch Compte');
    }
  }


  Future<List<Commande>> fetchCommands() async {
    http.Response response = await http.get(Uri.parse('$baseurl/commandes'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        }
        );
    List commandes = jsonDecode(response.body);
    return commandes.map((commande) => Commande.fromJson(commande)).toList();
  }

  Future<List<LigneC>> fetchLigneC() async {
    http.Response response =
        await http.get(Uri.parse('$baseurl/ligne-commandes'), headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });
    List ligneCmd = jsonDecode(response.body);
    return ligneCmd.map((ligneC) => LigneC.fromJson(ligneC)).toList();
  }

  Future<String> register(String name, String username, String role, String password,
      String passworConfirm, String deviceName) async {
    String uri = '$baseurl/auth/register';

    http.Response response = await http.post(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'username': username,
          'role': role,
          'password': password,
          'password_confirmation': passworConfirm,
          'device_name': deviceName,
        }));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      Map<String, dynamic> body = jsonDecode(response.body);
      print(body);
      Map<String, dynamic> errors = body['errors'];
      String errorMessage = '';
      errors.forEach((key, value) {
        value.forEach((element) {
          errorMessage += element + '\n';
        });
      });
      throw Exception(errorMessage);
    }
  }

  Future<String> login(String username, String password, String deviceName) async {
    String uri = '$baseurl/auth/login';

    http.Response response = await http.post(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
          'device_name': deviceName,
        }));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String errorMessage = '';
      errors.forEach((key, value) {
        value.forEach((element) {
          errorMessage += element + '\n';
        });
      });
      throw Exception(errorMessage);
    }
  }

  Future<http.StreamedResponse> uploadImage(File file, String numpiece,String numero, String fileName) async {
    String url = '$baseurl/file/upload';
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(url));

    request.headers.addAll(<String, String>{
      HttpHeaders.contentTypeHeader: 'multipart/form-data',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer ${token}'
    });

    request.fields.addAll(<String, String>{
      'numero': numero,
      'fileName': fileName,
      'numpiece': numpiece,
    });

    request.files.add(http.MultipartFile(
        'file', file.readAsBytes().asStream(), file.lengthSync(),
        filename: file.path.split('/').last));

    http.StreamedResponse response = await request.send();
    print('inside uploadImage ApiService');
    return response;
  }
}
