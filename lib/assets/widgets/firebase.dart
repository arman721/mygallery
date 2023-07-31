import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class FireBaseImages extends StatefulWidget {
  const FireBaseImages({super.key});
  

  @override
  State<FireBaseImages> createState() => _FireBaseImagesState();
}

class _FireBaseImagesState extends State<FireBaseImages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('ImageURLs').snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(
                  child: CircularProgressIndicator(),
                )
              // : Text("hello");
              : Container(
                  child: GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return Container(
                          height: 500,
                          margin: EdgeInsets.all(3),
                          child: Column(
                            children: [
                              FadeInImage.memoryNetwork(
                                  fit: BoxFit.cover,
                                  height: 100,
                                  placeholder: kTransparentImage,
                                  image: snapshot.data!.docs[index].get('url')),
                              InkWell(
                                  onTap: () =>
                                      delete(snapshot.data!.docs[index].id),
                                  child: Container(
                                    height: 30,
                                    child: Text("delete"),
                                  ))
                            ],
                          ),
                        );
                      }),
                );
        },
      ),
    );
  }

  Future delete(id) async {
    try {
      await FirebaseFirestore.instance.collection('ImageURLs').doc(id).delete();
      setState(() {});
    } catch (e) {
      print("$e");
    }
  }
}
