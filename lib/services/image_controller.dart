import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter_app/services/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageController extends GetxController {

  late ApiService apiService;
  late AuthProvider authProvider;

  ImageController(AuthProvider authProvider){
    this.authProvider = authProvider;
    apiService = ApiService(authProvider.token);
  }

  File? image;

  Future<void> saveImage() async {
    try {
      final Directory? appDirectory = await getExternalStorageDirectory();
      final String imageDirectory = '${appDirectory?.path}/images';
      await Directory(imageDirectory).create(recursive: true);

      String imagePath = '$imageDirectory/image_${DateTime.now()}.jpg';
      if (image != null) {
        File capturedFile = File(image!.path);
        await capturedFile.copy(imagePath!);
      } else {
        print("image is null");
      }
      update();
    } catch (e) {
      print('Error taking photo: $e');
    }
  }


  Future pickImageGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      this.image = imageTemp;
      update();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      this.image = imageTemp;
      update();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<bool> uploadImage(String numpiece,String numero, String fileName) async {
    print("i was uploadImage");
    if(image != null){
      http.StreamedResponse response = await apiService.uploadImage(image!, numpiece,numero, fileName);
      print(response.statusCode);
      if (response.statusCode == 201) {
        Map map = jsonDecode(await response.stream.bytesToString());
        String message = map["message"];
        print(message);
        return true;
      } else {
        Map body = jsonDecode(await response.stream.bytesToString());
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
    }else {
      print("choose an image");
    }
    return false;

  }

}
