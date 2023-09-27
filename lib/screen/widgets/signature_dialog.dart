import 'package:dpicenter/screen/widgets/signature_multi.dart';
import 'package:flutter/material.dart';
//import 'package:gato/gato.dart';

class SignatureDialog extends StatefulWidget {
  const SignatureDialog(
      {Key? key,
      required this.controller,
      required this.startHeight,
      required this.startWidth})
      : super(key: key);
  final SignatureController controller;
  final double startHeight;
  final double startWidth;

  @override
  SignatureDialogState createState() => SignatureDialogState();
}

class SignatureDialogState extends State<SignatureDialog> {
  late double canvasWidth;
  late double canvasHeight;

  ///idealmente la dimensione per la firma è w600 x h300
  ///se la dimensione orrizzontale è < 600, l'altezza sarà uguale a width\2
  late Signature _signatureCanvas;

  @override
  void initState() {
    super.initState();
    canvasWidth = widget.startWidth;
    canvasHeight = widget.startHeight;
  }

  @override
  Widget build(BuildContext context) {
    _signatureCanvas = Signature(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      controller: widget.controller,
      backgroundColor: Colors.white,
      width: canvasWidth,
      height: canvasHeight,
    );

    return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: canvasHeight,
        width: canvasWidth,
        child: Center(
            child: Column(
          children: [
            _signatureCanvas,
          ],
        )));
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
    var mediaData = MediaQuery.of(context);
    final double newWidth =
        mediaData.size.width >= 600 ? 600 : mediaData.size.width - 10;
    final double newHeight = newWidth < 600 ? newWidth / 2 : 300;

    setState(() {
      canvasWidth = newWidth;
      canvasHeight = newHeight;
    });
  }
}
