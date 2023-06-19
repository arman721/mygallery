import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mygallery/assets/widgets/favourite.dart';
import 'dart:io';
import 'package:mygallery/assets/widgets/recent.dart';
import '../assets/widgets/gallery.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;

  List times = [];
  List images = [];
  List imageso = [];
  List imagesf = [];
  List imagesfs = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: showBottom,
              child: const Icon(Icons.add_a_photo),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            appBar: AppBar(
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
                  Recent(
                    images: images,
                    imag: _image,
                    times: times,
                    imagesf: imagesf,
                    imageso: imageso,
                    imagesfs: imagesfs,
                  ),
                  // for Gallery
                  Gallery(images: images, imag: _image,imagesfs: imagesfs,),
                  Favourite(
                      images: images,
                      imageso: imageso,
                      imagesf: imagesf,
                      times: times,
                      imagesfs: imagesfs,)
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
        imagesfs.insert(0,false);
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
        images.insert(0, _image!);
        times.insert(0, time);
        imageso.add(_image!);
        imagesfs.insert(0,false);
        Navigator.pop(context);
      });
    }
  }
}
