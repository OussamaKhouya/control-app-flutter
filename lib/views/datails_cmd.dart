import 'package:flutter/material.dart';
import 'package:flutter_app/models/constants.dart';
import 'package:flutter_app/models/lcmd.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../providers/lcmd_provider.dart';
import '../widgets/ligne_cmd_edit.dart';

class DetailsCmd extends StatefulWidget {
  const DetailsCmd({super.key});

  @override
  State<DetailsCmd> createState() => _DetailsCmdState();
}

class _DetailsCmdState extends State<DetailsCmd> {
  List<LCmd> LigneCommands = [];
  String numpiece = '';
  final inputSearch = TextEditingController();
  String? UPLOAD_IMG_INITIALS;
  int imageCount = 0;

  // This list holds the data for the list view
  List<LCmd> _foundLigneCmd = [];
  bool onlyOnce = true;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LCmdProvider>(context);
    getLignCmd(provider, false);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de Commande'),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context,true)
          )
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
                  "${LigneCommands.length} articles dans: $numpiece",
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
                              child: const Icon(
                                Icons.refresh,
                                color: Colors.white,
                                size: 35,
                              ),
                              onTap: () {
                                onlyOnce = true;
                                getLignCmd(provider, true);
                                inputSearch.clear();
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
                              LCmd lignC = _foundLigneCmd[index];
                              getPermissions(authProvider, lignC);
                              return Card(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                key: ValueKey(lignC.a_bcc_nupi),
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
                                          '${lignC.a_bcc_nupi} - ${lignC.a_bcc_num}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          lignC.a_bcc_lib,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          '($imageCount photo)',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Quantité: ${lignC.a_bcc_qua}",
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
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                          onTap: () async {
                                            Navigator.pushNamed(
                                                context, '/camera',
                                                arguments: lignC);
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
                              (showSpinner)
                                  ? const Text(
                                      "Aucun résultat trouvé",
                                      style: TextStyle(fontSize: 24),
                                    )
                                  : const SpinKitRing(
                                      color: Colors.blue,
                                      size: 50.0,
                                    )
                            ],
                          )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getPermissions(authProvider, LCmd lcmd) {

    Map<String, dynamic> permissions = authProvider.permissions;

    UPLOAD_IMG_INITIALS = permissions[PermConstants.UPLOAD_IMG_INITIALS]!;

      if(UPLOAD_IMG_INITIALS == "c1"){
        imageCount = int.parse(lcmd.nph1);
      }else if(UPLOAD_IMG_INITIALS == "c2"){
        imageCount = int.parse(lcmd.nph2);
      }else {
        imageCount = int.parse(lcmd.nph1) + int.parse(lcmd.nph2);
      }

  }

  showSpinnerDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5),child:Text(" Chargement",style: TextStyle(color: Colors.blue))),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  closeSpinnerDialog(){Navigator.of(context).pop();}

  bool showSpinner = false;

  void getLignCmd(LCmdProvider provider, dbCall) async {
    numpiece = ModalRoute.of(context)?.settings.arguments as String;
    if (onlyOnce) {
      if (dbCall) {
        showSpinner = true;
        showSpinnerDialog(context);
        LigneCommands = await provider.fetchLigneC(numpiece);
        closeSpinnerDialog();
        showSpinner = false;
      }
      LigneCommands = provider.ligne_commands;
      _foundLigneCmd = LigneCommands;
    }
  }

  void _runFilter(String enteredKeyword) {
    List<LCmd> results = [];
    if (enteredKeyword.isEmpty) {
      results = LigneCommands;
    } else {
      results = LigneCommands.where((ligneC) => ligneC.a_bcc_lib
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase())).toList();
    }
    setState(() {
      onlyOnce = false;
      _foundLigneCmd = results;
    });
  }
}
