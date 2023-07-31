import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mygallery/assets/widgets/favourite.dart';
import 'package:mygallery/assets/widgets/firebase.dart';
import 'package:mygallery/assets/widgets/recent.dart';
import 'package:path/path.dart' as Path;

import '../assets/widgets/gallery.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  CollectionReference? imgRef;
  firebase_storage.Reference? ref;

  List times = [];
  List images = [];
  List imageso = [];
  List imagesf = [];
  List imagesfs = [];
  List imagesfire = [];
  String url = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () => upload(images), icon: Icon(Icons.upload))
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
                      text: "fierbase",
                    ),
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
                  FireBaseImages(
                    imagesfire: imagesfire,
                  ),
                  Recent(
                    images: images,
                    imag: _image,
                    times: times,
                    imagesf: imagesf,
                    imageso: imageso,
                    imagesfs: imagesfs,
                  ),
                  // for Gallery
                  Gallery(
                    images: images,
                    imag: _image,
                    imagesfs: imagesfs,
                    imagesf: imagesf,
                    imageso: imageso,
                    times: times,
                  ),
                  Favourite(
                    images: images,
                    imageso: imageso,
                    imagesf: imagesf,
                    times: times,
                    imagesfs: imagesfs,
                  )
                ],
              ),
            )),
      ),
    );
  }

  Future<void> getfreomgallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final time = DateTime.now();
      setState(() {
        _image = File(image.path);
        images.insert(0, _image!);
        times.insert(0, time);
        imageso.add(_image!);
        imagesfs.insert(0, false);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [Text("Do you want to upload the picture")],
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () => upload(images), child: Text("Upload"))
                ],
              );
            });
      });
    }
  }

  showBottom() {
    showModalBottomSheet(
        constraints: BoxConstraints(maxHeight: 150),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return Center(
            child: Wrap(
              direction: Axis.horizontal,
              children: [
                InkWell(
                  onTap: getfreomcamera,
                  child: Container(
                    height: 100,
                    width: 70,
                    child: Column(
                      children: [
                        Container(
                            height: 50,
                            width: 50,
                            child: CircleAvatar(child: Icon(Icons.camera))),
                        Text("Camera")
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: getfreomgallery,
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                            height: 50,
                            width: 50,
                            child:
                                Image.asset("lib/assets/images/gallery.jpg")),
                        Text("Gallery"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> getfreomcamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      final time = DateTime.now();
      AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: [Text("Do you want to upload the picture")],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => upload(images), child: Text("Upload"))
              ],
            );
          

      setState(() async {
        _image = File(image.path);
        images.insert(0, _image!);
        times.insert(0, time);
        imageso.add(_image!);
        imagesfs.insert(0, false);
      });
    }
  }

  Future upload(List imagess) async {
    for (var img in imagess) {
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child("images/${Path.basename(img.path)}");
      await ref!.putFile(img).whenComplete(() async {
        await ref!.getDownloadURL().then((value) {
          imgRef!.add({
            'url': value,
            'time1': DateFormat.yMMMd().format(times[0]).toString(),
            'time2': DateFormat.jms().format(times[0]).toString(),
            'fav': false
          });
        });
      });
    }
    images.clear();
  }

  @override
  void initState() {
    super.initState();
    imgRef = FirebaseFirestore.instance.collection('ImageURLs');
  }
}
