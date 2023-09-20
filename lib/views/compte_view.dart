import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/drawer.dart';
class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Mon Compte"),
      ),
      drawer: const MyDrawer( popCmd: false,popAccount: true,),
    );
  }
}
