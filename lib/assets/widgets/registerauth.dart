import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:mygallery/pages/homepage.dart';

class RegisterAuth extends StatelessWidget {
  RegisterAuth({super.key});
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController cpasswordcontroller = TextEditingController();
  String nameo = "ajb";

  createaccount(context) async {
    String name = namecontroller.text.trim();
    String email = emailcontroller.text.trim();
    String password = passwordcontroller.text.trim();
    String cpassword = cpasswordcontroller.text.trim();

    if (email == "" || password == "") {
      ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("fill all field")));
    } else if (password != cpassword) {
      ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Password not matching")));
    } else {
      try {
        nameo = email;
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        print("User created");
        if (userCredential != null) {
          print("${userCredential.user!.email}");
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                  builder: (context) => HomePage(
                        email: FirebaseAuth.instance.currentUser!.email,
                      )));
        }
      } on FirebaseAuthException catch (ex) {
        return ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${ex.code}")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                TextFormField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 3)),
                    hintText: " Enter name",
                    label: const Text("Full Name"),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: emailcontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: "enter your Email",
                      label: const Text("Email"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                const SizedBox(
                  height: 10,
                ),
                // TextFormField(
                //   keyboardType: TextInputType.number,
                //   decoration: InputDecoration(
                //       border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(20)),
                //       hintText: "Enter Mobile Number",
                //       label: const Text("Mobile Number")),

                // ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: passwordcontroller,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 5,
                        ),
                        gapPadding: 8),
                    hintText: "Enter Password",
                    label: const Text("Password"),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: cpasswordcontroller,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 5,
                        ),
                        gapPadding: 8),
                    hintText: "Enter Password",
                    label: const Text("Confirm Password"),
                  ),
                ),
              ])),
          InkWell(
            onTap: () => createaccount(context),
            child: Container(
              alignment: Alignment.center,
              height: 50,
              width: 350,
              child: const Text(
                "Register",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ]),
      ),
    );
  }
}
