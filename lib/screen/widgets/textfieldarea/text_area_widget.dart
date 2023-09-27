import 'package:flutter/material.dart';

class TextArea extends StatefulWidget {
  final Widget child;
  final FocusNode focusNode;

  const TextArea({
    Key? key,
    required this.child,
    required this.focusNode,
  }) : super(key: key);

  @override
  TextAreaState createState() => TextAreaState();
}

class TextAreaState extends State<TextArea> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
/*    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      widget.focusNode.requestFocus();
    });*/
    return Scaffold(
        body: Column(
      children: [
        Expanded(child: Container()),
        Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: widget.child,
            ),
            TextButton(
                onPressed: () {
                  widget.focusNode.unfocus();
                  //Navigator.of(context).pop();
                  FocusManager.instance.primaryFocus?.unfocus();
                  //FocusManager.instance.primaryFocus?.unfocus();
                },
                child: const Text('Fatto')),
            const SizedBox(width: 40),
          ],
        ),
        const SizedBox(height: 16),
      ],
    ));
  }
}
