import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/constants.dart';
import 'package:flutter_app/models/lcmd.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter_app/providers/lcmd_provider.dart';
import 'package:flutter_app/services/image_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class CameraScreen extends StatefulWidget {
  CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late int imageCount;
  late Future<List<String>> listOfUrls;
  bool imageSelected = false;
  late LCmd ligneC;

  bool onlyOnce = true;
  bool onlyOncePhotos = true;

  String? UPLOAD_IMG_INITIALS;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    ligneC = ModalRoute.of(context)?.settings.arguments as LCmd;

    final AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);
    Get.lazyPut(() => ImageController(provider));
    loadGallery();

    getPermissions();

    return GetBuilder<ImageController>(builder: (imageController) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Prend 2 photos"),
        ),
        body: SafeArea(
            child: Center(
          child: SingleChildScrollView(
              child: Column(
            children: [
              const SizedBox(height: 5),
              Text(
                "Article : ${ligneC.a_bcc_lib}",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                "${ligneC.a_bcc_nupi} - ${ligneC.a_bcc_num} ",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                      visible: SHOW_BTN_GALLERY,
                      child: ElevatedButton(
                          child: const Row(
                            children: <Widget>[
                              Icon(Icons.photo_camera_front_outlined, size: 20),
                              Text('gallery'),
                            ],
                          ),
                          onPressed: () {
                            imageController.pickImageGallery();
                            setState(() {
                              imageSelected = true;
                            });
                          })),
                  const SizedBox(
                    width: 20,
                  ),
                  Visibility(
                      visible: SHOW_BTN_CAMERA,
                      child: ElevatedButton(
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.camera_alt,
                                size: 20,
                              ),
                              Text(' camera'),
                            ],
                          ),
                          onPressed: () => onPickImage(imageController))),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Visibility(
                  visible: SHOW_BTN_CAMERA || SHOW_BTN_GALLERY,
                  child: Container(
                    alignment: Alignment.center,
                    width: 300,
                    height: 300,
                    color: Colors.grey[300],
                    child: imageController.image != null
                        ? Image.file(
                            imageController.image!,
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                          )
                        : const Center(
                            child: Text(
                            'Veuillez sélectionner une image.',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                decoration: TextDecoration.none),
                          )),
                  )),
              const SizedBox(
                height: 20,
              ),
              imageSelected
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                            visible: SHOW_BTN_SAVE,
                            child: ElevatedButton(
                                child: const Row(
                                  children: <Widget>[
                                    Icon(Icons.save, size: 20),
                                    Text(' save'),
                                  ],
                                ),
                                onPressed: () {
                                  imageController.saveImage();
                                })),
                        const SizedBox(width: 20),
                        Visibility(
                            visible: SHOW_BTN_UPLOAD,
                            child: ElevatedButton(
                                child: Row(
                                  children: <Widget>[
                                    const Icon(Icons.cloud_upload, size: 20),
                                    Text(' upload ($imageCount)'),
                                  ],
                                ),
                                onPressed: () =>
                                    onUploadImage(imageController))),
                      ],
                    )
                  : const SizedBox(
                      height: 10,
                    ),
              const Divider(
                color: Colors.blue,
                thickness: 5,
              ),
              const SizedBox(height: 10),
              FutureBuilder(
                future: listOfUrls,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Text("none");
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        List<String> nonNullableList = snapshot.data ?? [];
                        List<String> filtredList = nonNullableList.where((url) => url.contains(UPLOAD_IMG_INITIALS.toString())).toList();
                        return (nonNullableList.isNotEmpty)
                            ? Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Container(
                                        width: 500,
                                        alignment: Alignment.center,
                                        child: GalleryImage(
                                            imageUrls: filtredList,
                                            numOfShowImages:
                                                (filtredList.length)),
                                      )),
                                ],
                              )
                            : const Text("Pas d'images pour cet article");
                      } else if (snapshot.hasError) {
                        return const Text('Something went wrong!');
                      }
                    default:
                      return Text("default");
                  }
                  return Text("default");
                },
              ),
              const SizedBox(height: 10),
            ],
          )),
        )),
      );
    });
  }

  loadGallery() {
    if (onlyOnce) {
      final ligneCmdprovider = Provider.of<LCmdProvider>(context, listen: false);
      setState(() {
        listOfUrls = ligneCmdprovider.getImagesUrl(ligneC.a_bcc_nupi, ligneC.a_bcc_num);
        onlyOnce = false;
      });
    }
  }

  // Initialize Permissions
  late bool SHOW_BTN_CAMERA, SHOW_BTN_GALLERY, SHOW_BTN_UPLOAD, SHOW_BTN_SAVE;

  void getPermissions() {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    Map<String, dynamic> permissions = provider.permissions;

    SHOW_BTN_CAMERA = permissions[PermConstants.SHOW_BTN_CAMERA]!;
    SHOW_BTN_GALLERY = permissions[PermConstants.SHOW_BTN_GALLERY]!;
    SHOW_BTN_UPLOAD = permissions[PermConstants.SHOW_BTN_UPLOAD]!;
    SHOW_BTN_SAVE = permissions[PermConstants.SHOW_BTN_SAVE]!;
    UPLOAD_IMG_INITIALS = permissions[PermConstants.UPLOAD_IMG_INITIALS]!;

    if(onlyOncePhotos){
      if(UPLOAD_IMG_INITIALS == "c1"){
        imageCount = int.parse(ligneC.nph1);
      }else if(UPLOAD_IMG_INITIALS == "c2"){
        imageCount = int.parse(ligneC.nph2);
      }else {
        imageCount = int.parse(ligneC.nph1) + int.parse(ligneC.nph2);
      }

      onlyOncePhotos = false;
    }
  }

  onUploadImage(ImageController imageController) async {
      if (imageCount < 2) {
        String path = await imageController.saveImage();
        if(path.isNotEmpty){
          imageController
              .uploadImage(ligneC.a_bcc_nupi, ligneC.a_bcc_num, '${UPLOAD_IMG_INITIALS}_${imageCount + 1}',
              File(path))
              .then((value) => {
            if (value)
              {
                setState(() {
                  imageCount++;
                  onlyOnce = true;
                  loadGallery();
                  imageController.image = null;
                })
              }
          });
        }else {
          return Fluttertoast.showToast(
            msg: "prend une photo!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            textColor: Color(0xFFfa6467),
            backgroundColor: Color(0xFFfde8e7),
            fontSize: 16.0,
          );
        }

      } else {
        return Fluttertoast.showToast(
          msg: "2 images est le maximum!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          textColor: Color(0xFFfa6467),
          backgroundColor: Color(0xFFfde8e7),
          fontSize: 16.0,
        );
      }

  }

  onPickImage(ImageController imageController) {
    if (imageCount < 2) {
      imageController.pickImageCamera();
      setState(() {
        imageSelected = true;
      });
    } else {
      return Fluttertoast.showToast(
        msg: "2 images est le maximum!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        textColor: const Color(0xFFfa6467),
        backgroundColor: const Color(0xFFfde8e7),
        fontSize: 16.0,
      );
    }
  }
}
