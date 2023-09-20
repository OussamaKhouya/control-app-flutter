import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueAccent,
        appBar: AppBar(
          title: const Text('S’inscrire'),

        ),
        body: Center(
          child:  SafeArea(
              child: SingleChildScrollView(
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
                            Text("Formulaire d'inscription" , style:TextStyle(color: Colors.grey[600],fontSize: 15),),
                            const TextField(
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(labelText: 'Nom Complet'),
                            ),
                            const TextField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
                            ),
                            const TextField(
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(labelText: 'Mot de passe'),
                            ),
                            const TextField(
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(labelText: 'Confirmer mot de passe'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/commands');
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 36),),
                              child: const Text('Register'),

                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child:  Text('<- Retour à la page de connexion', style: TextStyle(color: Colors.grey[600])),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )

          ),
        )

    );
  }
}
