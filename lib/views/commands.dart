import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/models/cmd.dart';
import 'package:flutter_app/models/constants.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter_app/providers/cmd_provider.dart';
import 'package:flutter_app/providers/lcmd_provider.dart';
import 'package:flutter_app/widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Commands extends StatefulWidget {
  const Commands({Key? key}) : super(key: key);
  @override
  State<Commands> createState() => _HomePageState();
}

class _HomePageState extends State<Commands> {
  List<Cmd> commands=[];
  List<Cmd> _foundCommands = [];
  bool onlyOnce = true;

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<CmdProvider>(context);
    getPermissions();
    getCmd(provider,false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Commandes'),
      ),
      drawer:  const MyDrawer( popCmd: true,popAccount: false,),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: inputSearch,
                    onChanged: (value) => _runFilter(value),
                    decoration: InputDecoration(
                      labelText: 'Rechercher',
                      suffixIcon: InkWell(
                        child: const Icon(Icons.close),
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
                     color: Colors.lightBlue,
                    elevation: 1.0, // Add elevation for a button-like appearance
                    child: Padding(
                      padding: const EdgeInsets.all(4.0), // Add space around the icon
                      child: InkWell(
                        child:  const Icon(Icons.refresh,color: Colors.white, size: 35,),
                        onTap: () {
                           onlyOnce=true;
                           getCmd(provider, true);
                           inputSearch.clear();
                           //_runFilter('');
                           setState(() {
                             _foundCommands = commands;
                           }
                           );
                        },
                      ),
                    )
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: _foundCommands.isNotEmpty
                    ? ListView.builder(
                    itemCount: _foundCommands.length,
                    itemBuilder: (context, index) {
                      Cmd cmd = _foundCommands[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        ),
                        key: ValueKey(cmd.bcc_nupi),
                        color: (!cmd.bcc_val)? Colors.blue : Colors.grey.shade500,
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Text(
                                cmd.bcc_nupi.toString(),
                                style: const TextStyle(fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              title: Text(cmd.bcc_lcli,
                                  style: const TextStyle(
                                      color: Colors.white, fontWeight: FontWeight.bold
                                  )
                              ),
                              subtitle: Text(
                                  cmd.bcc_dat, style: const TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold
                              )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  if (!cmd.bcc_val)
                                    Visibility(
                                        visible:SHOW_BTN_VER,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white, // Set your desired background color here
                                            borderRadius: BorderRadius.circular(8), // Optional: Set border radius for rounded corners
                                          ),
                                          child: InkWell(
                                            onTap: () => lockCmd(provider, cmd),
                                            child: const Padding(
                                              padding: EdgeInsets.all(5), // Optional: Set padding for the InkWell
                                              child: Icon(
                                                Icons.lock_open,
                                                color: Colors.blueAccent,
                                                size: 25,
                                              ),
                                            ),
                                          ),
                                        )),
                                  const SizedBox(width: 5,),
                                  if (!cmd.bcc_val)
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white, // Set your desired background color here
                                        borderRadius: BorderRadius.circular(8), // Optional: Set border radius for rounded corners
                                      ),
                                      child: InkWell(
                                        onTap: () async {
                                          final provider0 = Provider.of<LCmdProvider>(context, listen: false);
                                          provider0.fetchLigneC(cmd.bcc_nupi);
                                          var refresh = await Navigator.pushNamed(context, '/detailsCmd', arguments: cmd.bcc_nupi);
                                          updateCmdStatus(cmd, provider);
                                          if(refresh == true || refresh == null){
                                            onlyOnce=true;
                                            getCmd(provider, true);
                                            inputSearch.clear();
                                            //_runFilter('');

                                            setState(() {
                                              _foundCommands = commands;
                                            }
                                            );
                                          }
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(5), // Optional: Set padding for the InkWell
                                          child: Icon(
                                            Icons.arrow_forward,
                                            color: Colors.blueAccent,
                                            size: 25,
                                          ),
                                        ),
                                      ),
                                    )
                                  ,
                                  if (cmd.bcc_val)
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Validé",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(
                                          Icons.lock,
                                          color: Colors.white,
                                        ),
                                      ],
                                    )
                                ],
                              ),
                            ),
                          ],
                        )
                      );
                    }
                ) :
                Column(
                  children: [
                    (showSpinner)? const Text("Aucun résultat trouvé", style: TextStyle(fontSize: 24),) :
                    const SpinKitRing(color: Colors.blue, size: 50.0,)
                  ],
                )
            ),
        ],
        ),
      ),
    );

  }


  final inputSearch= TextEditingController();

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final provider = Provider.of<CommandProvider>(context);
  //   commands = provider.commands;
  //   _foundCommands = List.from(commands);
  // }

  bool showSpinner = false;

  void getCmd(CmdProvider provider, dbCall) async {
    if(onlyOnce){
      if (dbCall) {
        showSpinner = true;
        showSpinnerDialog(context);
        commands = await provider.fetchCommands();
        showSpinner = false;
        closeSpinnerDialog();
      }
      commands = provider.commands;
      _foundCommands = commands;
    }
  }

  void _runFilter(String enteredKeyword) {
    List<Cmd> results = [];
    if (enteredKeyword.isEmpty) {
      results = commands;
    } else {
      results = commands
          .where((command) =>
          command.bcc_lcli.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
              command.bcc_nupi.toLowerCase().contains(enteredKeyword.toLowerCase())
      ).toList();
    }
    setState(() {
      onlyOnce=false;
      _foundCommands = results;
    }
    );

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

  // Initialize Permissions
  late bool SHOW_BTN_VER;

  void getPermissions() {
    final provider = Provider.of<AuthProvider>(context);
    Map<String, dynamic> permissions = provider.permissions;
    SHOW_BTN_VER = permissions[PermConstants.SHOW_BTN_VER]!;

  }

  lockCmd(CmdProvider provider, Cmd cmd) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Confirmation",
            style: TextStyle(color: Colors.black54),
          ),
          content: Text(
            "Voulez-vous vraiment valider la commande : ${cmd.bcc_nupi} ?",
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                updateCmdValid(cmd, provider);
                setState(() {
                  onlyOnce=true;
                  getCmd(provider, true);
                  inputSearch.clear();
                });
                Navigator.of(context).pop();
              },
              child: const Text("oui",style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("non"),
            ),
          ],
        );
      },
    );
  }

  void updateCmdStatus(Cmd cmd, CmdProvider provider) {
    cmd.bcc_val = true;
    provider.updateCommande(cmd);
  }

  void updateCmdValid(Cmd cmd, CmdProvider provider) {
    cmd.bcc_eta = StatusConstants.EN_PREPARATION;
    provider.updateCommande(cmd);
  }
}