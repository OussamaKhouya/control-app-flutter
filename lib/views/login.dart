import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueAccent,
        appBar: AppBar(
          title: const Text('Connexion'),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                elevation: 8,
                margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      const TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
                      ),
                      const TextField(
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(labelText: 'Mot de passe'),

                      ),
                      ElevatedButton(
                        onPressed: () => {Navigator.pushNamed(context, '/commands')},
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 36)),
                        child: const Text('Se connecter'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: InkWell(
                          onTap: () {Navigator.pushNamed(context, '/register');},
                          child:  Text(' Créer un nouveau utilisateur',style: TextStyle(color: Colors.grey[600])),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
