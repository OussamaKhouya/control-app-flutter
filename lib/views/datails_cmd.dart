import 'package:flutter/material.dart';
import 'package:flutter_app/models/ligne_c.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../providers/ligne_commande_provider.dart';
import '../widgets/ligne_cmd_edit.dart';

class DetailsCmd extends StatefulWidget {
  const DetailsCmd({super.key});

  @override
  State<DetailsCmd> createState() => _DetailsCmdState();
}

class _DetailsCmdState extends State<DetailsCmd> {
  List<LigneC> LigneCommands = [];
  String numpiece = '';
  final inputSearch = TextEditingController();

  // This list holds the data for the list view
  List<LigneC> _foundLigneCmd = [];
  bool onlyOnce = true;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LigneCProvider>(context);
    getLignCmd(provider, false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de Commande'),
      ),
      // drawer: const MyDrawer( popCmd: false,popAccount: false,),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 35,
                ),
                Text(
                  "${LigneCommands.length} Articles de Commande: $numpiece",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 35,
                ),
                Row(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Expanded(
                      child: TextField(
                        controller: inputSearch,
                        onChanged: (value) => _runFilter(value),
                        decoration: InputDecoration(
                          labelText: 'Rechercher',
                          suffixIcon: InkWell(
                            child: Icon(
                              Icons.close,
                              color: Colors.grey[700],
                            ),
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
                          borderRadius: BorderRadius.circular(4.0),
                          // Adjust the border radius as needed
                          color: Colors.blue,
                          elevation: 1.0,
                          // Add elevation for a button-like appearance
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            // Add space around the icon
                            child: InkWell(
                              child: const Icon(Icons.refresh,color: Colors.white,size: 35,),
                              onTap: () {
                                try{
                                  onlyOnce=true;
                                  getLignCmd(provider, true);
                                  inputSearch.clear();
                                }catch (exp){
                                  print('Erreur lors de la requête API : $exp');
                                }

                                showDialog(context: context,
                                    builder: (BuildContext context){
                                      return AlertDialog(
                                        title: const Text("Liste Actualisé",style: TextStyle(color: Colors.blue),),
                                        content: const Text("La liste a été actualisée avec succès",style: TextStyle(
                                            color: Colors.blue
                                        ),),
                                        actions: <Widget>[
                                          TextButton(onPressed: (){Navigator.of(context).pop();}, child: const Text("OK"),)
                                        ],
                                      );
                                    }
                                );
                              },
                            ),
                          )),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                    child: _foundLigneCmd.isNotEmpty
                        ? ListView.builder(
                            itemCount: _foundLigneCmd.length,
                            itemBuilder: (context, index) {
                              LigneC lignC = _foundLigneCmd[index];
                              return Card(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                key: ValueKey(lignC.numpiece),
                                elevation: 4,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                // color: Colors.white,
                                child: ListTile(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  tileColor: Colors.blue,
                                  // Change color to indicate card
                                  contentPadding: const EdgeInsets.all(16),
                                  // Add padding for content
                                  leading: CircleAvatar(
                                    // Display user image here
                                    backgroundColor: Colors.white,
                                    child: InkWell(
                                      child: const Icon(Icons.edit),
                                      onTap: () {
                                        showModalBottomSheet(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                              top: Radius.circular(25),
                                            )),
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return LigneCmdEdit(lignC,
                                                  provider.updateTransaction);
                                            });
                                      },
                                    ),
                                  ),
                                  title: Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${lignC.numpiece} - ${lignC.numero}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          lignC.designation,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),const SizedBox(
                                          height: 8,
                                        ),Text(
                                          '(${lignC.nbrPhoto} photo)',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Quantité: ${lignC.quantite}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        // Subtitle color for readability
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),

                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Tooltip(
                                        message: 'Capture Image',
                                        // Tooltip for clarity
                                        child: InkWell(
                                          child: const Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,size: 30,
                                          ),
                                          onTap: () async {
                                            Navigator.pushNamed(
                                                context, '/camera', arguments:lignC);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Column(
                            children: [
                              (showSpinner)? const Text("Aucun résultat trouvé", style: TextStyle(fontSize: 24),) :
                               const SpinKitRing(color: Colors.blue, size: 50.0,)
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

  bool showSpinner = false;

  void getLignCmd(LigneCProvider provider, dbCall) async {
    numpiece = ModalRoute.of(context)?.settings.arguments as String;
    if(onlyOnce){
      if (dbCall) {
        showSpinner = true;
        LigneCommands = await provider.fetchLigneC(numpiece);
        showSpinner = false;
      }
      LigneCommands = provider.ligne_commands;
      _foundLigneCmd = LigneCommands;
    }
  }

  void _runFilter(String enteredKeyword) {
    List<LigneC> results = [];
    if (enteredKeyword.isEmpty) {
      results = LigneCommands;
    } else {
      results = LigneCommands.where((ligneC) => ligneC.designation
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase())).toList();
    }
    setState(() {
       onlyOnce=false;
      _foundLigneCmd = results;
    }
    );
  }


}
