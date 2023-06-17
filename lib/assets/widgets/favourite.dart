import 'dart:io';

import 'package:flutter/material.dart';
class Favourite extends StatelessWidget {
  const Favourite({super.key, required this.images, required this.imageso, required this.imagesf, this.imag, required this.times});
    final List images;
  final List imageso;
  final List imagesf;
  final File? imag;
  final List times;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Container(height: 700,
      child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: imagesf.length,
      itemBuilder: (BuildContext context, int index) {
        return Image.file(imagesf[index]) ;
      },
    ),));
  }
}