import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/auth_provider.dart';

import '../models/compte.dart';
import '../providers/compte_provider.dart';


class MyDrawer extends StatelessWidget {

  final bool popCmd,popAccount;
  const MyDrawer({super.key,required this.popCmd,required this.popAccount});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CompteProvider>(context);
    Compte compte = provider.compte;
    return  Drawer(
      semanticLabel: "Menu",
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
           DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/${compte.role}.png"),
                  // Adjust the size of the CircleAvatar if needed
                  radius: 50, // Change this radius as desired
                ),
                const SizedBox(height: 8), // Add some space between the image and text
                Text(
                  "${compte.role} : ${compte.name}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18, // Adjust the font size as desired
                  ),
                ),
              ],
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
            title: const Text("Deconexion"),
            onTap: (){
              logout(context);
            },
            leading: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }

  Future<void> logout(context) async {
    final AuthProvider provider =
    Provider.of<AuthProvider>(context, listen: false);

    await provider.logOut();
  }
}
