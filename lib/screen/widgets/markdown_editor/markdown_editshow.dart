import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownEditShow extends StatefulWidget {
  const MarkdownEditShow(
      {required this.status, required this.textController, Key? key})
      : super(key: key);

  final MarkdownEditorStatus status;
  final TextEditingController textController;

  @override
  MarkdownEditShowState createState() => MarkdownEditShowState();
}

class MarkdownEditShowState extends State<MarkdownEditShow> {
  @override
  void initState() {
    debugPrint("MarkdownEditShow initState");
    super.initState();
  }

  @override
  void dispose() {
    debugPrint("MarkdownEditShow dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: widget.status == MarkdownEditorStatus.write
            ? TextField(
                controller: widget.textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
              )
            : MarkdownBody(
                shrinkWrap: false,
                fitContent: false,
                //controller: _scrollController,
                data: widget.textController.text,
              ));
  }
}

enum MarkdownEditorStatus {
  preview,
  write,
  show;
}
