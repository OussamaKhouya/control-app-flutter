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


  final inputSearch= TextEditingController();

   List<Map<String, dynamic>> _allUsers =[
    {"numpiece": 1, "client": "Andy", "date": "29"},
    {"numpiece": 2, "client": "Aragon", "date": "40"},
    {"numpiece": 3, "client": "Bob", "date": "5"},
    {"numpiece": 4, "client": "Barbara", "date": "35"},
  ];
  //List<Map<String, dynamic>> _allUsers = [];
  List<Commande> _foundUsers = [];
  // This list holds the data for the list view

  @override
  initState() {

    super.initState();
  }


  void _runFilter(String enteredKeyword) {
    List<Commande> results = [];
    if (enteredKeyword.isEmpty) {
      // If the search field is empty or only contains white-space, we'll display all users
      results = commands;
      print(commands);
      print(results);
    } else {
      results = commands
          .where((user) =>
          user.client.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // We use the toLowerCase() method to make it case-insensitive
    }

    // Update the _foundUsers list and trigger a rebuild
    setState(() {
      _foundUsers = results;
    });
    print(commands);
    print(results);
  }

   List<Commande> commands=[];
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CommandProvider>(context);
    commands = provider.commands;
    _foundUsers = commands;
    // _allUsers=commands.map((commande) {
    //   return{
    //     "numpiece" : commande.numpiece,
    //     "client": commande.client,
    //     "date" : commande.date
    //   };
    // }).toList();
    //  _foundUsers = _allUsers;

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
              child: _foundUsers.isNotEmpty
                  ? ListView.builder(
                itemCount: _foundUsers.length,
                itemBuilder: (context, index) => Card(
                  key: ValueKey(_foundUsers[index].numpiece),
                  color: Colors.blue,
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: Text(
                      _foundUsers[index].numpiece.toString(),
                      style: const TextStyle(fontSize: 16, color:Colors.white,fontWeight: FontWeight.bold),
                    ),
                    title: Text(_foundUsers[index].client, style:const TextStyle(
                        color:Colors.white,fontWeight: FontWeight.bold
                    )),
                    subtitle: Text(
                        _foundUsers[index].date,style:const TextStyle(
                        color:Colors.white,fontWeight: FontWeight.bold
                    )),
                    trailing: InkWell(child: const Icon(Icons.arrow_forward,color: Colors.white)
                    ,onTap: (){ Navigator.pushNamed(context, '/detailsCmd', arguments:_foundUsers[index].numpiece ); },
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


}