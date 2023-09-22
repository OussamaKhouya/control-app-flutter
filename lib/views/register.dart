import 'dart:io';

import 'package:flutter_app/providers/auth_provider.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final roleController = TextEditingController(text: 'Commercial');
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  late String deviceName;

  String errorMessage = '';

  final _roles = ["Saisie", "Commercial","Control1","Control2"];

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
          title: const Text('S’inscrire'),
        ),
        body: Center(
          child: SafeArea(
              child: SingleChildScrollView(
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
                                  controller: nameController,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Entrer Nom Complet';
                                    }
                                    return null;
                                  },
                                  onChanged: (text) =>
                                      setState(() => errorMessage = ''),
                                  decoration: const InputDecoration(labelText: 'Nom Complet'),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.name,
                                  controller: usernameController,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Entrer Nom d\'utilisateur';
                                    }
                                    return null;
                                  },
                                  onChanged: (text) =>
                                      setState(() => errorMessage = ''),
                                  decoration: const InputDecoration(labelText: 'Nom d\'utilisateur'),
                                ),
                                DropdownButtonFormField<String>(
                                  hint: const Text('Selectionner un Role'),
                                  items: _roles.map((String item) =>
                                      DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(item)
                                      )).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      roleController.text = value!;
                                    });
                                  },
                                  value: roleController.text,
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
                                  onChanged: (text) =>
                                      setState(() => errorMessage = ''),
                                  decoration: const InputDecoration(labelText: 'Mot de passe'),
                                ),
                                TextFormField(
                                  obscureText: true,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  controller: passwordConfirmController,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Entrer à nouveau';
                                    }
                                    return null;
                                  },
                                  onChanged: (text) =>
                                      setState(() => errorMessage = ''),
                                  decoration:
                                  const InputDecoration(labelText: 'Confirmer mot de passe'),
                                ),
                                ElevatedButton(
                                  onPressed: () => submit(),
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(double.infinity, 36)),
                                  child: const Text('Enregistrer'),
                                ),
                                Text(errorMessage,
                                    style: TextStyle(color: Colors.red)),
                                Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('<- Retour à la page de connexion'),
                                  ),
                                )
                              ],
                            )),
                      ),
                    )
                  ],
                ),
              )
          )
        )
    );
  }

  Future submit() async {
    final form = _formKey.currentState;

    if (!form!.validate()) {
      return;
    }

    final AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);
    try {
       await provider.register(
          nameController.text,
          usernameController.text,
          roleController.text.toUpperCase(),
          passwordController.text,
          passwordConfirmController.text,
          deviceName);

      Navigator.pop(context);
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
      print(deviceName);
    } on PlatformException {
      setState(() {
        deviceName = 'Failed to get platform version';
      });
    }
  }
}
