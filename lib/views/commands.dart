import 'package:flutter/material.dart';
import 'package:flutter_app/models/commande.dart';
import 'package:flutter_app/providers/commands_provider.dart';
import 'package:flutter_app/providers/ligne_commande_provider.dart';
import 'package:flutter_app/widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Commands extends StatefulWidget {
  const Commands({Key? key}) : super(key: key);
  @override
  State<Commands> createState() => _HomePageState();
}

class _HomePageState extends State<Commands> {
  List<Commande> commands=[];
  List<Commande> _foundCommands = [];
  bool onlyOnce = true;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CommandProvider>(context);
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
                          try{
                           onlyOnce=true;
                           getCmd(provider, true);
                           inputSearch.clear();
                           //_runFilter('');
                           setState(() {
                             _foundCommands = commands;
                           }
                           );
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
                    )
                  ),
                )
              ],
            )
            ,
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: _foundCommands.isNotEmpty
                    ? ListView.builder(
                    itemCount: _foundCommands.length,
                    itemBuilder: (context, index) {
                      Commande cmd = _foundCommands[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        ),
                        key: ValueKey(cmd.numpiece),
                        color: (cmd.saisie!=1)? Colors.blue : Colors.grey.shade500,
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Text(
                                cmd.numpiece.toString(),
                                style: const TextStyle(fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              title: Text(cmd.client,
                                  style: const TextStyle(
                                      color: Colors.white, fontWeight: FontWeight.bold
                                  )
                              ),
                              subtitle: Text(
                                  cmd.date, style: const TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold
                              )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  if (cmd.saisie != 1)
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white, // Set your desired background color here
                                        borderRadius: BorderRadius.circular(8), // Optional: Set border radius for rounded corners
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                  "Confirmation",
                                                  style: TextStyle(color: Colors.blue),
                                                ),
                                                content: Text(
                                                  "Voulez-vous vraiment valider la commande : ${cmd.numpiece} ?",
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      provider.updateCommande(cmd);
                                                      setState(() {
                                                        onlyOnce=true;
                                                        getCmd(provider, true);
                                                        inputSearch.clear();
                                                      });
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: const Text("oui"),
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
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(5), // Optional: Set padding for the InkWell
                                          child: Icon(
                                            Icons.lock_open,
                                            color: Colors.blueAccent,
                                            size: 25,
                                          ),
                                        ),
                                      ),
                                    )
                                  ,
                                  const SizedBox(width: 5,),
                                  if (cmd.saisie != 1)
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white, // Set your desired background color here
                                        borderRadius: BorderRadius.circular(8), // Optional: Set border radius for rounded corners
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          final provider = Provider.of<LigneCProvider>(context, listen: false);
                                          provider.fetchLigneC(cmd.numpiece);
                                          Navigator.pushNamed(context, '/detailsCmd', arguments: cmd.numpiece);
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
                                  if (cmd.saisie == 1)
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


  void getCmd(CommandProvider provider, dbCall) async {
    if(onlyOnce){
      if (dbCall) {
        showSpinner = true;
        commands = await provider.fetchCommands();
        showSpinner = false;
      }
      commands = provider.commands;
      _foundCommands = commands;
    }
  }



  void _runFilter(String enteredKeyword) {
    List<Commande> results = [];
    if (enteredKeyword.isEmpty) {
      results = commands;
    } else {
      results = commands
          .where((command) =>
          command.client.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
              command.numpiece.toLowerCase().contains(enteredKeyword.toLowerCase())
      ).toList();
    }
    setState(() {
      onlyOnce=false;
      _foundCommands = results;
    }
    );

  }


}