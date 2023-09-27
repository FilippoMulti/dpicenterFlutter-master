// A widget that displays the picture taken by the user.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Image? image;
    if (kIsWeb) {
      image = Image.network(imagePath);
    } else {
      image = Image.file(File(imagePath));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Anteprima')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Stack(
        children: [
          Center(child: image),
          AnimatedPositioned(
              left: 100,
              right: 100,
              bottom: 20,
              duration: const Duration(milliseconds: 500),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.maybePop(context, imagePath);
                  },
                  child: const Text("Seleziona")))
        ],
      ),
    );
  }
}
