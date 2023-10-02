import 'package:flutter/material.dart';
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


  @override
  void initState() {

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);
    Get.lazyPut(() => ImageController(provider));

    final ligneCmdprovider = Provider.of<LigneCProvider>(context);
    listOfUrls = ligneCmdprovider.getImagesUrl('A1', '01');
    return GetBuilder<ImageController>(builder: (imageController) {
      return SafeArea(
          child: Center(
        child: SingleChildScrollView(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.photo_camera_front_outlined),
                        Text('gallery'),
                      ],
                    ),
                    onPressed: () {
                      imageController.pickImageGallery();
                    }),
                ElevatedButton(
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.camera_alt),
                        Text('camera'),
                      ],
                    ),
                    onPressed: () {
                      imageController.pickImageCamera();
                    }),
                ElevatedButton(
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.save),
                        Text('save'),
                      ],
                    ),
                    onPressed: () {
                      imageController.saveImage();
                    }),
                ElevatedButton(
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.cloud_upload),
                        Text('upload ($imageCount)'),
                      ],
                    ),
                    onPressed: () => {
                          if (imageCount < 2)
                            {
                              imageController
                                  .uploadImage(
                                      'A1', '01', 'c1_${imageCount + 1}')
                                  .then((value) => {
                                        if (value)
                                          {
                                            setState(() {
                                              imageCount++;
                                            })
                                          }
                                      })
                            }
                        }),
              ],
            ),
            SizedBox(
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
                  : const Center(child:Text('Please select an image',style: TextStyle(color: Colors.black,fontSize: 14,decoration: TextDecoration.none),)),
            ),
            SizedBox(
              height: 20,
            ),
            FutureBuilder(
                future: listOfUrls,
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    List<String> nonNullableList = snapshot.data ?? [];
                    return (nonNullableList.isNotEmpty)? GalleryImage(imageUrls: nonNullableList, numOfShowImages: 2):Text('no image from server');

                  }else if(snapshot.hasError){
                    return Text('Something went wrong!');
                  }
                  return CircularProgressIndicator();
                })
          ],
        )),
      ));
    });
  }
}
