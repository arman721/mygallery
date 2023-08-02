import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_editor_dove/flutter_image_editor.dart';
import 'package:image_editor_dove/image_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as Path;
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class Gallery extends StatefulWidget {
  const Gallery({
    super.key, required this.email,
  });
  final String? email;

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  static bool zoom = true;
  CollectionReference? imgRef;
  firebase_storage.Reference? ref;

  File? _image;
  int i = 0;
  int c = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('${widget.email}')
                    .snapshots(),
                builder: (context, snapshot) {
                  return snapshot.data!.docs.length == 0
                      ? Scaffold(
                          floatingActionButtonLocation:
                              FloatingActionButtonLocation.endDocked,
                          floatingActionButton: FloatingActionButton(
                            onPressed: showBottom,
                            child: const Icon(Icons.add_a_photo),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          body: Container(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            child: Center(
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      child: SizedBox(),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: CircleAvatar(
                                        child: Icon(
                                          Icons.camera_alt,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "No Photos",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 4,
                                      child: Container(
                                        child: SizedBox(),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        )
                      : zoom
                          ? Scaffold(
                              floatingActionButtonLocation:
                                  FloatingActionButtonLocation.endDocked,
                              floatingActionButton: FloatingActionButton(
                                onPressed: showBottom,
                                child: const Icon(Icons.add_a_photo),
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                              ),
                              body: Container(
                                padding: const EdgeInsets.all(20),
                                color: const Color.fromARGB(218, 0, 0, 0),
                                height: 800,
                                child: MasonryGridView.builder(
                                    mainAxisSpacing: 5,
                                    crossAxisSpacing: 5,
                                    itemCount: snapshot.data!.docs.length,
                                    gridDelegate:
                                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                    ),
                                    itemBuilder: (BuildContext context, index) {
                                      return Container(
                                        height: 200,
                                        width: 200,
                                        child: PhotoView(
                                          enableRotation: true,
                                          onTapUp: (context, details,
                                                  controllerValue) =>
                                              photoviewer(index),
                                          imageProvider: NetworkImage(snapshot
                                              .data!.docs[index]
                                              .get('url')),
                                        ),
                                      );
                                    }),
                              ),
                            )
                          : Container(
                              color: Colors.black,
                              child: Column(children: [
                                Expanded(
                                    flex: 9,
                                    child: Stack(children: [
                                      PhotoViewGallery.builder(
                                        onPageChanged: (index) {
                                          setState(() {
                                            i = index;
                                          });
                                        },
                                        pageController:
                                            PageController(initialPage: c),
                                        itemCount: snapshot.data!.docs.length,
                                        builder: ((context, index) {
                                          return PhotoViewGalleryPageOptions(
                                              imageProvider: NetworkImage(
                                                  snapshot.data!.docs[index]
                                                      .get('url')));
                                        }),
                                      ),
                                      Positioned(
                                        top: 20,
                                        left: 20,
                                        child: IconButton(
                                            onPressed: () => galleryviewer(),
                                            icon: const Icon(
                                              Icons.arrow_back,
                                              color: Colors.white,
                                            )),
                                      ),
                                      Positioned(
                                          bottom: 0,
                                          child: Text(
                                            "${i + 1}" +
                                                "/" +
                                                "${snapshot.data!.docs.length}}",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))
                                    ])),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      snapshot.data!.docs[i].get('fav')
                                          ? InkWell(
                                              onTap: () => removefromfavourite(
                                                  i, snapshot.data!.docs[i].id),
                                              child: Icon(Icons.favorite,
                                                  color: Colors.red),
                                            )
                                          : InkWell(
                                              onTap: () => addtofavourite(
                                                  i, snapshot.data!.docs[i].id),
                                              child: Icon(
                                                Icons.favorite_border_outlined,
                                                color: Colors.white,
                                              ),
                                            ),
                                      InkWell(
                                          onTap: () => delete(
                                              i, snapshot.data!.docs[i].id),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          )),
                                    ],
                                  ),
                                )
                              ]),
                            );
                })));
  }

  photoviewer(int index) {
    setState(() {
      zoom = false;
      c = index;
      i = index;
    });
  }

  galleryviewer() {
    setState(() {
      zoom = true;
    });
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

  delete(int index, id) {
    setState(() async {
      await FirebaseFirestore.instance.collection('${widget.email}').doc(id).delete();
    });
  }

  addtofavourite(int index, id) {
    setState(() async {
      await FirebaseFirestore.instance
          .collection('${widget.email}')
          .doc(id)
          .update({'fav': true});
    });
  }

  removefromfavourite(int index, id) {
    setState(() async {
      await FirebaseFirestore.instance
          .collection('${widget.email}')
          .doc(id)
          .update({'fav': false});
    });
  }

  Future<void> getfreomgallery() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.gallery)
        .then((value) {
      if (value != null) {
        final time = DateTime.now();
        _image = File(value.path);
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
                      onPressed: () => upload(_image, time).then((value) {
                            Navigator.pop(context);
                          }),
                      child: Text("Upload")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"))
                ],
              );
            }).then((value) {
          Navigator.pop(context);
        });
      }
    });
  }

  Future<void> getfreomcamera() async {
    final image =
        await ImagePicker().pickImage(source: ImageSource.camera).then((value) {
      if (value != null) {
        final time = DateTime.now();
        _image = File(value.path);
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
                      onPressed: () => upload(_image, time).then((value) {
                            Navigator.pop(context);
                          }),
                      child: Text("Upload")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"))
                ],
              );
            }).then((value) {
          Navigator.pop(context);
        });
      }
    });
  }

  Future<void> toImageEditor(index, snapshot) async {
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      File image = File(snapshot.data!.docs[index].get('url'));
      return ImageEditor(
        originImage: image,
      );
    })).then((result) {
      if (result is EditorImageResult) {
        setState(() {});
      }
    }).catchError((er) {
      debugPrint(er);
    });
  }

  Future upload(img, time) async {
    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("images/${Path.basename(img.path)}");
    await ref!.putFile(img).whenComplete(() async {
      await ref!.getDownloadURL().then((value) {
        imgRef!.add({
          'url': value,
          'time1': DateFormat.yMMMd().format(time).toString(),
          'time2': DateFormat.jms().format(time).toString(),
          'fav': false
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    imgRef = FirebaseFirestore.instance.collection('${widget.email}');
  }
}
