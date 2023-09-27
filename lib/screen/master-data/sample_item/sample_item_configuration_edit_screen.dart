import 'dart:convert';
import 'dart:typed_data';

import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/server/autogeneration/sample_item.dart';
import 'package:dpicenter/models/server/autogeneration/sample_item_picture.dart';
import 'package:dpicenter/models/server/autogeneration/vmc.dart';
import 'package:dpicenter/models/server/item.dart';
import 'package:dpicenter/screen/autogeneration/edit_sample_item.dart';
import 'package:dpicenter/screen/dialogs/message_dialog.dart';
import 'package:dpicenter/screen/master-data/validation_helpers/key_validation_state.dart';
import 'package:dpicenter/screen/widgets/dashboard/multi_select_container.dart';
import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/dialog_title.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../models/server/autogeneration/item_confìguration.dart';
//import 'package:universal_io/io.dart';

// Define a custom Form widget.
class SampleItemConfigurationEditForm extends StatefulWidget {
  final Item item;
  final Vmc vmc;
  final String? title;

  ///Se viene impostato [itemConfiguration] itemPictures viene utilizzato per caricare le immagini precedentemente salvate
  final List<SampleItemPicture>? itemPictures;

  ///Se in precedenza vi era una configurazione salvata caricarla impostando itemConfiguration
  final SampleItemConfiguration? itemConfiguration;

  const SampleItemConfigurationEditForm({
    Key? key,
    required this.item,
    required this.title,
    required this.vmc,
    this.itemPictures,
    this.itemConfiguration,
  }) : super(key: key);

  @override
  SampleItemConfigurationEditFormState createState() =>
      SampleItemConfigurationEditFormState();
}

class SampleItemConfigurationEditFormState
    extends State<SampleItemConfigurationEditForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  final GlobalKey<EditSampleItemState> _editItemKey =
      GlobalKey<EditSampleItemState>(debugLabel: '_editItemKey');

  final ScrollController _scrollController =
      ScrollController(debugLabel: "_scrollController");

  late Item element;

  final FocusNode _saveFocusNode = FocusNode(debugLabel: '_saveFocusNode');

  ///chiavi per i campi da compilare

  late List<KeyValidationState> _keyStates;

  ///quando a true indica che la form è stata modificata
  bool editState = false;

  String imageGridKeyString = "key";

  //SerialPortReader? reader;

  SampleItem? _currentItem;

  //final ScrollController _editItemScrollController = ScrollController(debugLabel: '_editItemScrollController');
  @override
  void initState() {
    super.initState();

    initKeys();
    element = widget.item;
  }


  @override
  void dispose() {
    //_searchItemsController.dispose();

    _saveFocusNode.dispose();

    _scrollController.dispose();
    //_editItemScrollController.dispose();
    super.dispose();
  }

  final GlobalKey _noteSettingsSectionKey =
      GlobalKey(debugLabel: '_noteSettingsSectionKey');
  final GlobalKey _imageSectionKey = GlobalKey(debugLabel: '_imageSectionKey');
  final GlobalKey _configurationSectionKey =
      GlobalKey(debugLabel: '_configurationSectionKey');

  void initKeys() {
    _keyStates = <KeyValidationState>[
      KeyValidationState(key: _configurationSectionKey),
      KeyValidationState(key: _imageSectionKey),
      KeyValidationState(key: _noteSettingsSectionKey),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return MultiSelectorContainer(
        title: widget.title,
        headerSectionsMap: {
          const MultiSelectorItem(text: 'Configurazione'):
              _configurationSectionKey,
          const MultiSelectorItem(text: 'Immagini'): _imageSectionKey,
          const MultiSelectorItem(text: 'Note'): _noteSettingsSectionKey,
        },
        scrollController: _scrollController,
        bottom: OkCancel(
            okFocusNode: _saveFocusNode,
            onCancel: () async {
              EditSampleItemState? state = _editItemKey.currentState;
              if (state != null) {
                if (state.loaderKey.currentState != null &&
                    state.loaderKey.currentState!.compressStatus == 1) {
                  if (await stopCompressionMessage()) {
                    state.loaderKey.currentState!.stopCompression();
                  } else {
                    return;
                  }
                }
              }
              if (!mounted) return;
              Navigator.maybePop(context, null);
            },
            onSave: () async {
              EditSampleItemState? state = _editItemKey.currentState;
              if (state != null) {
                if (state.loaderKey.currentState != null &&
                    state.loaderKey.currentState!.compressStatus == 1) {
                  if (await stopCompressionMessage()) {
                    state.loaderKey.currentState!.stopCompression();
                  } else {
                    return;
                  }
                }
              }
              validateSave();
            }),
        child: FocusScope(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Form(
                    key: _formKey,
                    child: Container(
                        padding: const EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width > 1000
                            ? 900
                            : 500,
                        child: Column(
                          children: [
                            Expanded(
                          child: EditSampleItem(
                            key: _editItemKey,
                                scrollController: _scrollController,
                                item: element,
                                vmc: widget.vmc,
                                itemConfiguration: widget.itemConfiguration,
                                itemPictures: widget.itemPictures,
                                configurationSectionKey:
                                    _configurationSectionKey,
                                imageSectionKey: _imageSectionKey,
                                noteSettingsSectionKey: _noteSettingsSectionKey,
                              ),
                            )
                          ],
                        ))),
              ),
            ],
          ),
        ));
  }

  Future<void> showMessageWaitLoad() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return MessageDialog(
              title: 'Caricamento in corso',
              message: 'Attendere il completamento del caricamento.',
              type: MessageDialogType.okOnly,
              okText: 'OK',
              okPressed: () {
                Navigator.pop(context, true);
              });
        }).then((value) {
      return value;
      //return value
    });
  }

  Future<bool> stopCompressionMessage() async {
    bool result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
            title: 'Compressione in corso',
            message:
                'La compressione delle immagini è ancora in corso. Fermare la compressione delle immagini?',
            type: MessageDialogType.yesNo,
            yesText: 'SI',
            noText: 'NO',
            okPressed: () {
              Navigator.pop(context, true);
            },
            noPressed: () {
              Navigator.pop(context, false);
            });
      },
    ).then((value) {
      return value;
      //return value
    });
    return result;
  }


  Future<String?>? encodeBase64(Uint8List bytes) {
    try {
      return compute(base64Encode, bytes);
    } catch (e) {
      print(e);
    }
    return null;
  }

  void validateSave() async {
    try {
      if (_formKey.currentState!.validate()) {
        /*List<ItemPicture> itemPictures = <ItemPicture>[];
        for (var image in selectedImages!) {
          // var encoded = await encodeBase64(image.picture!.bytes!);

          ItemPicture itemPicture = image.copyWith(
              picture: image.picture!.copyWith(
                  bytes: image.picture!.bytes!,
                  pictureId: image.picture?.pictureId ?? 0));
          itemPictures.add(itemPicture);
        }


        if (element == null) {
          element = Item(
            itemId: 0,
            barcode: barcodeController.text,
            itemPhysicsId: 0,
            physicsConfiguration: ItemPhysicsConfiguration(
                itemPhysicsId: 0,
                widthMm: widthValue,
                depthMm: depthValue,
                heightMm: heightValue),
            itemPictures: itemPictures,
            itemCategoryId: selectedItemCategory?.itemCategoryId,
            itemCategory:
                null, //const ItemCategory(itemCategoryId: 6, code: '5', description: 'Articolo')
          );
        } else {
          element = element!.copyWith(
              barcode: barcodeController.text,
              physicsConfiguration: element!.physicsConfiguration!.copyWith(
                  widthMm: widthValue,
                  depthMm: depthValue,
                  heightMm: heightValue),
              itemPictures: itemPictures,
              itemCategoryId: selectedItemCategory?.itemCategoryId,
              itemCategory:
                  null
              );
        }*/
        //List<SampleItemPicture>? itemPictures = <SampleItemPicture>[];
        List? sampleItemConfig = _editItemKey.currentState?.sampleItemConfig;

        //itemPictures = _editItemKey.currentState?.loaderKey.currentState?.selectedImages?.map((e) => e.toSampleItemPicture()).toList();
        //SampleItem? result = _editItemKey.currentState?.sampleItem?.copyWith(itemPictures: itemPictures);

        Navigator.pop(context, sampleItemConfig);
      } else {
        try {
          KeyValidationState state =
              _keyStates.firstWhere((element) => element.state == false);

          _scrollController.position.ensureVisible(
            state.key.currentContext!.findRenderObject()!,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      }
    } catch (e) {
      print(e);
      await showMessageWaitLoad();
    }
  }

  EdgeInsets getPadding() {
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  }

}
