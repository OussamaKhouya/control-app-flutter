import 'dart:convert';
import 'dart:io';

import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/models/ligne_c.dart';
import 'package:http/http.dart' as http;

import '../models/commande.dart';

class ApiService {
  late String token;
  late User currUser;

  ApiService(this.token);

  final String baseurl = "http://192.168.1.42:4300/api";


  Future<User> getuserInfo() async {
    http.Response response = await http.get(Uri.parse('$baseurl/auth/find/oussama'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        }
    );

    if (response.statusCode == 200) {
      User user = User.fromJson(jsonDecode(response.body));
      return user;
    } else {
      // Handle error cases here if needed.
      throw Exception('Failed to fetch user info');
    }
  }

  Future<LigneC> updateLignCmd(LigneC ligne) async {
    String uri = '$baseurl/ligne-commandes/${ligne.numero}';

    http.Response response = await http.put(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        body: jsonEncode({
          'quantite1': ligne.quantite1,
          'observation1': ligne.observation1,
          'quantite2': ligne.quantite2,
          'observation2': ligne.observation2,
        }));

    if (response.statusCode != 200) {
      throw Exception('Error happened on update');
    }
    return LigneC.fromJson(jsonDecode(response.body));
  }

  Future<Commande> updateCommande(Commande cmd) async{
    String uri = '$baseurl/commandes/${cmd.numpiece}';
    http.Response response = await http.put(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        body: jsonEncode({
          'saisie' : 1,
        })
    );
    if (response.statusCode != 200) {
      throw Exception('Error happened on update Commande !');
    }
    return Commande.fromJson(jsonDecode(response.body));
  }

  Future<List<Commande>> fetchCommands() async {
    http.Response response = await http.get(Uri.parse('$baseurl/commandes'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        });
    List commandes = jsonDecode(response.body);
    return commandes.map((commande) => Commande.fromJson(commande)).toList();
  }

  Future<List<LigneC>> fetchLigneC(String numpiece) async {
    http.Response response = await http.post(Uri.parse('$baseurl/ligne-commandes/search'),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json', //important
              HttpHeaders.acceptHeader: 'application/json',
              HttpHeaders.authorizationHeader: 'Bearer $token'
            },
            body: jsonEncode({
              'numpiece': numpiece,
            })
        );
    print(numpiece);
    print(response.statusCode);
    if (response.statusCode == 200) {
      List ligneCmd = jsonDecode(response.body);
      if(ligneCmd.isEmpty){
        return [];
      }
      return ligneCmd.map((ligneC) => LigneC.fromJson(ligneC)).toList();
    } else {
      String errorMessage = 'no data found';
      throw Exception(errorMessage);
    }
  }


  Future<List<String>> getImagesUrl(String numpiece, String numero) async {
    http.Response response =
    await http.get(Uri.parse('$baseurl/file/check/$numpiece/$numero'), headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });
    List imageUrls = jsonDecode(response.body);

    return imageUrls.map((element) => element.toString()).toList();
  }

  Future<Map<String, dynamic>> register(String name, String username, String role,
      String password, String passworConfirm, String deviceName) async {
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
      return jsonDecode(response.body);
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

  Future<Map<String, dynamic>> login(String username, String password, String deviceName) async {
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
      return jsonDecode(response.body);
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
