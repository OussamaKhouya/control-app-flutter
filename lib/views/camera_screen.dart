import 'package:flutter/material.dart';
import 'package:flutter_app/models/ligne_c.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter_app/providers/ligne_commande_provider.dart';
import 'package:flutter_app/services/image_controller.dart';
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
  late Future<List<String>> listOfUrls;
  bool imageSelected = false;
  late LigneC ligneC;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ligneC = ModalRoute.of(context)?.settings.arguments as LigneC;
    final AuthProvider provider =
        Provider.of<AuthProvider>(context, listen: false);
    Get.lazyPut(() => ImageController(provider));

    final ligneCmdprovider = Provider.of<LigneCProvider>(context);
    listOfUrls = ligneCmdprovider.getImagesUrl(ligneC.numpiece, ligneC.numero);
    return GetBuilder<ImageController>(builder: (imageController) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Gallery des articles"),
        ),
        body: SafeArea(
            child: Center(
          child: SingleChildScrollView(
              child: Column(
            children: [
              const SizedBox(height: 5),
              Text(
                "Article : ${ligneC.designation}",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                "${ligneC.numpiece} - ${ligneC.numero} ",
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
                  ElevatedButton(
                      child: const Row(
                        children: <Widget>[
                          Icon(Icons.photo_camera_front_outlined, size: 20),
                          Text(' gallery'),
                        ],
                      ),
                      onPressed: () {
                        imageController.pickImageGallery();
                        setState(() {
                          imageSelected = true;
                        });
                      }),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
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
                      onPressed: () {
                        imageController.pickImageCamera();
                        setState(() {
                          imageSelected = true;
                        });
                      }),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
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
                        'Please select an image',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            decoration: TextDecoration.none),
                      )),
              ),
              const SizedBox(
                height: 20,
              ),
              imageSelected
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            child: const Row(
                              children: <Widget>[
                                Icon(Icons.save, size: 20),
                                Text(' save'),
                              ],
                            ),
                            onPressed: () {
                              imageController.saveImage();
                            }),
                        const SizedBox(width: 20),
                        ElevatedButton(
                            child: Row(
                              children: <Widget>[
                                const Icon(Icons.cloud_upload, size: 20),
                                Text(' upload ($imageCount)'),
                              ],
                            ),
                            onPressed: () => {
                                  if (imageCount < 2)
                                    {
                                      imageController
                                          .uploadImage(
                                              ligneC.numpiece,
                                              ligneC.numero,
                                              'c1_${imageCount + 1}')
                                          .then((value) => {
                                                if (value)
                                                  {
                                                    setState(() {
                                                      imageCount++;
                                                    })
                                                  }
                                              })
                                    }
                                  else
                                    {print("i was onPressed $imageCount")}
                                }),
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
                    if (snapshot.hasData) {
                      List<String> nonNullableList = snapshot.data ?? [];
                      return (nonNullableList.isNotEmpty)
                          ? Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Container(
                                      width: 300,
                                      alignment: Alignment.center,
                                      child: GalleryImage(
                                          imageUrls: nonNullableList,
                                          numOfShowImages: (nonNullableList.length)),
                                    )),
                              ],
                            )
                          : const Text('no image from server');
                    } else if (snapshot.hasError) {
                      return const Text('Something went wrong!');
                    }
                    return const Center(child: CircularProgressIndicator());
                  }),
              const SizedBox(height: 10),
            ],
          )),
        )),
      );
    });
  }
}
