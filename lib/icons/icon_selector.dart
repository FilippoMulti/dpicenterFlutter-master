import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/screen/navigation/navigation_global.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/dialog_title_ex.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import 'material.dart';

class IconSelector extends StatefulWidget {
  const IconSelector({Key? key}) : super(key: key);

  @override
  State<IconSelector> createState() => _IconSelectorState();
}

class _IconSelectorState extends State<IconSelector> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<String> localIcons = icons.keys
        .where((element) =>
            searchController.text.isEmpty ||
            element.toLowerCase().contains(searchController.text.toLowerCase()))
        .toList();

    return FocusScope(
      child: Container(
        constraints: const BoxConstraints(minWidth: 500, maxHeight: 800),
        color: getAppBackgroundColor(context),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const DialogTitleEx('Seleziona icona'),
            Padding(
              padding: const EdgeInsets.all(16),
              child: _searchField(),
            ),
            const Divider(),
            Expanded(
                child: Scaffold(
              backgroundColor: getAppBackgroundColor(context),
              body: Form(
                  //key: _formKey,
                  child: Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),

                ///permette al widget di essere scrollato
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: Icon(
                              icons[localIcons.elementAt(index)],
                              size: 32,
                            ),
                            title: Text(localIcons.elementAt(index)),
                            onTap: () {
                              Navigator.maybePop(
                                  context, localIcons.elementAt(index));
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                        itemCount: localIcons.length,
                      ),
                    )
                  ],
                ),
              )),
              //floatingActionButton: getFloatingActionButton(),
            )),
            OkCancel(onCancel: () {
              Navigator.maybePop(context, null);
            }, onSave: () {
              Navigator.maybePop(context, null);
            })
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget _searchField() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        filled: true,
        labelText: 'Cerca icona',
        hintText: 'Cerca',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                searchController.text = "";
              });
            }),
      ),
      onChanged: (value) {
        setState(() {});
      },
    );
  }
}

Widget getIconItem(int index) {
  return ListTile(
      leading: Icon(icons[index]), title: Text(icons.keys.elementAt(index)));
}

Widget getItem(IconData iconData, String name) {
  return ListTile(leading: Icon(iconData), title: Text(name));
}

Future showIconSelector(BuildContext context, {Widget? iconSelector}) async {
  var result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return multiDialog(content: iconSelector ?? const IconSelector());
      }).then((returningValue) {
    if (returningValue != null) {
      return returningValue;
    }
  });
  return result;
}
