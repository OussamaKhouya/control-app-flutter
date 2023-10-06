import 'package:flutter/material.dart';
import 'package:flutter_app/models/compte.dart';
import 'package:flutter_app/widgets/drawer.dart';
import 'package:provider/provider.dart';
import '../providers/compte_provider.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
     final provider = Provider.of<CompteProvider>(context);
      Compte compte = provider.compte;
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Mon Compte"),
      ),
      drawer: const MyDrawer( popCmd: false,popAccount: true,),
      body:  SingleChildScrollView(
        child:  Center(
          child: Container(
            padding: const EdgeInsets.all(10),
            child:   Column(
              children: [
                const SizedBox(height: 50,),
                 CircleAvatar(
                  backgroundImage: AssetImage("assets/${compte.role}.png"),
                  radius: 50,
                ),
                const SizedBox(height: 20,),
                const Text("Mes informations personnelles",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blue),),
                const SizedBox(height: 20,),
                Card(
                  color: Colors.blue,
                  child: Container(
                    padding: const EdgeInsets.all(20) ,
                    child: SizedBox(
                      width: 500,
                     // height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.supervised_user_circle,color: Colors.white,),
                              const SizedBox(width: 10,),
                              Text("Nom Complet : ${compte.name}",style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),),
                            ],
                          ),
                          const SizedBox(height: 15,),
                           Row(
                            children: [
                              const Icon(Icons.verified_user,color: Colors.white),
                              const SizedBox(width: 10,),
                              Text("Nom d'utilisateur : ${compte.username}",style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17)),
                            ],
                          ),
                          const SizedBox(height: 15,),
                           Row(
                            children: [
                              const Icon(Icons.admin_panel_settings,color: Colors.white),
                              const SizedBox(width: 10,),
                              Text("Role : ${compte.role}",style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
