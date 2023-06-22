import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:image_editor_dove/extension/num_extension.dart';
import 'package:image_editor_dove/flutter_image_editor.dart';
import 'package:image_editor_dove/image_editor.dart';
import 'package:image_editor_dove/model/float_text_model.dart';
import 'package:image_editor_dove/widget/drawing_board.dart';
import 'package:image_editor_dove/widget/editor_panel_controller.dart';
import 'package:image_editor_dove/widget/float_text_widget.dart';
import 'package:image_editor_dove/widget/image_editor_delegate.dart';
import 'package:image_editor_dove/widget/slider_widget.dart';
import 'package:image_editor_dove/widget/text_editor_page.dart';

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
            body: widget.images.length == 0
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
                              itemCount: widget.images.length,
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
                                    onTapUp:
                                        (context, details, controllerValue) =>
                                            photoviewer(index),
                                    imageProvider:
                                        FileImage(widget.images[index]),
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
                                    i = index;
                                  },
                                  pageController:
                                      PageController(initialPage: c),
                                  itemCount: widget.images.length,
                                  builder: ((context, index) {
                                    return PhotoViewGalleryPageOptions(
                                      imageProvider: FileImage(
                                        widget.images[index],
                                      ),
                                    );
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
                              ])),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () => toImageEditor(widget.images[i]),
                                  child: Icon(Icons.edit, color: Colors.white),
                                ),
                                
                                widget.imagesfs[i]
                                    ? InkWell(
                                        onTap: () => removefromfavourite(i),
                                        child: Icon(Icons.favorite,
                                            color: Colors.red),
                                      )
                                    : InkWell(
                                        onTap: () => addtofavourite(i),
                                        child: Icon(
                                          Icons.favorite_border_outlined,
                                          color: Colors.white,
                                        ),
                                      ),
                                      InkWell(
                                    onTap: () => delete(i),
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
                      )));
  }

  photoviewer(int index) {
    setState(() {
      zoom = false;
      c = index;
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

  delete(int index) {
    int d = widget.images.length - 1 - index;
    setState(() {
      widget.imagesf.remove(widget.imageso[d]);
      widget.imageso.removeAt(widget.imageso.length - 1 - index);
      widget.images.removeAt(index);
      widget.imagesfs.removeAt(index);
    });
  }

  addtofavourite(int index) {
    setState(() {
      int c = widget.imageso.length - 1 - index;
      widget.imagesf.add(widget.imageso[c]);
      widget.imagesfs[widget.imageso.length - c - 1] = true;
    });
  }

  removefromfavourite(int index) {
    setState(() {
      print("object");
      int d = widget.imageso.length - 1 - index;

      widget.imagesf.remove(widget.imageso[d]);
      widget.imagesfs[widget.imageso.length - d - 1] = false;
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
