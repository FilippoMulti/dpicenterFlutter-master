import 'package:dpicenter/screen/widgets/markdown_editor/markdown_editshow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownEditor extends StatefulWidget {
  const MarkdownEditor({required this.status, this.text, Key? key})
      : super(key: key);

  final String? text;
  final MarkdownEditorStatus status;

  @override
  MarkdownEditorState createState() => MarkdownEditorState();
}

class MarkdownEditorState extends State<MarkdownEditor> {
  final GlobalKey<MarkdownEditShowState> _markdownEditShowKey =
      GlobalKey<MarkdownEditShowState>(debugLabel: '_markdownEditShowKey');

  MarkdownEditorStatus? _status;
  late TextEditingController controller;

  @override
  void initState() {
    _status = widget.status;
    controller = TextEditingController(text: widget.text);
    debugPrint("MarkdownEditor initState");
    super.initState();
  }

  @override
  void dispose() {
    debugPrint("MarkdownEditor dispose");
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MarkdownEditShow(
          key: _markdownEditShowKey,
          status: _status!,
          textController: controller,
        ),
        SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _status = MarkdownEditorStatus.write;
                  });
                },
                child: const Text("Scrivi"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _status = MarkdownEditorStatus.preview;
                  });
                },
                child: const Text("Anteprima"),
              ),
            ],
          ),
        )
      ],
    );
  }
}
