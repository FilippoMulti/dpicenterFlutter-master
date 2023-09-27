import 'dart:typed_data';

import 'package:dpicenter/globals/pdf.global.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/dialog_title_ex.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:settings_ui/settings_ui.dart';

import 'label_format.dart';

class PrintQrOptions extends StatefulWidget {
  final String? title;
  final List<QrInfo> qrImages;
  final int repeatCount;

  const PrintQrOptions(
      {required this.qrImages, this.repeatCount = 1, this.title, super.key});

  @override
  PrintQrOptionsState createState() => PrintQrOptionsState();
}

class PrintQrOptionsState extends State<PrintQrOptions> {
  final List<LabelFormat> _labelFormats = <LabelFormat>[];
  final FocusNode _saveFocusNode = FocusNode(debugLabel: '_saveFocusNode');
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: '_formKey');

  ///numero di copie dell'etichetta
  int repeatCount = 1;

  ///posizione di partenza della stampa
  int startIndex = 1;

  @override
  void initState() {
    super.initState();

    _labelFormats.add(LabelFormat(
        pageFormat: PdfPageFormat.a4.copyWith(
            marginTop: 0.8 * PdfPageFormat.cm,
            marginBottom: 0.8 * PdfPageFormat.cm,
            marginRight: 0,
            marginLeft: 0),
        labelWidth: 10.5,
        labelHeight: 14));

    _labelFormats.add(LabelFormat.count(
        pageFormat: PdfPageFormat.a4.copyWith(
            marginTop: 0.4 * PdfPageFormat.cm,
            marginBottom: 0.4 * PdfPageFormat.cm,
            marginRight: 0,
            marginLeft: 0),
        rowCount: 3,
        columnCount: 8));

    _labelFormats.add(LabelFormat.count(
        pageFormat: PdfPageFormat.a4.copyWith(
            marginTop: 1.3 * PdfPageFormat.cm,
            marginBottom: 1.3 * PdfPageFormat.cm,
            marginRight: 1.2 * PdfPageFormat.cm,
            marginLeft: 1.2 * PdfPageFormat.cm),
        rowCount: 5,
        columnCount: 16));

    _labelFormats.add(LabelFormat.count(
        pageFormat: PdfPageFormat.a4.copyWith(
            marginTop: 0, marginBottom: 0, marginRight: 0, marginLeft: 0),
        rowCount: 2,
        columnCount: 5));
    _labelFormats.add(LabelFormat.count(
        pageFormat: PdfPageFormat.a4.copyWith(
            marginTop: 0, marginBottom: 0, marginRight: 0, marginLeft: 0),
        rowCount: 4,
        columnCount: 5));
    _labelFormats.add(LabelFormat.count(
        pageFormat: PdfPageFormat.a4.copyWith(
            marginTop: 0, marginBottom: 0, marginRight: 0, marginLeft: 0),
        rowCount: 8,
        columnCount: 8));
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Container(
        constraints: const BoxConstraints(minWidth: 500, maxHeight: 800),
        color: getAppBackgroundColor(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (widget.title != null) DialogTitleEx(widget.title!),
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
                        Flexible(
                          child: SettingsScroll(
                            darkTheme: SettingsThemeData(
                              settingsListBackground: isDarkTheme(context)
                                  ? Color.alphaBlend(
                                      Theme.of(context)
                                          .colorScheme
                                          .surface
                                          .withAlpha(240),
                                      Theme.of(context).colorScheme.primary)
                                  : Theme.of(context).colorScheme.surface,
                            ),
                            lightTheme: const SettingsThemeData(
                                settingsListBackground: Colors.transparent),
                            //contentPadding: EdgeInsets.zero,
                            platform: DevicePlatform.web,
                            sections: [
                              _printComboSection(),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
              //floatingActionButton: getFloatingActionButton(),
            )),
            OkCancel(
              /*okText: 'STAMPA',*/
              /*okFocusNode: _saveFocusNode,*/
              onCancel: () {
                Navigator.maybePop(context, null);
              },
              /*onSave: () {
                  printQrCodes();
                }*/
            )
          ],
        ),
      ),
    );
  }

  SettingsScrollSection _printComboSection() {
    return SettingsScrollSection(
        title: const Text("Opzioni di stampa"),
        tiles: [
          _labelTypeTile(),
          _copyTile(),
          _startTile(),
          _previewTile(),
        ]);
  }

  SettingsTile _labelTypeTile() {
    return getCustomSettingTile(
        title: 'Dimensione etichette',
        hint: 'Seleziona la dimensione delle etichette',
        description:
            'Seleziona la dimensione delle etichette oppure imposta una dimensione personalizzata',
        child: _labelsDropDownWidget());
  }

  SettingsTile _copyTile() {
    return getUpDownSettingTile(
        title: 'Numero di copie',
        hint: 'Imposta il numero di copie',
        description: 'Imposta il numero di copie',
        initialValue: repeatCount.toString(),
        onResult: (String? value) {
          if (value != null) {
            setState(() {
              repeatCount = double.parse(value).toInt();
            });
          }
        });
  }

  SettingsTile _startTile() {
    return getUpDownSettingTile(
        title: 'Posizione di partenza',
        hint: 'Imposta la posizione di partenza della stampa.',
        description:
            'Imposta la posizione di partenza della stampa. La posizione di partenza di default \'1\' è la prima etichetta in alto a sinistra.',
        initialValue: startIndex.toString(),
        onResult: (String? value) {
          if (value != null) {
            setState(() {
              startIndex = double.parse(value).toInt();
            });
          }
        });
  }

  SettingsTile _previewTile() {
    return getCustomSettingTile(
        title: 'Antemprima',
        hint: 'Anteprima posizionamento etichette',
        description: 'Antemprima posizionamento etichette',
        child: SizedBox(
          width: 500,
          height: 600,
          child: PdfPreview(
            //key: _printPreviewKey,
            useActions: true,
            canChangeOrientation: false,
            canChangePageFormat: false,
            allowSharing: false,
            build: (PdfPageFormat format) async {
              var pdf = await createQrCodePdf3(
                  labelFormat: _selectedLabelFormat != null
                      ? _selectedLabelFormat!
                      : LabelFormat(
                          pageFormat: PdfPageFormat.a4.copyWith(
                              marginLeft: 0,
                              marginRight: 0,
                              marginTop: 0.8 * PdfPageFormat.cm,
                              marginBottom: 0.8 * PdfPageFormat.cm)),
                  qrImages: widget.qrImages,
                  repeatCount: repeatCount,
                  startIndex: startIndex);
              return pdf.save();
            },
          ),
        ));
  }

  LabelFormat? _selectedLabelFormat;

  Widget _labelsDropDownWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: DropdownSearch<LabelFormat>(
          //key: _hashTagDropDownKey,
          popupProps: PopupProps.dialog(
            scrollbarProps: const ScrollbarProps(thickness: 0),
            dialogProps:
                DialogProps(backgroundColor: getAppBackgroundColor(context)),
            searchFieldProps: TextFieldProps(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                autofocus: isWindows || isWindowsBrowser ? true : false,
                // controller: _searchHashTagsController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Cerca")),
            showSelectedItems: true,
            showSearchBox: true,
            emptyBuilder: (BuildContext context, String? item) {
              return Center(child: Text('Nessun risultato trovato'));
            },
            itemBuilder:
                (BuildContext context, LabelFormat item, bool isSelected) {
              return ListTile(
                contentPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                title: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                          "${item.labelWidth.toStringAsFixed(2)}x${item.labelHeight.toStringAsFixed(2)}"),
                    )),
                /*subtitle: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
                      child: Text(item.description!))*/
              );
            },
          ),
          /*focusNode: isWindows || isWindowsBrowser ? null : _hashTagFocusNode,*/
          enabled: true,
          /*popupBackgroundColor: getAppBackgroundColor(context),*/
          autoValidateMode: _selectedLabelFormat == null
              ? AutovalidateMode.disabled
              : AutovalidateMode.onUserInteraction,
          compareFn: (item, selectedItem) => item == selectedItem,
          clearButtonProps: const ClearButtonProps(isVisible: true),
          itemAsString: (LabelFormat? c) =>
              "${c?.labelWidth.toStringAsFixed(2) ?? '?'}x${c?.labelHeight.toStringAsFixed(2) ?? '?'}",
          onChanged: (LabelFormat? newValue) {
            setState(() {
              _selectedLabelFormat = newValue;
            });
          },
          dropdownDecoratorProps: const DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              //enabledBorder: OutlineInputBorder(),
              border: OutlineInputBorder(),
              labelText: 'Formati etichette',
              hintText: 'Seleziona un formato da utilizzare per la stampa',
            ),
          ),

          /*validator: (items) {
            if (items != null && items.isEmpty) {
              KeyValidationState state = _keyStates
                  .firstWhere((element) => element.key == _hashTagDropDownKey);
              _keyStates[_keyStates.indexOf(state)] =
                  state.copyWith(state: false);
              return "Seleziona almeno un hashtag";
            } else {
              KeyValidationState state = _keyStates
                  .firstWhere((element) => element.key == _hashTagDropDownKey);
              _keyStates[_keyStates.indexOf(state)] =
                  state.copyWith(state: true);
            }
            return null;
          },
*/

          items: _labelFormats,
          selectedItem: _selectedLabelFormat,
        ));
  }

  @override
  void dispose() {
    _saveFocusNode.dispose();
    super.dispose();
  }

  void printQrCodes() {}
}
