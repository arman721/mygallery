import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mygallery/assets/widgets/recent.dart';
import 'package:mygallery/pages/homepage.dart';
import 'package:path/path.dart';


class LoginAuth extends StatefulWidget {
  LoginAuth({super.key});

  @override
  State<LoginAuth> createState() => _LoginAuthState();
}

class _LoginAuthState extends State<LoginAuth> {
  TextEditingController emailcontroller = TextEditingController();

  TextEditingController passwordcontroller = TextEditingController();



  @override
  login(context) async {
    String email = emailcontroller.text.trim();
    String password = passwordcontroller.text.trim();

    if (email == "" || password == "") {
      ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Fill all Field")));
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (userCredential != null) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                  builder: (context) => HomePage(
                        email:FirebaseAuth.instance.currentUser!.email,
                      )));
        }
      } on FirebaseAuthException catch (ex) {
        return ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${ex.code}")));
      }
    }
  }

  Widget build(BuildContext context) {
    return Container(
      child: Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: emailcontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 3)),
                  hintText: "Enter Email",
                  label: const Text("Email"),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "UserName cannot be empty";
                  } else {
                    return null;
                  }
                },
              ),
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Password cann't be empty";
                  } else if (value.length < 6) {
                    return "Length of password must be greater than 6";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: () {
                  login(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20)),
                  height: 50,
                  width: 350,
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              const Text(
                "-----------------------OR----------------------",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
