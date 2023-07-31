import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class Favourite extends StatefulWidget {
  const Favourite(
      {super.key,
      });
 

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  static bool zoom = true;
  static int c = 0;
  List imagesfav = [];

  var i;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('ImageURLs').snapshots(),
            builder: (context, snapshot) {
              for (i = 0; i < snapshot.data!.docs.length; i++) {
                if (snapshot.data!.docs[i].get('fav') == true) {
                  imagesfav.insert(0, snapshot.data!.docs[i].get('url'));
                }
              }
              return imagesfav.isEmpty
                  ? Container(
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
                                  child: Icon(
                                Icons.favorite_border_outlined,
                                color: Colors.white,
                                size: 50,
                              )),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                "No Favorite Selected",
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
                    )
                  : zoom
                      ? Container(
                          padding: const EdgeInsets.all(20),
                          color: const Color.fromARGB(218, 0, 0, 0),
                          height: 800,
                          child: MasonryGridView.builder(
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              itemCount: imagesfav.length,
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
                                          onTapUp: (context, details,
                                                  controllerValue) =>
                                              photoviewer(index),
                                          imageProvider:
                                              NetworkImage(imagesfav[index]),
                                        ))
                                  ],
                                );
                              }),
                        )
                      : Container(
                          color: Colors.black,
                          child: Stack(children: [
                            PhotoViewGallery.builder(
                              pageController: PageController(initialPage: c),
                              itemCount: imagesfav.length,
                              builder: ((context, index) {
                                return PhotoViewGalleryPageOptions(
                                    imageProvider:
                                        NetworkImage(imagesfav[index]));
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
                        );
            }));
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
