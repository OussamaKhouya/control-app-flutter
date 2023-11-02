import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/cmd.dart';
import 'package:flutter_app/models/constants.dart';
import 'package:flutter_app/models/lcmd.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter_app/providers/cmd_provider.dart';
import 'package:flutter_app/providers/lcmd_provider.dart';
import 'package:flutter_app/services/image_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  int imageCount = 0;
  int camionImageCount = 0;
  int bonImageCount = 0;
  late Future<List<String>> listOfUrls;
  bool imageSelected = false;
  late LCmd ligneC;

  bool runLoadGallery = true;
  bool onlyOncePhotos = true;
  List<String> filtredList = [];

  String? UPLOAD_IMG_INITIALS;


  @override
  void initState() {
    super.initState();
  }

  bool showMyDialog = false;

  showSpinnerDialog(BuildContext context) {
    if (showMyDialog) {
      print("showSpinnerDialog");
      AlertDialog alert = AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            Container(
                margin: EdgeInsets.only(left: 5),
                child: Text(" Envoyer ", style: TextStyle(color: Colors.blue))),
          ],
        ),
      );
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
      showMyDialog = false;
    }
  }

  closeSpinnerDialog() {
    print("CloseSpinnerDialog");
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    ligneC = ModalRoute.of(context)?.settings.arguments as LCmd;
    final cmdProvider = Provider.of<CmdProvider>(context);

    final AuthProvider provider =
        Provider.of<AuthProvider>(context, listen: false);
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
                                    const Icon(Icons.image, size: 20),
                                    Text(' ($imageCount)'),
                                  ],
                                ),
                                onPressed: () => uploadImage(imageController,'article',cmdProvider))),
                        const SizedBox(width: 20),
                        Visibility(
                            visible: true,
                            child: ElevatedButton(
                                child: Row(
                                  children: <Widget>[
                                    const Icon(Icons.inventory_outlined, size: 20),
                                    Text(' ($bonImageCount)'),
                                  ],
                                ),
                                onPressed: () => uploadImage(imageController,'bon',cmdProvider))),
                        const SizedBox(width: 20),
                        Visibility(
                            visible: true,
                            child: ElevatedButton(
                                child: Row(
                                  children: <Widget>[
                                    const Icon(Icons.fire_truck_outlined, size: 20),
                                    Text(' ($camionImageCount)'),
                                  ],
                                ),
                                onPressed: () => uploadImage(imageController,'camion',cmdProvider)))
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
                        filtredList = [];
                        if(nonNullableList.isNotEmpty){
                          filtredList = nonNullableList
                              .where((url) =>
                              url.contains(UPLOAD_IMG_INITIALS.toString()) ||
                                  url.contains('camion') ||
                                  url.contains('bon'))
                              .toList();
                        }
                        imageCount = filtredList.where((url) => url.contains(UPLOAD_IMG_INITIALS.toString())).toList().length;
                        camionImageCount = filtredList.where((url) => url.contains('camion')).toList().length;
                        bonImageCount = filtredList.where((url) => url.contains('bon')).toList().length;

                        bool showTrash1 = imageCount != 0;
                        bool showTrash2 = imageCount >= 2;
                        bool showCamion = camionImageCount >= 1;
                        bool showBon = bonImageCount >= 1;
                        return (nonNullableList.isNotEmpty)
                            ? Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 500,
                                            alignment: Alignment.center,
                                            child: GalleryImage(
                                              imageUrls: filtredList,
                                              numOfShowImages:
                                                  filtredList.length,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          const Divider(
                                            color: Colors.blue,
                                            thickness: 5,
                                          ),
                                          Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Visibility(
                                                  visible: showTrash1,
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.delete),
                                                      IconButton(
                                                        icon: Icon(
                                                            Icons.looks_one),
                                                        color: Colors.red,
                                                        onPressed: () =>
                                                            removeImage('${UPLOAD_IMG_INITIALS}_1',
                                                                imageController),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: showTrash2,
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.delete),
                                                      IconButton(
                                                        icon: Icon(
                                                            Icons.looks_two),
                                                        color: Colors.red,
                                                        onPressed: () =>
                                                            removeImage('${UPLOAD_IMG_INITIALS}_2',
                                                                imageController),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: showCamion,
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.delete),
                                                      IconButton(
                                                        icon: Icon(
                                                            Icons.fire_truck_outlined),
                                                        color: Colors.red,
                                                        onPressed: () =>
                                                            removeImage('camion',
                                                                imageController),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: showBon,
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.delete),
                                                      IconButton(
                                                        icon: Icon(
                                                            Icons.inventory_outlined),
                                                        color: Colors.red,
                                                        onPressed: () =>
                                                            removeImage('bon',
                                                                imageController),
                                                      ),
                                                    ],
                                                  ),
                                                )

                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              )
                            : const Text("Pas d'images par cet article");
                      } else if (snapshot.hasError) {
                        return const Text('Something went wrong!');
                      }
                    default:
                      return Text("default");
                  }
                  return Text("default");
                },
              ),
            ],
          )),
        )),
      );
    });
  }

  loadGallery() {
    if (runLoadGallery) {
      final ligneCmdprovider =
          Provider.of<LCmdProvider>(context, listen: false);
      setState(() {
        listOfUrls = ligneCmdprovider.getImagesUrl(ligneC.a_bcc_nupi, ligneC.a_bcc_num);
        listOfUrls.then((list){
            filtredList = [];
            if(list.isNotEmpty){
          filtredList = list
              .where((url) =>
          url.contains(UPLOAD_IMG_INITIALS.toString()) ||
              url.contains('camion') ||
              url.contains('bon'))
              .toList();
        }
        imageCount = filtredList.where((url) => url.contains(UPLOAD_IMG_INITIALS.toString())).toList().length;
        camionImageCount = filtredList.where((url) => url.contains('camion')).toList().length;
        bonImageCount = filtredList.where((url) => url.contains('bon')).toList().length;

      });
        runLoadGallery = false;
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

    if (onlyOncePhotos) {
      if (UPLOAD_IMG_INITIALS == "c1") {
        imageCount = int.parse(ligneC.nph1);
      } else if (UPLOAD_IMG_INITIALS == "c2") {
        imageCount = int.parse(ligneC.nph2);
      } else {
        imageCount = int.parse(ligneC.nph1) + int.parse(ligneC.nph2);
      }
      bonImageCount = int.parse(ligneC.phb);
      camionImageCount = int.parse(ligneC.phc);

      onlyOncePhotos = false;
    }
  }

  onUploadImage(ImageController imageController,String type) async {
      String path = await imageController.saveImage();
      if (path.isNotEmpty) {
        setState(() {
          imageCount = filtredList.length;

        });
        imageController.uploadImage(ligneC.a_bcc_nupi, ligneC.a_bcc_num,
                '${UPLOAD_IMG_INITIALS}_${imageCount + 1}', File(path),type)
            .then((value) => {
                  if (value)
                    {
                      setState(() {
                        runLoadGallery = true;
                        imageController.image = null;
                      })
                    }
                });
      } else {
        return Fluttertoast.showToast(
          msg: "prend une photo!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          textColor: Color(0xFFfa6467),
          backgroundColor: Color(0xFFfde8e7),
          fontSize: 16.0,
        );
      }
  }
  onPickImage(ImageController imageController) {
      imageController.pickImageCamera();
      setState(() {
        imageSelected = true;
        imageCount = filtredList.where((url) => url.contains(UPLOAD_IMG_INITIALS.toString())).toList().length;
        camionImageCount = filtredList.where((url) => url.contains('camion')).toList().length;
        bonImageCount = filtredList.where((url) => url.contains('bon')).toList().length;
      });
  }

  uploadImage(ImageController imageController, String type, CmdProvider cmdProvider) {
    bool canUplaod = true;
    String errorMsg = 'type introuvable: $type';
    if(type == 'article'){
      canUplaod = imageCount < 2;
      errorMsg = '2 images pour article est le maximum!';
    }else if(type == 'camion'){
      canUplaod = camionImageCount == 0;
      errorMsg = 'image camion est déja prit';
    }else if(type == 'bon'){
      canUplaod = bonImageCount == 0;
      errorMsg = 'image bon est déja prit';
    }
    if (canUplaod) {
    // showSpinnerDialog(context);
    onUploadImage(imageController, type);

    updateCmdStatus(ligneC.a_bcc_nupi, cmdProvider, false, StatusConstants.EN_PREPARATION);
    // closeSpinnerDialog();
    } else {
      return Fluttertoast.showToast(
        msg: errorMsg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        textColor: const Color(0xFFfa6467),
        backgroundColor: const Color(0xFFfde8e7),
        fontSize: 16.0,
      );
    }
  }

  void updateCmdStatus(String nupi, CmdProvider provider,bool val, String status) {
    Cmd cmd = Cmd(bcc_nupi: nupi, bcc_val: val, bcc_eta: status);
    provider.updateCommande(cmd);
  }

  removeImage(String imgName, ImageController imageController) {
    setState(() {
      showMyDialog = true;
      imageCount = filtredList.length;
      showSpinnerDialog(context);
    });

    imageController.removeImage(ligneC.a_bcc_nupi, ligneC.a_bcc_num, imgName);
    closeSpinnerDialog();
    setState(() {
      runLoadGallery = true;
      imageCount = filtredList.length;
    });
  }
}
