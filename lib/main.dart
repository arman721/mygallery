
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mygallery/pages/homepage.dart';
import 'package:mygallery/pages/loginpage.dart';
import 'package:firebase_core/firebase_core.dart';



Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp()
    
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
    home:( FirebaseAuth.instance.currentUser!=null)?HomePage(email: FirebaseAuth.instance.currentUser!.email):LoginPage()
   
        );
        
        
  }
}
