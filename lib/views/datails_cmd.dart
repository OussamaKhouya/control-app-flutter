import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/ligne_c.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../providers/ligne_commande_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class DetailsCmd extends StatefulWidget {

  const DetailsCmd({super.key});

  @override
  State<DetailsCmd> createState() => _DetailsCmdState();
}

class _DetailsCmdState extends State<DetailsCmd> {


  File? _pickedImage; // Define a variable to store the picked image


  // Function to set the picked image and trigger a rebuild
  void _setPickedImage(File image) {
    setState(() {
      _pickedImage = image;
    });
  }
  List<LigneC> LigneCommands=[];
  @override
  Widget build(BuildContext context) {


    String numpiece = ModalRoute.of(context)?.settings.arguments as String;


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
                children: [
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
                                  final provider = Provider.of<LigneCProvider>(context,listen: false);
                                  inputSearch.clear();
                                  _runFilter('');
                                  setState(() {
                                    _foundLigneCmd=provider.ligne_commands;
                                  });
                                },
                              ),
                            )
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15,),
        Expanded(
          child: _foundLigneCmd.isNotEmpty
              ? ListView.builder(
            itemCount: _foundLigneCmd.length,
            itemBuilder: (context, index) => Card(
              shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(10)
                    )
                ),
              key: ValueKey(_foundLigneCmd[index].numpiece),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
             // color: Colors.white,
              child: ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10)
                  )
                ),
                tileColor: Colors.blue, // Change color to indicate card
                contentPadding: const EdgeInsets.all(16), // Add padding for content
                leading:   CircleAvatar( // Display user image here
                  backgroundColor: Colors.white,
                  child: InkWell(child: const Icon(Icons.edit),
                  onTap: (){
                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25),
                        )
                      ),
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
     return SafeArea(
       child: Container(
                height: MediaQuery.of(context).size.height*0.97,
                padding: const EdgeInsets.all(25),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        _foundLigneCmd[index].designation,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 21,),
                      Form(
                        child: Column(
                          children: [
                            Text("La quanitité demandé : ${_foundLigneCmd[index].quantite}",style: const TextStyle(
                              fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blue
                            ),),
                            const SizedBox(height: 17,),
                            TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'La Quantité Livrée : 10',
                              ),
                            ),
                            const SizedBox(height: 15,),
                            TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'La Quantité vérifiée : 10',
                              ),
                            ),
                            const SizedBox(height: 15,),
                            TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Observation :',
                              ),
                            ),
                            const SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: (){},
                                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.grey)),
                                  child: const Text("Verrouiller"),
                                ),
                                const SizedBox(width: 10,),
                                ElevatedButton(
                                  onPressed: (){},
                                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                                  child: const Text("Modifier"),
                                ),
                                const SizedBox(width: 10,),
                                ElevatedButton(
                                  onPressed: (){Navigator.pop(context);},
                                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
                                  child: const Text("Annuler"),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ),
     );
        },

  );
                  },
                  ),
                ),
                          title:
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_foundLigneCmd[index].numpiece} (0_pics)',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8,),
                                Text(
                                  _foundLigneCmd[index].designation,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          subtitle: Text(
                            "Quantité: ${_foundLigneCmd[index].quantite}",
                            style: const TextStyle(
                              color: Colors.white, // Subtitle color for readability
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                            ),
                          ),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              Tooltip(
                                message: 'View Details', // Tooltip for clarity
                                child: InkWell(
                                  child: const Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.white,

                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/gallery',
                                        arguments: _foundLigneCmd[index].designation);
                                  },
                                ),
                              ),
                              const SizedBox(width: 5),
                              Tooltip(
                                message: 'Capture Image', // Tooltip for clarity
                                child: InkWell(
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,

                                  ),
                                  onTap: () async {
                                    final image = await _pickImageCamera();
                                    if (image != null) {
                                      _setPickedImage(image);
                                      await _saveImageToDirectory(image);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                        :   const Column(
            children: [
              Text("Aucun résultat trouvé", style: TextStyle(fontSize: 24),),
              SpinKitRing(
                color: Colors.blue,
                size: 50.0,
              )
            ],
          )
                  ),
                ],

              ),
            ),
          ),
        ),


    );
  }

  /* Begin Code Filter */


  final inputSearch= TextEditingController();

  // This list holds the data for the list view
  List<LigneC> _foundLigneCmd = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<LigneCProvider>(context);
    LigneCommands = provider.ligne_commands;
    _foundLigneCmd = List.from(LigneCommands);
  }


  void _runFilter(String enteredKeyword) {
    List<LigneC> results = [];
    if (enteredKeyword.isEmpty) {
      // If the search field is empty or only contains white-space, we'll display all users
      results = LigneCommands;
    } else {
      results = LigneCommands
          .where((ligneC) =>
          ligneC.designation.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // We use the toLowerCase() method to make it case-insensitive
    }

    // Update the _foundLigneCmd list and trigger a rebuild
    setState(() {
      _foundLigneCmd = results;
    });
  }


  /* End Code Filter*/

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
