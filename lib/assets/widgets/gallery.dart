import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_editor_dove/flutter_image_editor.dart';
import 'package:image_editor_dove/image_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class Gallery extends StatefulWidget {
  const Gallery({
    super.key,
    required this.images,
    required this.imageso,
    required this.imagesf,
    required this.imagesfs,
    required this.imag,
    required this.times,
  });

  final List images;
  final List imageso;
  final List imagesf;
  final List imagesfs;
  final File? imag;
  final List times;

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  static bool zoom = true;

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
                    .collection('ImageURLs')
                    .snapshots(),
                builder: (context, snapshot) {
                  return snapshot.data!.docs.length<1
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
                                      //  InkWell(
                                      //     onTap: () =>
                                      //         toImageEditor(),
                                      //     child: Icon(Icons.edit,
                                      //         color: Colors.white),
                                      //   ),
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
                                // Expanded(
                                //   flex: 1,
                                //   child:Container(color: Colors.white,
                                //   child: Row(children: [
                                //     IconButton(onPressed: delete(i), icon: Icon(Icons.delete)
                                //   )]),
                                //   ))
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

  delete(int index, id) {
    int d = widget.images.length - 1 - index;
    setState(() async {
      await FirebaseFirestore.instance.collection('ImageURLs').doc(id).delete();
      // widget.imagesf.remove(widget.imageso[d]);
      // widget.imageso.removeAt(widget.imageso.length - 1 - index);
      // widget.images.removeAt(index);
      // widget.imagesfs.removeAt(index);
    });
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

  Future<void> toImageEditor(File origin) async {
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ImageEditor(
        originImage: origin,
        //this is nullable, you can custom new file's save postion
      );
    })).then((result) {
      if (result is EditorImageResult) {
        setState(() {
          widget.images[i] = result.newFile;
        });
      }
    }).catchError((er) {
      debugPrint(er);
    });
  }
}
