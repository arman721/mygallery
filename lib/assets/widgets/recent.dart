import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:image_editor_dove/flutter_image_editor.dart';
import 'package:image_editor_dove/image_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

class Recent extends StatefulWidget {
  final List images;
  final List imageso;
  final List imagesf;
  final List imagesfs;
  final File? imag;
  final List times;

  Recent({
    super.key,
    required this.images,
    required this.imag,
    required this.times,
    required this.imageso,
    required this.imagesf,
    required this.imagesfs,
  });

  @override
  State<Recent> createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: showBottom,
          child: const Icon(Icons.add_a_photo),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('ImageURLs').snapshots(),
            builder: (context, snapshot) {
              return snapshot.data!.docs.length>0
                  ? Stack(
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
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        height: 350,
                                        width: 300,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: Row(
                                                children: [
                                                  snapshot.data!.docs[index]
                                                          .get('fav')
                                                      ? InkWell(
                                                          onTap: () =>
                                                              removefromfavourite(
                                                                  index,snapshot.data!.docs[index].id
                                                                  ),
                                                          child: Icon(
                                                            Icons.favorite,
                                                            color: Colors.red,
                                                          ),
                                                        )
                                                      : InkWell(
                                                          onTap: () =>
                                                              addtofavourite(
                                                                  index,
                                                                  snapshot.data!.docs[index].id),
                                                          child: Icon(
                                                            Icons
                                                                .favorite_border_outlined,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
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
                                                  ),
                                                  PopupMenuButton(
                                                      color: Colors.white,
                                                      onSelected: (value) =>
                                                          selected(value, index,
                                                              snapshot),
                                                      itemBuilder: (context) =>
                                                          [
                                                            PopupMenuItem(
                                                                value: 2,
                                                                child: Text(
                                                                    "edit image")),
                                                            PopupMenuItem(
                                                                value: 1,
                                                                child: snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                        .get(
                                                                            'fav')
                                                                    ? Text(
                                                                        "Remove fromFavourite")
                                                                    : Text(
                                                                        "Add to Favourite")),
                                                            PopupMenuItem(
                                                                value: 0,
                                                                child: Text(
                                                                    "delete")),
                                                          ])
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                showImageViewer(
                                                    context,
                                                    Image.network(snapshot
                                                            .data!.docs[index]
                                                            .get('url'))
                                                        .image,
                                                    immersive: true,
                                                    swipeDismissible: true,
                                                    doubleTapZoomable: true);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 10, top: 10),
                                                height: 250,
                                                width: 370,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                  child:
                                                      FadeInImage.memoryNetwork(
                                                          fit: BoxFit.cover,
                                                          height: 100,
                                                          placeholder:
                                                              kTransparentImage,
                                                          image: snapshot
                                                              .data!.docs[index]
                                                              .get('url')),
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
                    )
                  : Container(color: Colors.black,
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
            }));
  }

  delete(int index, id) {
    // int d = widget.images.length - 1 - index;
    setState(() async {
      await FirebaseFirestore.instance.collection('ImageURLs').doc(id).delete();

      // widget.imagesf.remove(widget.imageso[d]);
      // widget.imageso.removeAt(widget.imageso.length - 1 - index);
      // widget.images.removeAt(index);

      // widget.imagesfs.removeAt(index);
    });setState(() {
      
    });
  }

  selected(value, int index, snapshot) {
    if (value == 0) {
      delete(index, snapshot.data!.docs[index].id);
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
          .collection('ImageURLs')
          .doc(id)
          .update({'fav': true});

      // int c = widget.imageso.length - 1 - index;
      // widget.imagesf.add(widget.imageso[c]);
      // widget.imagesfs[widget.imageso.length - c - 1] = true;
    });
  }

  removefromfavourite(int index, id) {
    setState(() async {
      await FirebaseFirestore.instance
          .collection('ImageURLs')
          .doc(id)
          .update({'fav': false});
      // int d = widget.imageso.length - 1 - index;

      // widget.imagesf.remove(widget.imageso[d]);
      // widget.imagesfs[widget.imageso.length - d - 1] = false;
    });
  }

  Future<void> getfreomgallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final time = DateTime.now();

      setState(() {
        _image = File(image.path);
        widget.images.insert(0, _image!);

        widget.times.insert(0, time);
        widget.imageso.add(_image!);
        widget.imagesfs.insert(0, false);
        Navigator.pop(context);
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

      setState(() {
        _image = File(image.path);
        widget.images.insert(0, _image!);
        widget.times.insert(0, time);
        widget.imageso.add(_image!);
        widget.imagesfs.insert(0, false);
        Navigator.pop(context);
      });
    }
  }

  Future<void> toImageEditor(index, snapshot) async {
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      File image = File(snapshot.data!.docs[index].get('url'));
      return ImageEditor(
        originImage:image,
        //this is nullable, you can custom new file's save postion
      );
    })).then((result) {
      if (result is EditorImageResult) {
        setState(() {
          widget.images[index] = result.newFile;
        });
      }
    }).catchError((er) {
      debugPrint(er);
    });
  }
}
