import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter_app/services/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageController extends GetxController {

  late ApiService apiService;
  late AuthProvider authProvider;

  ImageController(AuthProvider authProvider){
    this.authProvider = authProvider;
    apiService = ApiService(authProvider.token);
  }

  File? image;

  Future<String> saveImage() async {
    try {
      final Directory? appDirectory = await getExternalStorageDirectory();
      final String imageDirectory = '${appDirectory?.path}/images';
      await Directory(imageDirectory).create(recursive: true);

      // String imagePath = '$imageDirectory/image_${DateTime.now()}.jpg';
      String imagePath = '$imageDirectory/image_to_upload.jpg';
      if (image != null) {
        File capturedFile = File(image!.path);
        await capturedFile.copy(imagePath!);
        return imagePath;
      } else {
        print("image is null");
      }
      update();
    } catch (e) {
      print('Error taking photo: $e');
    }
    return "";
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
      final image = await ImagePicker().getImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      print(await imageTemp.length());
      this.image = File(imageTemp.path);
      update();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<bool> uploadImage(String numpiece,String numero, String fileName,File file, String type) async {
    if(file != null){
      var len = await file.length();
      if(len != 0){

        File compressedFile = await compressImage(file);
        http.StreamedResponse response = await apiService.uploadImage2(compressedFile, numpiece,numero, fileName, type);
        print(response.statusCode);
        if (response.statusCode == 201) {
          Map map = jsonDecode(await response.stream.bytesToString());
          String message = map["message"];
          print(message);
          return true;
        } else {
          Map body = jsonDecode(await response.stream.bytesToString());
          print(body);
          Map<String, dynamic> errors = body['error'];
          String errorMessage = '';
          errors.forEach((key, value) {
            value.forEach((element) {
              errorMessage += element + '\n';
            });
          });
          throw Exception(errorMessage);
        }
      }else {
        print("image length is zero!");
      }

    }else {
      print("choose an image");
    }
    return false;

  }

  void removeImage(String a_bcc_nupi, String a_bcc_num, String imgName)  {
      apiService.removeImage(a_bcc_nupi, a_bcc_num,'$imgName.jpg');
  }

  Future<File> compressImage0(File file) async {
    int goalSizeKB =  512;
    int originalSizeKB = file.lengthSync() ~/ 1024;

    if (originalSizeKB <= goalSizeKB) {
      return file; // No need to compress if already within goal size
    }

    int quality = ((goalSizeKB / originalSizeKB) * 100).toInt();
    if (quality < 10) quality = 10; // Set a minimum quality threshold

    print("quality = $quality");
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 60,
      format: CompressFormat.jpeg
    );

    print('File size before compression: ${file.lengthSync()}');
    print('File size after compression: ${result?.length}');
    print('File quality: ${((file.lengthSync() / result!.length)).toInt()}');

    File compressedFile = File(file.path.replaceAll('.jpg', '_compressed.jpg'));
    await compressedFile.writeAsBytes(result as Uint8List);

    return compressedFile;
  }


  Future<File> compressImage(File file) async {

    int goalSizeKB =  512;
    int minQuality = 10;
    int maxQuality = 100;
    int quality = 80; // Initial guess

    while (minQuality <= maxQuality) {
      List<int> compressedImageBytes = (await FlutterImageCompress.compressWithFile(
        file.path,
        quality: quality,
        format: CompressFormat.jpeg
      )) as List<int>;

      int fileSizeKB = compressedImageBytes.length ~/ 1024;

      if (fileSizeKB < goalSizeKB) {
        return File(file.path.replaceFirst('.jpg', '_compressed.jpg'))..writeAsBytesSync(compressedImageBytes);
      }

      maxQuality = quality - 1;
      quality = ((minQuality + maxQuality) / 2).toInt();

    }

    return file;
  }


}
