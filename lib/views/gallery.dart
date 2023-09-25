import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';
class Gallery extends StatelessWidget {


   Gallery({super.key});

  List<String> listOfUrls= [
    "https://cosmosmagazine.com/wp-content/uploads/2020/02/191010_nature.jpg",
    "https://scx2.b-cdn.net/gfx/news/hires/2019/2-nature.jpg",
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
                      ElevatedButton(onPressed: (){}, child: const Text("Uploader")),
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
}
