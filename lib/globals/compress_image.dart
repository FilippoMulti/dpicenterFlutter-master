import 'dart:async' show Future;
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'
    show compute, debugPrint, kDebugMode, kIsWeb;
import 'package:image/image.dart';
import 'package:image/image.dart' as im;
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;
import 'package:universal_io/io.dart' show File;

/*Future<File> takeCompressedPicture(BuildContext context) async {
  var _imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
  if (_imageFile == null) {
    return null;
  }

  // You can have a loading dialog here but don't forget to pop before return file;

  final tempDir = await getTemporaryDirectory();
  final rand = math.Random().nextInt(10000);
  _CompressObject compressObject =
  _CompressObject(_imageFile, tempDir.path, rand);
  String filePath = await _compressImage(compressObject);
  print('new path: ' + filePath);
  File file = File(filePath);

  // Pop loading

  return file;
}*/

Future<File> compressPicture(File imageFile) async {
/*
  var _imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
  if (_imageFile == null) {
    return null;
  }
*/

  // You can have a loading dialog here but don't forget to pop before return file;

  final tempDir = await getTemporaryDirectory();
  final rand = math.Random().nextInt(10000);
  _CompressObject compressObject = _CompressObject(
      path: tempDir.path,
      rand: rand,
      size: 500,
      quality: 85,
      imageFile: imageFile);
  String filePath = await _compressImage(compressObject);
  if (kDebugMode) {
    print('new path: $filePath');
  }
  File file = File(filePath);

  // Pop loading

  return file;
}

Future<Uint8List> compressPictureUint8List(File imageFile,
    [int size = 500, int quality = 85]) async {
  final tempDir = await getTemporaryDirectory();
  final rand = math.Random().nextInt(10000);
  _CompressObject compressObject = _CompressObject(
      imageFile: imageFile,
      path: tempDir.path,
      rand: rand,
      size: size,
      quality: quality);
  return await _compressImageUInt8List(compressObject);
}

Future<Uint8List> compressPicture2(File imageFile,
    [int size = 500, int quality = 90]) async {
  final tempDir = await getTemporaryDirectory();
  final rand = math.Random().nextInt(10000);
  _CompressObject compressObject = _CompressObject(
      imageFile: imageFile,
      path: tempDir.path,
      rand: rand,
      size: size,
      quality: quality);
  return await compute(decode, compressObject);
}

Future<Uint8List> compressPicture4(FilePickerResult imageFile,
    [int size = 500, int quality = 90]) async {
  final tempDir = await getTemporaryDirectory();
  final rand = math.Random().nextInt(10000);
  _CompressObject compressObject = _CompressObject(
      imageFilePicker: imageFile,
      path: tempDir.path,
      rand: rand,
      size: size,
      quality: quality);
  return await compute(decode4, compressObject);
}

Future<Uint8List?> compressPicture3(Uint8List bytes,
    [int size = 500, int quality = 90]) async {
  //final rand = math.Random().nextInt(10000);
  _CompressObject compressObject =
      _CompressObject(bytes: bytes, size: size, quality: quality);
  if (kIsWeb) {
    return await decode3(compressObject);
  }
  return null;
}

Uint8List decode(_CompressObject param) {
  // Read an image from file
  // decodeImage will identify the format of the image and use the appropriate
  // decoder.
  var imageBytes = param.imageFile!.readAsBytesSync();
  Image? image = decodeImage(imageBytes);
  // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).

  if (kDebugMode) {
    print(
        "original dimension: w.${image!.width.toString()} h.${image.height.toString()}\r\nOriginal size: ${imageBytes.length.toString()}");
  }
  if (image!.width < param.size!) {
    return imageBytes;
    //param.size=image.width;
  }

  Image thumbnail = copyResize(
    image,
    width: param.size,
  ); //gaussianBlur(copyResize(image!, width: param.size), 5);
  // List<int> quality = <int>[85,70,60,50,40,30,20,10,0];
  // for (var q in quality) {   list.add(encodeJpg(thumbnail, quality: q));}
  //
  // for (int index = 0; index<quality.length; index++){
  //   var encoded = list[index];
  //   print("thumbnail jpg dimension: w.${thumbnail.width.toString()} h.${thumbnail.height.toString()} Quality: ${quality[index]}\r\nsize: ${encoded.length.toString()}");
  // }

  var encoded = encodeJpg(thumbnail, quality: param.quality!);
  if (kDebugMode) {
    print(
        "thumbnail png dimension: w.${thumbnail.width.toString()} h.${thumbnail.height.toString()} Png\r\nsize: ${encoded.length.toString()}");
  }

  return Uint8List.fromList(encoded); //thumbnail.getBytes();
}

Uint8List decode4(_CompressObject param) {
  // Read an image from file
  // decodeImage will identify the format of the image and use the appropriate
  // decoder.
  var imageBytes = param.imageFilePicker!.files.first.bytes;

  Image? image = decodeImage(imageBytes!);
  // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).

  if (kDebugMode) {
    print(
        "original dimension: w.${image!.width.toString()} h.${image.height.toString()}\r\nOriginal size: ${imageBytes.length.toString()}");
  }
  if (image!.width < param.size!) {
    return imageBytes;
    //param.size=image.width;
  }

  Image thumbnail = copyResize(
    image,
    width: param.size,
  ); //gaussianBlur(copyResize(image!, width: param.size), 5);
  // List<int> quality = <int>[85,70,60,50,40,30,20,10,0];
  // for (var q in quality) {   list.add(encodeJpg(thumbnail, quality: q));}
  //
  // for (int index = 0; index<quality.length; index++){
  //   var encoded = list[index];
  //   print("thumbnail jpg dimension: w.${thumbnail.width.toString()} h.${thumbnail.height.toString()} Quality: ${quality[index]}\r\nsize: ${encoded.length.toString()}");
  // }

  var encoded = encodeJpg(thumbnail, quality: param.quality!);
  if (kDebugMode) {
    print(
        "thumbnail png dimension: w.${thumbnail.width.toString()} h.${thumbnail.height.toString()} Png\r\nsize: ${encoded.length.toString()}");
  }

  return Uint8List.fromList(encoded); //thumbnail.getBytes();
}

Future<Uint8List?> decode3(_CompressObject param) async {
  // Read an image from file
  // decodeImage will identify the format of the image and use the appropriate
  // decoder.
  debugPrint("Sono in decode3");
  var imageBytes = param.bytes;

  Image? image; // = decodeImage(imageBytes!);
  await Future.microtask(() => image = decodeImage(imageBytes!));
  // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).

  if (kDebugMode) {
    print(
        "original dimension: w.${image!.width.toString()} h.${image!.height.toString()}\r\nOriginal size: ${imageBytes!.length.toString()}");
  }
  if (image!.width < param.size!) {
    return imageBytes;
    //param.size=image.width;
  }
  Image? thumbnail;

  await Future.microtask(
      () => thumbnail = copyResize(image!, width: param.size));

  // List<int> quality = <int>[85,70,60,50,40,30,20,10,0];
  // for (var q in quality) {   list.add(encodeJpg(thumbnail, quality: q));}
  //
  // for (int index = 0; index<quality.length; index++){
  //   var encoded = list[index];
  //   print("thumbnail jpg dimension: w.${thumbnail.width.toString()} h.${thumbnail.height.toString()} Quality: ${quality[index]}\r\nsize: ${encoded.length.toString()}");
  // }
  await Future.microtask(
      () => thumbnail = copyResize(image!, width: param.size));
  List<int> encoded = <int>[];

  await Future.microtask(
      () => encoded = encodeJpg(thumbnail!, quality: param.quality!));

  if (kDebugMode) {
    print(
        "thumbnail png dimension: w.${thumbnail!.width.toString()} h.${thumbnail!.height.toString()} Png\r\nsize: ${encoded.length.toString()}");
  }
  print("Ho finito decode3");

  return Uint8List.fromList(encoded); //thumbnail.getBytes();
}

Future<String> _compressImage(_CompressObject object) async {
  return compute(_decodeImage, object);
}

Future<Uint8List> _compressImageUInt8List(_CompressObject object) async {
  return await compute(_decodeImageUint8List, object);
}

String _decodeImage(_CompressObject object) {
  im.Image? image = im.decodeImage(object.imageFile!.readAsBytesSync());
  double newWidth = double.parse((image?.width ?? 0).toString());
  double newHeight = double.parse((image?.height ?? 0).toString());
  double factor = 1;
  if (newWidth > newHeight) {
    factor = newHeight / newWidth;

    if (newWidth > 500) {
      newHeight = newWidth * factor;
    }
  } else if (newHeight > newWidth) {
    factor = newWidth / newHeight;
    if (newHeight > 500) {
      newHeight = 500;
      newWidth = newHeight * factor;
    }
  }

  im.Image smallerImage = im.copyResize(image!,
      width: newWidth.toInt(),
      height: newHeight.toInt(),
      interpolation: im.Interpolation
          .cubic); // choose the size here, it will maintain aspect ratio (non è vero almeno dai primi test, ho modificato in modo da calcolare l'aspect ratio manualmente)
  var decodedImageFile = File('${object.path!}/img_${object.rand}.jpg');
  decodedImageFile.writeAsBytesSync(im.encodeJpg(smallerImage, quality: 85));
  return decodedImageFile.path;
}

Future<Uint8List> _decodeImageUint8List(_CompressObject object) async {
  im.Image? image = im.decodeImage(object.imageFile!.readAsBytesSync());
/*
  double newWidth = double.parse((image?.width ?? 0).toString());
  double newHeight = double.parse((image?.height ?? 0).toString());
  double factor = 1;
*/
/*  if (newWidth > newHeight) {
    factor = newHeight / newWidth;

    if (newWidth > 500) {
      newWidth = 500;
      newHeight = newWidth * factor;
    }
  } else if (newHeight > newWidth) {
    factor = newWidth / newHeight;
    if (newHeight > 500) {
      newHeight = 500;
      newWidth = newHeight * factor;
    }
  }*/

  im.Image smallerImage = im.copyResize(
    image!,
    width: object.size,
    /* height: newHeight.toInt(),
      interpolation: im.Interpolation
          .linear*/
  ); // choose the size here, it will maintain aspect ratio (non è vero almeno dai primi test, ho modificato in modo da calcolare l'aspect ratio manualmente)
  var decodedImageFile = File('${object.path!}/img_${object.rand}.jpg');
  decodedImageFile
      .writeAsBytesSync(im.encodeJpg(smallerImage, quality: object.quality!));
  return await decodedImageFile.readAsBytes();
}

class _CompressObject {
  File? imageFile;
  FilePickerResult? imageFilePicker;
  String? path;
  int? rand = 1;
  int? size = 250;
  int? quality = 100;

  Uint8List? bytes;

  _CompressObject(
      {this.path,
      this.rand,
      this.size,
      this.quality,
      this.bytes,
      this.imageFile,
      this.imageFilePicker});
}
