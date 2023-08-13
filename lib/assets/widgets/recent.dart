import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_editor_dove/flutter_image_editor.dart';
import 'package:image_editor_dove/image_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as Path;
import 'package:transparent_image/transparent_image.dart';

class Recent extends StatefulWidget {
  final String? email;

  Recent({
    super.key,
    required this.email,
  });

  @override
  State<Recent> createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  File? _image;
  CollectionReference? imgRef;
  firebase_storage.Reference? ref;
  bool indicator = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () => showBottom(),
          child: const Icon(Icons.add_a_photo),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('${widget.email}')
                .orderBy("time1", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return snapshot.data!.docs.length > 0
                    ? indicator
                        ? Container(
                            color: Color.fromARGB(225, 0, 0, 0),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Container(),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "Uploading",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      )),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Container(),
                                ),
                              ],
                            ),
                          )
                        : SafeArea(
                          child: Stack(
                              children: [
                                Container(
                                  color: Color.fromARGB(225, 0, 0, 0),
                                ),
                                Container(
                                  child: SingleChildScrollView(
                                    physics: const ScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 650,
                                          alignment: Alignment.center,
                                          child: ListView.separated(
                                            itemCount: snapshot.data!.docs.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Container(
                                                height: 350,
                                                width: 300,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8),
                                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        children: [
                                                          snapshot.data!
                                                                  .docs[index]
                                                                  .get('fav')
                                                              ? InkWell(
                                                                  onTap: () =>
                                                                      removefromfavourite(
                                                                          index,
                                                                          snapshot
                                                                              .data!
                                                                              .docs[index]
                                                                              .id),
                                                                  child: Icon(
                                                                    Icons
                                                                        .favorite,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                )
                                                              : InkWell(
                                                                  onTap: () =>
                                                                      addtofavourite(
                                                                          index,
                                                                          snapshot
                                                                              .data!
                                                                              .docs[index]
                                                                              .id),
                                                                  child: Icon(
                                                                    Icons
                                                                        .favorite_border_outlined,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                          Column(
                                                            children: [
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 5),
                                                                height: 20,
                                                                width: 292,
                                                                child: Text(
                                                                    "${snapshot.data!.docs[index].get('time1')}",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            15)),
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Container(
                                                                height: 20,
                                                                width: 292,
                                                                child: Text(
                                                                    "${snapshot.data!.docs[index].get('time2')}",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            13)),
                                                              ),
                                                            ],
                                                          ),
                                                          PopupMenuButton(
                                                              color: Colors.white,
                                                              onSelected: (value) =>
                                                                  selected(
                                                                      value,
                                                                      index,
                                                                      snapshot),
                                                              itemBuilder:
                                                                  (context) => [
                                                                        PopupMenuItem(
                                                                            value:
                                                                                2,
                                                                            child:
                                                                                Text("edit image")),
                                                                        PopupMenuItem(
                                                                            value:
                                                                                1,
                                                                            child: snapshot.data!.docs[index].get('fav')
                                                                                ? Text("Remove fromFavourite")
                                                                                : Text("Add to Favourite")),
                                                                        PopupMenuItem(
                                                                            value:
                                                                                0,
                                                                            child:
                                                                                Text("delete")),
                                                                      ])
                                                        ],
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        showImageViewer(
                                                            context,
                                                            Image.network(snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                    .get('url'))
                                                                .image,
                                                            immersive: true,
                                                            swipeDismissible:
                                                                true,
                                                            doubleTapZoomable:
                                                                true);
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.only(
                                                            bottom: 10, top: 10),
                                                        height: 250,
                                                        width: 370,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius.circular(
                                                                      10)),
                                                          child: FadeInImage
                                                              .memoryNetwork(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: 100,
                                                                  placeholder:
                                                                      kTransparentImage,
                                                                  image: snapshot
                                                                      .data!
                                                                      .docs[index]
                                                                      .get(
                                                                          'url')),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            separatorBuilder: (context, index) {
                                              return Divider(
                                                color: Colors.white,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        )
                    : indicator
                        ? Container(
                            color: Color.fromARGB(225, 0, 0, 0),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Container(),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "Uploading",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      )),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Container(),
                                ),
                              ],
                            ))
                        : Container(
                            color: Colors.black,
                            child: Center(
                              child: Column(
                                children: [
                                  Expanded(flex: 4, child: SizedBox()),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                        height: 50,
                                        width: 50,
                                        child: Image.asset(
                                            "lib/assets/images/no_item.jpeg")),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                          child: Text(
                                        "No Item Found",
                                        style: TextStyle(color: Colors.white),
                                      ))),
                                  Expanded(flex: 4, child: SizedBox()),
                                ],
                              ),
                            ),
                          );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }

  delete(id) {
    setState(() async {
      await FirebaseFirestore.instance
          .collection('${widget.email}')
          .doc(id)
          .delete();
    });
  }

  selected(value, int index, snapshot) {
    if (value == 0) {
      delete(snapshot.data!.docs[index].id);
    } else if (value == 2) {
      toImageEditor(index, snapshot);
    } else if (value == 1) {
      if (snapshot.data!.docs[index].get('fav')) {
        removefromfavourite(index, snapshot.data!.docs[index].id);
      } else {
        addtofavourite(index, snapshot.data!.docs[index].id);
      }
    }
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

  showBottom() {
    showModalBottomSheet(
        constraints: BoxConstraints(maxHeight: 150),
        backgroundColor: Colors.white,
        isDismissible: true,
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
                      onPressed: () {
                        indicator = true;
                        upload(_image, time).timeout(
                          Duration(seconds: 0),
                          onTimeout: () {
                            Navigator.pop(context);
                          },
                        );
                      },
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
                      onPressed: () {
                        upload(_image, time).timeout(
                          Duration.zero,
                          onTimeout: () {
                            setState(() {
                              indicator = true;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                      child: Text("upload")),
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
    setState(() {
      indicator ? print("Uploading") : print("Uploaded");
    });

    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("images/${Path.basename(img.path)}");
    await ref!.putFile(img).whenComplete(() async {
      setState(() {
        indicator = false;
      });
      await ref!.getDownloadURL().then((value) {
        setState(() {
          indicator = false;
        });
        imgRef!.add({
          'url': value,
          'time1': DateFormat.yMMMd().format(time).toString(),
          'time2': DateFormat.jms().format(time).toString(),
          'fav': false
        });
      });
    });
    setState(() {
      indicator ? print("Uploading") : print("Uploaded");
    });
  }
  @override
  void initState() {
    super.initState();
    imgRef = FirebaseFirestore.instance.collection('${widget.email}');
  }
}
