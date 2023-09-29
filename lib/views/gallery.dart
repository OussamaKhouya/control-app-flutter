import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
class Gallery extends StatelessWidget {

   Gallery({super.key});

  List<String> listOfUrls= [
    "http://192.168.1.100:4300/images/A12345dd/15/c1_2.jpg",
     "http://192.168.1.100:4300/images/A12345dd/15/c1_1.jpg",
     "http://192.168.1.100:4300/images/A12345dd/15/c2_1.png",
  ];
  @override
  Widget build(BuildContext context) {
    String designation = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title:  Text("Pictures d'article: $designation"),
      ),
      //drawer: const MyDrawer(popCmd: false, popAccount: false),
      body:  SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20,),
                  Text("$designation : ",textAlign: TextAlign.center,style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20,),
                  GalleryImage(
                    key: key,
                    imageUrls: listOfUrls,
                    numOfShowImages: 2,
                    titleGallery: 'Pictures : $designation',
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(onPressed: (){
                        createFolder();
                      }, child: const Text("Uploader")),
                      const SizedBox(width: 10,),
                      ElevatedButton(onPressed: (){},
                        style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)), child: const Text("Annuler"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ),
      ),
    );
  }

   Future<void> createFolder() async {
     Directory? directory = await getExternalStorageDirectory();
     String folderName = "MyFolder"; // Name of the folder you want to create
     String directoryPath = "${directory?.path}/$folderName";

     // Create the folder
     Directory(directoryPath).create(recursive: true);
     print("directory created!");
     print(directoryPath);
   }
}
