import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/config/change_log.dart';
import 'package:dpicenter/models/config/start_config_model.dart';
import 'package:dpicenter/models/server/manufacturer.dart';
import 'package:dpicenter/screen/master-data/validation_helpers/key_validation_state.dart';
import 'package:dpicenter/screen/widgets/changelog/change_log_item.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/dialog_title.dart';
import 'package:dpicenter/screen/widgets/dialog_title_ex.dart';
import 'package:dpicenter/screen/widgets/textfieldarea/text_form_field_ex.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

// Define a custom Form widget.
class ChangeLogScreen extends StatefulWidget {
  final StartConfig? config;

  const ChangeLogScreen({Key? key, this.config}) : super(key: key);

  @override
  ChangeLogScreenState createState() {
    return ChangeLogScreenState();
  }
}

class ChangeLogScreenState extends State<ChangeLogScreen> {
  final _formKey = GlobalKey<FormState>();

  StartConfig config = StartConfig();

  final ScrollController _scrollController =
      ScrollController(debugLabel: "_scrollController");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      config = widget.config ?? await StartConfig.loadFromAsset();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    return FocusScope(
      child: Container(
        constraints: const BoxConstraints(minWidth: 500, maxHeight: 800),
        color: getAppBackgroundColor(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const DialogTitleEx("Changelog"),
            Flexible(
                child: Scaffold(
              backgroundColor: getAppBackgroundColor(context),
              body: Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),

                    ///permette al widget di essere scrollato
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: changeLogList(),
                        )
                      ],
                    ),
                  )),
              //floatingActionButton: getFloatingActionButton(),
            )),
            OkCancel(
                cancelText: 'CHIUDI',
                onCancel: () {
                  Navigator.maybePop(context, null);
                })
          ],
        ),
      ),
    );
  }

  Widget changeLogList() {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      color: isDarkTheme(context)
          ? Color.alphaBlend(
              Theme.of(context).colorScheme.surface.withAlpha(240),
              Theme.of(context).colorScheme.primary)
          : Theme.of(context).colorScheme.surface,
      child: SeparatedSettingsList(
          shrinkWrap: true,
          contentPadding: EdgeInsets.zero,
          //contentPadding: EdgeInsets.zero,
          platform: DevicePlatform.web,
          automaticKeepAlive: false,
          sections: List.generate(config.changeLogs?.length ?? 0, (index) {
            ChangeLog item = config.changeLogs![index];
            return ChangeLogItem(item: item);
            /*return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              Text(item.date ?? ''),
              Text('${item.version ?? 'test'} (${item.versionNumber ?? 'test'})'),
              Text(item.info ?? ''),
            ],);*/
          })),
    );
  }

  Widget itemData(String content,
      {String? label, TextStyle? labelTextStyle, TextStyle? contentTextStyle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text("$label:",
              style: labelTextStyle ??
                  itemValueTextStyle().copyWith(fontSize: 10)),
        Text(content, style: contentTextStyle ?? itemValueTextStyle()),
      ],
    );
  }
}
