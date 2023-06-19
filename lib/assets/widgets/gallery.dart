import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class Gallery extends StatefulWidget {
  const Gallery({
    super.key,
    required this.images,
    required this.imag,
    required this.imagesfs,
  });

  final List images;
  final List imagesfs;
  final File? imag;

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  static bool zoom = true;
  static int c = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: widget.images.length == 0
              ? Scaffold(
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
                  ? Container(
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
                            return Column(
                              children: [
                                Container(
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
                                ),
                              ],
                            );
                          }),
                    )
                  : Container(
                      color: Colors.black,
                      child: Stack(children: [
                        PhotoViewGallery.builder(
                          pageController: PageController(initialPage: c),
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
                      ]),
                    )),
    );
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
}
