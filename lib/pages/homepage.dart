import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mygallery/assets/widgets/favourite.dart';
import 'dart:io';

import 'package:mygallery/assets/widgets/recent.dart';

import '../assets/widgets/gallery.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;

  List times = [];
  List images = [];
  List imageso = [];
  List imagesf = [];
  List imagesfs = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
            
            appBar: AppBar(
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
                    images: images,
                    imag: _image,
                    times: times,
                    imagesf: imagesf,
                    imageso: imageso,
                    imagesfs: imagesfs,
                  ),
                  // for Gallery
                  Gallery(images: images, imag: _image,imagesfs: imagesfs,),
                  Favourite(
                      images: images,
                      imageso: imageso,
                      imagesf: imagesf,
                      times: times,
                      imagesfs: imagesfs,)
                ],
              ),
            )),
      ),
    );
  }

  
}
