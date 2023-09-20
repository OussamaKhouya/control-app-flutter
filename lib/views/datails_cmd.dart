import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/commande.dart';
import 'package:flutter_app/widgets/drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../widgets/data_table.dart';

class DetailsCmd extends StatefulWidget {
  final String? numpiece;
  const DetailsCmd({super.key, required this.numpiece});

  @override
  State<DetailsCmd> createState() => _DetailsCmdState();
}

class _DetailsCmdState extends State<DetailsCmd> {

  final inputSearch= TextEditingController();
  final List<Map<String, dynamic>> _allUsers = [
    {"numpiece": "A0102030104", "designation": "Clavier hp", "quantite": 'quantite : 10'},
    {"numpiece": "B0102030104", "designation": "Disk dur hdd 1T", "quantite": 'quantite : 3'},
    {"numpiece": "C0102030104", "designation": "Ecran 15 pouce", "quantite": 'quantite : 2'},
    {"numpiece": "D0102030104", "designation": "Souris bleutooth ", "quantite": 'quantite : 15'},
    {"numpiece": "E0102030104", "designation": "Imprimante Lenovo ", "quantite": 'quantite : 1'},
    {"numpiece": "F0102030104", "designation": "Pc hp folio ", "quantite": 'quantite : 5'},
    {"numpiece": "G0102030104", "designation": "Disk dur Sdd 500 GO ", "quantite": 'quantite : 2'},
  ];
  // This list holds the data for the list view
  List<Map<String, dynamic>> _foundUsers = [];

  @override
  initState() {

    _foundUsers = _allUsers;
    super.initState();
  }
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // If the search field is empty or only contains white-space, we'll display all users
      results = _allUsers;
    } else {
      results = _allUsers
          .where((user) =>
          user["designation"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // We use the toLowerCase() method to make it case-insensitive
    }

    // Update the _foundUsers list and trigger a rebuild
    setState(() {
      _foundUsers = results;
    });
  }
  File? _pickedImage; // Define a variable to store the picked image


  // Function to set the picked image and trigger a rebuild
  void _setPickedImage(File image) {
    setState(() {
      _pickedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {

    final String? numpiece= widget.numpiece;

    return Scaffold(
      appBar: AppBar(
        title:  const Text('Détails de Commande'),
      ),
     // drawer: const MyDrawer( popCmd: false,popAccount: false,),

      body:

      SafeArea(

          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 // const Text("Information sur le Commande N1", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
               //   const SizedBox(height: 20,),
                //  const DataTableExample(),
                 // const SizedBox(height: 20,),
                 //  Row(
                 //    mainAxisAlignment: MainAxisAlignment.center,
                 //    children: [
                 //      ElevatedButton(
                 //        onPressed: () async {
                 //          final image = await _pickImageCamera();
                 //          if (image != null) {
                 //            _setPickedImage(image);
                 //            await _saveImageToDirectory(image);
                 //          }
                 //        },
                 //        child: const Text("Pick Camera"),
                 //      ),
                 //      const SizedBox(width: 16),
                 //      ElevatedButton(
                 //        onPressed: () async {
                 //          final image = await _pickImageGallery();
                 //          if (image != null) {
                 //            _setPickedImage(image);
                 //            await _saveImageToDirectory(image);
                 //          }
                 //        },
                 //        child: const Text('Pick Gallery'),
                 //      ),
                 //    ],
                 //  ),
                 //  const SizedBox(height: 16), // Add spacing between buttons and image
                 //  _pickedImage != null
                 //      ? Image.file(
                 //    _pickedImage!,
                 //    width: 300,
                 //    height: 300,
                 //  )
                   //   : const Divider(), // Display an empty container if no image is picked
                // const Divider(
                //   color: Colors.black,
                // ),
                  const SizedBox(height: 35,),
                   Text("Liste des Articles de Commande: $numpiece", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                   textAlign: TextAlign.center,
                   ),
                  const SizedBox(height: 35,),
                  Row(
                    children: [
                      const SizedBox(height: 25,),
                      Expanded(
                        child: TextField(

                          controller: inputSearch,
                          onChanged: (value) => _runFilter(value),
                          decoration: InputDecoration(
                            labelText: 'Rechercher',
                            suffixIcon: InkWell(
                              child: Icon(Icons.close,color: Colors.grey[700],),
                              onTap: () {
                                inputSearch.clear();
                                _runFilter('');
                              },
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Material(
                            borderRadius: BorderRadius.circular(4.0), // Adjust the border radius as needed
                            color: Colors.blue,
                            elevation: 1.0, // Add elevation for a button-like appearance
                            child: Padding(
                              padding: const EdgeInsets.all(8.0), // Add space around the icon
                              child: InkWell(
                                child: const Icon(Icons.refresh,color: Colors.white,),
                                onTap: (){
                                  inputSearch.clear();
                                  _runFilter('');
                                },
                              ),
                            )
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15,),
                   Expanded(
                      child: _foundUsers.isNotEmpty
                          ? ListView.builder(
                        itemCount: _foundUsers.length,
                        itemBuilder: (context, index) => Card(
                          key: ValueKey(_foundUsers[index]["numpiece"]),
                          color: Colors.blue,
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 10,),
                          child: ListTile(
                            leading: Text(
                                "(0)_img / ${_foundUsers[index]["numpiece"]}",
                              style: const TextStyle(fontSize: 16, color:Colors.white,fontWeight: FontWeight.bold),
                            ),
                            title: Text(_foundUsers[index]['designation'], style: const TextStyle(
                                color:Colors.white,fontWeight: FontWeight.bold
                            )),
                            subtitle: Text(
                                _foundUsers[index]["quantite"].toString(),style: const TextStyle(
                                color:Colors.white,fontWeight: FontWeight.bold
                            )),
                            trailing:  Row(
                            mainAxisSize: MainAxisSize.min, // To make the Row as small as possible
                            children: [
                              InkWell(
                                child: const Icon(
                                  Icons.edit,color: Colors.black,size: 20,
                                ),
                                onTap: (){},
                              ),
                              InkWell(
                                child: const Icon(
                                   Icons.remove_red_eye, color: Colors.black,size: 20,// Replace 'icon1' with the first icon you want
                                ),
                                onTap: (){
                                  Navigator.pushNamed(context, '/gallery',arguments:_foundUsers[index]['designation'] );
                                },
                              ),
                              const SizedBox(width: 5),
                              InkWell(
                                child: const Icon(
                                  Icons.camera_alt,color: Colors.black,size: 20, // Replace 'icon2' with the second icon you want
                                ),
                                onTap: () async {
                                  final image = await _pickImageCamera();
                                  if (image != null) {
                                    _setPickedImage(image);
                                    await _saveImageToDirectory(image);
                                  }
                                },
                              ),
                            ],
                          ),
                          ),
                        ),
                      ) : const Text('Aucun résultat trouvé', style: TextStyle(fontSize: 24),
                       )
                     ,
                    ),

                ],

              ),
            ),
          ),
        ),


    );
  }

  Future<File?> _pickImageCamera() async {
    final pickedImage =
    await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage == null) {
      return null; // No image picked
    }
    return File(pickedImage.path);
  }

  Future<File?> _pickImageGallery() async {
    final pickedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      return null; // No image picked
    }
    return File(pickedImage.path);

  }

  Future<void> _saveImageToDirectory(File imageFile) async {
    try {
      // Obtenir le répertoire d'application local
      final appDir = await getApplicationDocumentsDirectory();

      // Créer un dossier "images" s'il n'existe pas
      final imagesDir = Directory('${appDir.path}/images');
      if (!imagesDir.existsSync()) {
        imagesDir.createSync(recursive: true);
      }

      // Générer un nom de fichier unique pour l'image
      final uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Copier l'image dans le dossier "images"
      final savedImage =
      await imageFile.copy('${imagesDir.path}/$uniqueFileName.png');
      print('Image sauvegardée dans : ${savedImage.path}');
    } catch (error) {
      print('Erreur lors de la sauvegarde de l\'image : $error');
    }
  }
}
