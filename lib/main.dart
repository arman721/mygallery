
import 'package:flutter/material.dart';
import 'package:mygallery/pages/homepage.dart';
import 'package:mygallery/pages/loginpage.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
    initialRoute: "/",
    
        routes: {
          "/":(context) =>  HomePage(),
          "/login":(context) => const LoginPage(),
          "/home":(context) => HomePage(),
          
          
          
        },
        );
        
        
  }
}
