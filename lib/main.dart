import 'package:flutter/material.dart';
import 'package:flutter_app/providers/commands_provider.dart';
import 'package:flutter_app/views/commands.dart';
import 'package:flutter_app/views/compte_view.dart';
import 'package:flutter_app/views/datails_cmd.dart';
import 'package:flutter_app/views/gallery.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommandProvider>(
            create: (context) => CommandProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter App Image Picker',
        debugShowCheckedModeBanner: false,
        home: const Login(),
        routes: {
          '/login': (context) =>  const Login(),
          '/register': (context) => const Register(),
          '/account': (context) => const Account(),
          '/commands' : (context) => const Commands(),
          '/detailsCmd' : (context) {
            String numpiece = ModalRoute.of(context)?.settings.arguments as String;
            return DetailsCmd(numpiece: numpiece);
          },
          '/gallery' : (context) {
           String designation = ModalRoute.of(context)?.settings.arguments as String;
            return Gallery(designation: designation,);
          },
        },

      ),
    );
  }
}
