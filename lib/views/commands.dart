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
  @override
  Widget build(BuildContext context) {
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
                      padding: const EdgeInsets.all(8.0), // Add space around the icon
                      child: InkWell(
                        child: const Icon(Icons.refresh,color: Colors.white,),
                        onTap: () {
                          try{
                            final provider = Provider.of<CommandProvider>(context,listen: false);
                            provider.fetchCommands();
                            _foundCommands=provider.commands;
                          }catch (exp){
                            print('Erreur lors de la requête API : $exp');
                          }
                           setState( () {
                             inputSearch.clear();
                             _runFilter('');
                           }
                           );
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
                itemBuilder: (context, index) => Card(
                  key: ValueKey(_foundCommands[index].numpiece),
                  color: Colors.blue,
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: Text(
                      _foundCommands[index].numpiece.toString(),
                      style: const TextStyle(fontSize: 16, color:Colors.white,fontWeight: FontWeight.bold),
                    ),
                    title: Text(_foundCommands[index].client, style:const TextStyle(
                        color:Colors.white,fontWeight: FontWeight.bold
                    )),
                    subtitle: Text(
                        _foundCommands[index].date,style:const TextStyle(
                        color:Colors.white,fontWeight: FontWeight.bold
                    )),
                    trailing: InkWell(child: const Icon(Icons.arrow_forward,color: Colors.white)
                    ,onTap: (){
                        Navigator.pushNamed(context, '/detailsCmd', arguments:_foundCommands[index].numpiece );
                      },
                    ),
                  ),
                ),
              ) :
              const Column(
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
    );

  }


  final inputSearch= TextEditingController();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<CommandProvider>(context);
    commands = provider.commands;
    _foundCommands = List.from(commands);
  }

  // void getCmd() async {
  //
  //   final provider = Provider.of<CommandProvider>(context, listen: false);
  //
  //   commands = await provider.fetchCommands();
  //
  //   inputSearch.clear();
  //   _runFilter('');
  //   setState(() {
  //     _foundCommands = commands;
  //   });
  // }


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
      _foundCommands = results;
    }
    );
  }


}