import 'package:flutter/material.dart';
import 'package:mygallery/assets/widgets/loginauth.dart';
import 'package:mygallery/assets/widgets/registerauth.dart';
import 'package:mygallery/routes.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static bool lo = true;

  void login() {
    setState(() {
      lo = true;
    });
  }

  void register() {
    setState(() {
      lo = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child:Stack(children: [
            Container(color: Colors.black,),
            Container(margin: const EdgeInsets.all(20),
             child:  Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    const SizedBox(height: 100,),
                    Container(decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(20)),height: 40,width: 170,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(clipBehavior: Clip.hardEdge,
                              style: const ButtonStyle(
                                  
                                  foregroundColor:
                                      MaterialStatePropertyAll(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStatePropertyAll(
                                          Colors.black)),
                              onPressed: login,
                              child: const Text("login")),
                              SizedBox(width: 1,child: Container(color: Colors.white,),),
                          ElevatedButton(
                              style: const ButtonStyle(
                                  
                                  foregroundColor:
                                      MaterialStatePropertyAll(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStatePropertyAll(
                                          Colors.black)),
                              onPressed: register,
                              child: const Text("register")),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    lo
                        ?LoginAuth()
                        :RegisterAuth()
                  ],
                ),
              )),
             
             )
          
          ],)
        ),
      ),
    );
  }
}
