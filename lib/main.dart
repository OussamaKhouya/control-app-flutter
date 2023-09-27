import 'package:flutter/material.dart';
import 'package:flutter_app/providers/commands_provider.dart';
import 'package:flutter_app/providers/compte_provider.dart';
import 'package:flutter_app/providers/ligne_commande_provider.dart';
import 'package:flutter_app/views/commands.dart';
import 'package:flutter_app/views/compte_view.dart';
import 'package:flutter_app/views/datails_cmd.dart';
import 'package:flutter_app/views/gallery.dart';
import 'package:flutter_app/views/login.dart';
import 'package:flutter_app/views/register.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/auth_provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AuthProvider(),
        child: Consumer<AuthProvider>(builder: (context, authProvider, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<CommandProvider>(
                create: (context) => CommandProvider(authProvider),
              ),
              ChangeNotifierProvider<LigneCProvider>(
                create: (context) => LigneCProvider(authProvider),
              ),
              ChangeNotifierProvider<CompteProvider>(
                create: (context) => CompteProvider(authProvider),
              )
            ],
            child: MaterialApp(
              title: 'Application Flutter de control de preparation des commandes',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                // fontFamily: 'Oswald'
              ),
              routes: {
                '/': (context) {
                  final authProvider = Provider.of<AuthProvider>(context);
                  if (authProvider.isAuthenticated) {
                    return Commands();
                  } else {
                    return Login();
                  }
                },
                '/login': (context) =>  const Login(),
                '/register': (context) => const Register(),
                '/account': (context) => const Account(),
                '/commands' : (context) => const Commands(),
                '/detailsCmd' : (context) {

                  return const DetailsCmd();
                },
                '/gallery' : (context) {

                  return Gallery();
                },
              },

            ),
          );
        }));
  }
}
