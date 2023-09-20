import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/drawer.dart';

class Commands extends StatefulWidget {
  const Commands({Key? key}) : super(key: key);
  @override
  State<Commands> createState() => _HomePageState();
}


class _HomePageState extends State<Commands> {
  final inputSearch= TextEditingController();
  final List<Map<String, dynamic>> _allUsers = [
    {"numpiece": "A0102030104", "name": "Ahmed ALAMI", "date": '09/01/23'},
    {"numpiece": "B0102030104", "name": "Rachid ALAMI ", "date": '29/01/23'},
    {"numpiece": "C0102030104", "name": "Hamid ALAMI", "date": '30/01/23'},
    {"numpiece": "D0102030104", "name": "Yassine ALAMI ", "date": '10/02/23'},
    {"numpiece": "E0102030104", "name": "Reda ALAMI ", "date": '15/02/23'},
    {"numpiece": "F0102030104", "name": "Hamza ALAMI ", "date": '16/02/23'},
    {"numpiece": "G0102030104", "name": "Mohamed ALAMI ", "date": '18/02/23'},
    {"numpiece": "H0102030104", "name": "Ali ALAMI ", "date": '20/02/23'},
    {"numpiece": "K0102030104", "name": "Rachid ALAMI ", "date": '22/02/23'},
    {"numpiece": "L0102030104","name":  "Ahmed ALAMI ", "date": '26/02/23'},
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
          user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // We use the toLowerCase() method to make it case-insensitive
    }

    // Update the _foundUsers list and trigger a rebuild
    setState(() {
      _foundUsers = results;
    });
  }

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
                  key: ValueKey(_foundUsers[index]["numpiece"]),
                  color: Colors.blue,
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: Text(
                      _foundUsers[index]["numpiece"].toString(),
                      style: const TextStyle(fontSize: 16, color:Colors.white,fontWeight: FontWeight.bold),
                    ),
                    title: Text(_foundUsers[index]['name'], style:const TextStyle(
                        color:Colors.white,fontWeight: FontWeight.bold
                    )),
                    subtitle: Text(
                        _foundUsers[index]["date"].toString(),style:const TextStyle(
                        color:Colors.white,fontWeight: FontWeight.bold
                    )),
                    trailing: InkWell(child: const Icon(Icons.arrow_forward,color: Colors.white)
                    ,onTap: (){ Navigator.pushNamed(context, '/detailsCmd', arguments:_foundUsers[index]["numpiece"].toString() ); },
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