import 'package:flutter/material.dart';
import 'package:flutter_app/models/commande.dart';
import 'package:flutter_app/providers/commands_provider.dart';
import 'package:flutter_app/widgets/drawer.dart';
import 'package:provider/provider.dart';

class Commands extends StatefulWidget {
  const Commands({Key? key}) : super(key: key);
  @override
  State<Commands> createState() => _HomePageState();
}


class _HomePageState extends State<Commands> {


  List<Commande> commands=[];
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CommandProvider>(context);
    commands = provider.commands;

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
                        onTap: (){
                          inputSearch.clear();
                          _runFilter('');
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
                    ,onTap: (){ Navigator.pushNamed(context, '/detailsCmd', arguments:_foundCommands[index].numpiece ); },
                    ),
                  ),
                ),
              )
                  : const Text(
                'Aucun résultat trouvé',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );

  }


  final inputSearch= TextEditingController();
  List<Commande> _foundCommands = [];

  @override
  initState() {
    _foundCommands=commands;
    super.initState();
  }

  //Fonction filter qui sert à filtrer data en changant la valeur de l'input search
  void _runFilter(String enteredKeyword) {

    List<Commande> results = [];

    if (enteredKeyword.isEmpty) {
      // If the search field is empty or only contains white-space, we'll display all users
      results = commands;
    } else {
      results = commands
          .where((command) =>
          command.client.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // We use the toLowerCase() method to make it case-insensitive
    }

    // Update the _foundUsers list and trigger a rebuild
    setState(() {
      _foundCommands = results;
    }
    );

  }

}