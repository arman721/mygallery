import 'dart:io';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.images.length == 0
            ? Container(
                child: Center(
                  child: Column(
                    children: [
                      Expanded(flex: 4, child: SizedBox()),
                      Expanded(
                        flex: 1,
                        child: Container(
                            height: 50,
                            width: 50,
                            child:
                                Image.asset("lib/assets/images/no_item.jpeg")),
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
                color: Color.fromARGB(255, 0, 0, 0),
              )
            : Stack(
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
                              itemCount: widget.images.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  height: 350,
                                  width: 300,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          widget.imagesfs[index]
                                              ? InkWell(
                                                  onTap: () =>
                                                      removefromfavourite(
                                                          index),
                                                  child: Icon(
                                                    Icons.favorite,
                                                    color: Colors.red,
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () =>
                                                      addtofavourite(index),
                                                  child: Icon(
                                                    Icons
                                                        .favorite_border_outlined,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(top: 5),
                                                  height: 20,
                                                  width: 250,
                                                  child: Text(
                                                      "${DateFormat.yMMMd().format(widget.times[index])}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15)),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  height: 20,
                                                  width: 250,
                                                  child: Text(
                                                      "${DateFormat.jms().format(widget.times[index])}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuButton(
                                              color: Colors.white,
                                              onSelected: (value) =>
                                                  selected(value, index),
                                              itemBuilder: (context) => [
                                                    PopupMenuItem(
                                                        value: 0,
                                                        child: Text("delete")),
                                                    PopupMenuItem(
                                                        value: 1,
                                                        child: Text(
                                                            "Add to Favourite")),
                                                    PopupMenuItem(
                                                        value: 2,
                                                        child: Text(
                                                            "Remove fromFavourite")),
                                                  ])
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showImageViewer(
                                              context,
                                              Image.file(
                                                widget.images[index],
                                              ).image,
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
                                            child: Image.file(
                                              widget.images[index],
                                              width: 400,
                                              fit: BoxFit.cover,
                                            ),
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
              ));
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

  selected(value, int index) {
    if (value == 0) {
      delete(index);
    } else if (value == 1) {
      addtofavourite(index);
    } else {
      removefromfavourite(index);
    }
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
}
