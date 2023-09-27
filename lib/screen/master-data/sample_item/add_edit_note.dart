import 'package:dpicenter/screen/widgets/markdown_editor/markdown_editor.dart';
import 'package:dpicenter/screen/widgets/markdown_editor/markdown_editshow.dart';
import 'package:flutter/material.dart';

class AddEditNote extends StatefulWidget {
  const AddEditNote({Key? key, this.text}) : super(key: key);

  final String? text;

  @override
  AddEditNoteState createState() => AddEditNoteState();
}

class AddEditNoteState extends State<AddEditNote> {
  final GlobalKey<MarkdownEditorState> _markdownKey =
      GlobalKey<MarkdownEditorState>(debugLabel: '_markdownKey');

  String? get currentText => _markdownKey.currentState?.controller.text;

  set currentText(String? text) {
    if (text != null) {
      _markdownKey.currentState?.controller.text = text;
    } else {
      _markdownKey.currentState?.controller.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MarkdownEditor(
          key: _markdownKey,
          status: MarkdownEditorStatus.write,
          text: widget.text,
        ),
      ),
    );
  }
}
