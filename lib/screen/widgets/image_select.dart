import 'dart:ui';

import 'package:dpicenter/globals/globals.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:flutter/material.dart';

import 'app_bar.dart';

class ImageSelect extends StatefulWidget {
  const ImageSelect({
    Key? key,
  }) : super(key: key);

  @override
  ImageSelectState createState() => ImageSelectState();
}

class ImageSelectState extends State<ImageSelect> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              imagePreview(selectedIndex),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.black.withAlpha(80),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                prefs!.setString(
                                    'currentImage', selectedIndex.toString());
                                setState(() {
                                  if (selectedIndex - 1 < 0) {
                                    selectedIndex = assetsImages.length - 1;
                                  } else {
                                    selectedIndex--;
                                  }
                                  //currentBackground = selectedIndex;
                                });
                              },
                              child: const Icon(Icons.arrow_left)),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                prefs!.setString(
                                    'currentImage', selectedIndex.toString());
                                setState(() {
                                  if (selectedIndex + 1 < assetsImages.length) {
                                    selectedIndex++;
                                  } else {
                                    selectedIndex = 0;
                                  }
                                  //currentBackground = selectedIndex;
                                });
                              },
                              child: const Icon(Icons.arrow_right)),
                        )
                      ],
                    ),
                  ),
                  Center(
                      child: ElevatedButton(
                    child: const Text('Seleziona'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ))
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget imagePreview(int index) {
    return DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
              image:
                  Image.asset(assetsImages[index], fit: BoxFit.contain).image,
              fit: BoxFit.cover),
        ),
        child: ClipRRect(
            // make sure we apply clip it properly
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: scaffold(
                    title: const Text('Seleziona immagine'),
                    child: Center(
                        child: Image.asset(assetsImages[index],
                            fit: BoxFit.cover))))));
  }

  static Widget scaffold(
      {required Text title, required Widget child, double appBarHeight = 60}) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(appBarHeight),
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: appBarHeight,
                child: AppBar(
                    backgroundColor: isDarkTheme(navigatorKey!.currentContext!)
                        ? Color.alphaBlend(
                            Theme.of(navigatorKey!.currentContext!)
                                .colorScheme
                                .surface
                                .withAlpha(240),
                            Theme.of(navigatorKey!.currentContext!)
                                .colorScheme
                                .primary)
                        : null,
                    shape: const CustomAppBarShape(),
                    title: title)),
          ),
          body: child),
    );
  }
}
