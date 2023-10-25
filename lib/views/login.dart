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
  bool _isObscured = true;
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
                margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
                            decoration: const InputDecoration(labelText: 'Nom d\'utilisateur'),
                          ),
                          TextFormField(
                            obscureText: _isObscured,
                            enableSuggestions: false,
                            autocorrect: false,
                            controller: passwordController,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'Entrer Mot de passe';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'Mot de passe',
                              suffixIcon: IconButton(
                                icon: Icon(_isObscured ? Icons.visibility: Icons.visibility_off), onPressed: () {
                                  setState(() {
                                    _isObscured = !_isObscured;
                                  });
                              },
                              )
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => submit(),
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 36)),
                            child: const Text('Se connecter'),
                          ),
                          Text(errorMessage,
                              style: TextStyle(color: Colors.red)),
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
    showSpinnerDialog(context);
    try {

     bool isAuth = await provider.login(
          usernameController.text,
          passwordController.text,
          deviceName);
     if(isAuth) {
       Navigator.pushNamed(context, "/commands");
     }else {
       closeSpinnerDialog();
     }
    } catch (Exception) {
      setState(() {
        errorMessage = Exception.toString().replaceAll('Exception:', '');
      });
      closeSpinnerDialog();
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

  showSpinnerDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5),child:Text(" Chargement",style: TextStyle(color: Colors.blue))),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  closeSpinnerDialog(){Navigator.of(context).pop();}
}
