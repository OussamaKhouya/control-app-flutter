import 'package:flutter/material.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter_app/providers/cmd_provider.dart';
import 'package:flutter_app/providers/lcmd_provider.dart';
import 'package:flutter_app/views/camera_screen.dart';
import 'package:flutter_app/views/commands.dart';
import 'package:flutter_app/views/compte_view.dart';
import 'package:flutter_app/views/datails_cmd.dart';
import 'package:flutter_app/views/login.dart';
import 'package:flutter_app/views/register.dart';
import 'package:provider/provider.dart';



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
              ChangeNotifierProvider<CmdProvider>(
                create: (context) => CmdProvider(authProvider),
              ),
              ChangeNotifierProvider<LCmdProvider>(
                create: (context) => LCmdProvider(authProvider),
              )
            ],
            child: MaterialApp(
              title: 'Application Flutter de control de preparation des commandes',
              debugShowCheckedModeBanner: false,
              routes: {
                '/': (context) {
                  final authProvider = Provider.of<AuthProvider>(context);
                  if (authProvider.isAuthenticated) {
                    return const Commands();
                  } else {
                    return const Login();
                  }
                },
                '/login': (context) =>  const Login(),
                '/account': (context) => const Account(),
                '/commands' : (context) => const Commands(),
                '/detailsCmd' : (context) => const DetailsCmd(),
                '/camera': (context) => CameraScreen(),
              },

            ),
          );
        }));
  }
}
