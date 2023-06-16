import 'package:flutter/material.dart';
import 'package:mygallery/routes.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
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

  registerdone(BuildContext context) {
    if (_formKey2.currentState!.validate()) {
      Navigator.pushNamed(context, Myroutes.homeroute);
    }
  }

  tohomepage(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(context, Myroutes.homeroute);
    }
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
                        ? Container(
                            child: Form(
                              key: _formKey,
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius
                                                    .circular(25),
                                            borderSide:
                                                const BorderSide(
                                                    color: Colors
                                                        .black,
                                                    width: 3)),
                                        hintText:
                                            "Enter UserName",
                                        label: const Text(
                                            "User Name"),
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
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        border:
                                            OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                            25),
                                                borderSide:
                                                    const BorderSide(
                                                  color: Colors
                                                      .black,
                                                  width: 5,
                                                ),
                                                gapPadding: 8),
                                        hintText:
                                            "Enter Password",
                                        label: const Text(
                                            "Password"),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Password cann't be empty";
                                        } else if (value.length <
                                            6) {
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
                                      onTap: () =>
                                          tohomepage(context),
                                      child: Container(
                                        alignment:
                                            Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius
                                                    .circular(
                                                        20)),
                                        height: 50,
                                        width: 350,
                                        child: const Text(
                                          "Login",
                                          style: TextStyle(
                                              color:
                                                  Colors.white),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 80,
                                    ),
                                    const Text(
                                      "-----------------------OR----------------------",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(
                            child: SingleChildScrollView(
                              child: Column(children: [
                                Form(
                                    key: _formKey2,
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.all(
                                                8.0),
                                        child: Column(children: [
                                          TextFormField(
                                            decoration:
                                                InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                              25),
                                                  borderSide: const BorderSide(
                                                      color: Colors
                                                          .black,
                                                      width: 3)),
                                              hintText:
                                                  " Enter name",
                                              label: const Text(
                                                  "Full Name"),
                                            ),
                                            validator: (value) {
                                              if (value!
                                                  .isEmpty) {
                                                return "Name cannot be empty";
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                            keyboardType:
                                                TextInputType
                                                    .emailAddress,
                                            decoration: InputDecoration(
                                                hintText:
                                                    "enter your Email",
                                                label: const Text(
                                                    "Email"),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                                20))),
                                            validator: (value) {
                                              if (value!
                                                  .isEmpty) {
                                                return "Email cann't be empty";
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                            keyboardType:
                                                TextInputType
                                                    .number,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                                20)),
                                                hintText:
                                                    "Enter Mobile Number",
                                                label: const Text(
                                                    "Mobile Number")),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Mobile Number cann't be empty";
                                              }
                                            },
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                            obscureText: true,
                                            decoration:
                                                InputDecoration(
                                              border:
                                                  OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                      borderSide:
                                                          const BorderSide(
                                                        color: Colors
                                                            .black,
                                                        width: 5,
                                                      ),
                                                      gapPadding:
                                                          8),
                                              hintText:
                                                  "Enter Password",
                                              label: const Text(
                                                  "Password"),
                                            ),
                                            validator: (value) {
                                              if (value!
                                                  .isEmpty) {
                                                return "Password cann't be empty";
                                              } else if (value
                                                      .length <
                                                  6) {
                                                return "Length of password must be greater than 6";
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ]))),
                                InkWell(
                                  onTap: () =>
                                      registerdone(context),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    width: 350,
                                    child: const Text(
                                      "Register",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20),
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(
                                                20)),
                                  ),
                                ),
                              ]),
                            ),
                          ),
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
