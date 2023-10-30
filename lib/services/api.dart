import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/models/lcmd.dart';
import 'package:http/http.dart' as http;
import '../models/cmd.dart';

class ApiService {
  late String token;
  bool showSpinner = false;
  late User currUser;

  ApiService(this.token);

  final String baseurl = "http://192.168.1.6:4300/api";


  // user
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

  // Future<User> getuserInfo() async {
  //   http.Response response = await http.get(Uri.parse('$baseurl/auth/find/oussama'),
  //       headers: {
  //         HttpHeaders.contentTypeHeader: 'application/json',
  //         HttpHeaders.acceptHeader: 'application/json',
  //         HttpHeaders.authorizationHeader: 'Bearer $token'
  //       }
  //   );
  //
  //   if (response.statusCode == 200) {
  //     User user = User.fromJson(jsonDecode(response.body));
  //     return user;
  //   } else {
  //     // Handle error cases here if needed.
  //     throw Exception('Failed to fetch user info');
  //   }
  // }

  // cmd
  Future<List<Cmd>> fetchCommands() async {
    showSpinner = true;
    http.Response response = await http.get(Uri.parse('$baseurl/commandes'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        });
    List commandes = jsonDecode(response.body);
    showSpinner = false;
    return commandes.map((commande) => Cmd.fromJson(commande)).toList();
  }


  Future<Cmd> updateCommande(Cmd cmd) async{
    String uri = '$baseurl/commandes/${cmd.bcc_nupi}';
    http.Response response = await http.put(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        body: jsonEncode({
          'bcc_val' : cmd.bcc_val,
          'bcc_eta' : cmd.bcc_eta,
        })
    );
    if (response.statusCode != 200) {
      throw Exception('Error happened on update Commande !');
    }
    print("updateCommande: ");
    print(cmd.toString());
    return Cmd.fromJson(jsonDecode(response.body));
  }

  // lcmd

  Future<LCmd> updateLignCmd(LCmd ligne) async {
    String uri = '$baseurl/ligne-commandes/${ligne.a_bcc_num}';

    http.Response response = await http.put(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        body: jsonEncode({
          'a_bcc_quch1': ligne.a_bcc_quch1,
          'a_bcc_boch1': ligne.a_bcc_boch1,
          'a_bcc_obs1': ligne.a_bcc_obs1,
          'a_bcc_quch2': ligne.a_bcc_quch2,
          'a_bcc_boch2': ligne.a_bcc_boch2,
          'a_bcc_obs2': ligne.a_bcc_obs2,
        }));

    if (response.statusCode != 200) {
      throw Exception('Error happened on update');
    }
    return LCmd.fromJson(jsonDecode(response.body));
  }



  Future<List<LCmd>> fetchLigneC(String numpiece) async {
    http.Response response = await http.post(Uri.parse('$baseurl/ligne-commandes/search'),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json', //important
              HttpHeaders.acceptHeader: 'application/json',
              HttpHeaders.authorizationHeader: 'Bearer $token'
            },
            body: jsonEncode({
              'a_bcc_nupi': numpiece,
            })
        );
    print(numpiece);
    print(response.statusCode);
    if (response.statusCode == 200) {
      List ligneCmd = jsonDecode(response.body);
      if(ligneCmd.isEmpty){
        return [];
      }
      return ligneCmd.map((ligneC) => LCmd.fromJson(ligneC)).toList();
    } else {
      String errorMessage = 'no data found';
      throw Exception(errorMessage);
    }
  }


  // image

  Future<List<String>> getImagesUrl(String numpiece, String numero) async {
    http.Response response =
    await http.get(Uri.parse('$baseurl/file/check/$numpiece/$numero'), headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });
    List imageUrls = jsonDecode(response.body);

    return imageUrls.map((element) => element.toString()).toList();
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

  Future<http.StreamedResponse> uploadImage2(File file, String numpiece,String numero, String fileName, String type) async {
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
      'type': type
    });

    request.files.add(await http.MultipartFile.fromPath(
        'file', file.path));

    http.StreamedResponse response = await request.send();
    print('inside uploadImage ApiService');
    return response;
  }

  removeImage(String nupi, String num, String imageName) async {
    http.Response response = await http.delete(Uri.parse('$baseurl/file/$nupi/$num/$imageName'), headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> body  = jsonDecode(response.body);
      String message = body['message'];
      print(message);
    } else {
      Map<String, dynamic> body = jsonDecode(response.body);
      String errorMessage = body['message'];
      print(errorMessage);
      throw Exception(errorMessage);
    }



  }
}
