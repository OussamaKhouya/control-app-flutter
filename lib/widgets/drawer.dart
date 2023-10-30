import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/auth_provider.dart';

import '../models/user.dart';


class MyDrawer extends StatelessWidget {

  final bool popCmd,popAccount;
  const MyDrawer({super.key,required this.popCmd,required this.popAccount});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    User currUser = provider.currUser;
    return  Drawer(
      semanticLabel: "Menu",
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
           SizedBox(
             height: 220,
             child: DrawerHeader(
                 decoration: const BoxDecoration(
                   color: Colors.blueAccent,
                 ),
                 child: SingleChildScrollView(
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       CircleAvatar(
                         backgroundImage: AssetImage("assets/img/${currUser.role.toLowerCase()}.png"),
                         // Adjust the size of the CircleAvatar if needed
                         radius: 50, // Change this radius as desired
                       ),
                       const SizedBox(height: 8), // Add some space between the image and text
                       Text(
                         currUser.name,
                         style: const TextStyle(
                           color: Colors.white,
                           fontSize: 18, // Adjust the font size as desired
                         ),
                       ),// Add some space between the image and text
                       Text(
                         currUser.role.toLowerCase(),
                         style: const TextStyle(
                           color: Colors.white,
                           fontSize: 18, // Adjust the font size as desired
                         ),
                       ),
                     ],
                   ),)
             ),
           )
          ,
          const Divider(),
          ListTile(
            title: const Text("Mon Compte"),
            onTap: (){
             popAccount? Navigator.pop(context) : Navigator.pushNamed(context, '/account');
            },
            leading: const Icon(Icons.account_box),
          ),

          ListTile(
            title: const Text("Liste des Commandes"),
            onTap: () {
              popCmd? Navigator.pop(context):Navigator.pushNamed(context, '/commands');
            },
            leading: const Icon(Icons.list),

          ),
          ListTile(
            title: const Text("Se déconnecter"),
            onTap: () async {
              bool flag = await provider.logOut();
              if(flag){
                Navigator.pushNamed(context, "/login");
              }
            },
            leading: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }

}
