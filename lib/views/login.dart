import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:device_info/device_info.dart';

class Login extends StatefulWidget {
  const Login({super.key});


  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  late String deviceName;

  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    getDeviceName();
  }

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
                margin: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.name,
                            controller: usernameController,
                            validator: (String? value) {
                              if (value!.trim().isEmpty) {
                                return 'Entrer Nom d\'utilisateur';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
                          ),
                          TextFormField(
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            controller: passwordController,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'Entrer Mot de passe';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'Mot de passe'),
                          ),
                          ElevatedButton(
                            onPressed: () => submit(),
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 36)),
                            child: const Text('Se connecter'),
                          ),
                          Text(errorMessage,
                              style: TextStyle(color: Colors.red)),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/register');
                              },
                              child: Text('Créer un nouveau utilisateur'),
                            ),
                          )
                        ],
                      )),
                ),
              )
            ],
          ),
        ));
  }
  Future submit() async {
    final form = _formKey.currentState;

    if (!form!.validate()) {
      return;
    }

    final AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await provider.login(
          usernameController.text,
          passwordController.text,
          deviceName);
    } catch (Exception) {
      setState(() {
        errorMessage = Exception.toString().replaceAll('Exception:', '');
      });
    }
  }

  Future<void> getDeviceName() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        setState(() {
          deviceName = build.model;
        });
      } else if (Platform.isIOS) {
        var build = await deviceInfoPlugin.iosInfo;
        setState(() {
          deviceName = build.model;
        });
      }
    } on PlatformException {
      setState(() {
        deviceName = 'Failed to get platform version';
      });
    }
  }
}
