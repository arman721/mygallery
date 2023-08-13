import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mygallery/assets/widgets/favourite.dart';
import 'package:mygallery/assets/widgets/recent.dart';
import 'package:mygallery/pages/loginpage.dart';

import '../assets/widgets/gallery.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.email});
  final String? email;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  CollectionReference? imgRef;
  firebase_storage.Reference? ref;

  signout(context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    showMenu(color: Color.fromARGB(255, 51, 50, 50),
                      context: context,position: RelativeRect.fromLTRB(100, 0,0, 0),items: [
                      PopupMenuItem(child: Text("${widget.email}",style: TextStyle(color: Colors.white),),),
                      PopupMenuItem(onTap: () => signout(context),
                        child: Row(children: [Text("Sign Out",style: TextStyle(color: Colors.white),),Icon(color:Colors.white,
                          Icons.exit_to_app)]),),
                    ]);
                  },
                  icon: Icon(Icons.account_circle,color: Colors.white,size: 40,),
                ),
                // IconButton(
                //   onPressed: () => signout(context),
                //   icon: Icon(Icons.exit_to_app),
                //   color: Colors.white,
                // )
              ],
              title: Text(
                "WELCOME",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              backgroundColor: Color.fromARGB(202, 0, 0, 0),
              bottom: TabBar(
                  indicator: BoxDecoration(color: Color.fromARGB(61, 0, 0, 0)),
                  labelColor: Colors.white,
                  tabs: [
                    Tab(
                      text: "Recent Photos",
                    ),
                    Tab(
                      text: "Gallery",
                    ),
                    Tab(
                      text: "Favourite",
                    )
                  ]),
              foregroundColor: Colors.black,
            ),
            body: SafeArea(
              child: TabBarView(
                children: [
                  Recent(
                    email: widget.email,
                  ),
                  // for Gallery
                  Gallery(
                    email: widget.email,
                  ),
                  Favourite(
                    email: widget.email,
                  )
                ],
              ),
            )),
      ),
    );
  }

  showdetail() {
    PopupMenuButton(
        color: Colors.white,
        itemBuilder: (context) => [
              PopupMenuItem(child: Text("Name")),
              PopupMenuItem(child: Text("Email")),
              PopupMenuItem(child: Text("Signout")),
            ]);
  }
}
