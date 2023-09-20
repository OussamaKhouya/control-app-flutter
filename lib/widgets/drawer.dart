import 'package:flutter/material.dart';
class MyDrawer extends StatelessWidget {

  final bool popCmd,popAccount;
  const MyDrawer({super.key,required this.popCmd,required this.popAccount});

  @override
  Widget build(BuildContext context) {
    return  Drawer(
      semanticLabel: "Menu",
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/man.png"),
                  // Adjust the size of the CircleAvatar if needed
                  radius: 50, // Change this radius as desired
                ),
                SizedBox(height: 8), // Add some space between the image and text
                Text(
                  "Controller 1 : Amine",
                  style: TextStyle(
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
              Navigator.pushNamed(context, '/login');
            },
            leading: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
