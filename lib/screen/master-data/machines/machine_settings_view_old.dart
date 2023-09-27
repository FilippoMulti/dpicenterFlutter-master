import 'dart:async';

import "package:collection/collection.dart";
import 'package:dpicenter/extensions/iterable_extension.dart';
import 'package:dpicenter/extensions/string_extension.dart';
import 'package:dpicenter/globals/settings_list_global.dart';
import 'package:dpicenter/globals/theme_global.dart';
import 'package:dpicenter/globals/ui_global.dart';
import 'package:dpicenter/models/menus/menu.dart';
import 'package:dpicenter/models/server/machine.dart';
import 'package:dpicenter/models/server/machine_setting.dart';
import 'package:dpicenter/models/server/vmc_setting_category.dart';
import 'package:dpicenter/platform/platform_helper.dart';
import 'package:dpicenter/screen/master-data/machines/machine_edit_screen.dart';
import 'package:dpicenter/screen/widgets/dashboard/multi_select.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class MachineSettingsView extends StatefulWidget {
  final Machine machine;
  final VoidCallback closePressed;

  const MachineSettingsView(
      {required this.machine, required this.closePressed, Key? key})
      : super(key: key);

  @override
  MachineSettingsViewState createState() => MachineSettingsViewState();
}

class MachineSettingsViewState extends State<MachineSettingsView> {
  Map<VmcSettingCategory, List<MachineSetting>>? categories;
  List<SettingsScrollSection> settingsSections = <SettingsScrollSection>[];
  List<MachineSetting>? selectedSettings = <MachineSetting>[];
  final Map<String, GlobalKey> categoryKeysMap = <String, GlobalKey>{};
  final List<MapSettingKey> categorySettingsList = <MapSettingKey>[];
  final ScrollController _scrollController =
      ScrollController(debugLabel: 'machineSettingsViewScrollController');
  MapSettingKey? _selectedMapSettingKey;

  final GlobalKey<MultiSelectorExState> _multiSelectorKey =
      GlobalKey<MultiSelectorExState>(debugLabel: '_multiSelectorKey');
  int statNavStatus = 0;

  @override
  void initState() {
    super.initState();
    selectedSettings = widget.machine.machineSettings;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  createSettingsSections() {
    settingsSections.clear();

    if (selectedSettings != null) {
      ///ottengo le categorie
      categories = selectedSettings?.groupBy((m) => VmcSettingCategory(
          vmcSettingCategoryCode: m.categoryCode,
          name: m.categoryName,
          color: m.categoryColor));

      if (categories != null) {
        for (VmcSettingCategory element in categories!.keys) {
          ///creo le chiavi per le categorie
          if (!categoryKeysMap.containsKey(element.vmcSettingCategoryCode)) {
            categoryKeysMap.addAll({
              element.vmcSettingCategoryCode!:
                  GlobalKey(debugLabel: element.vmcSettingCategoryCode)
            });
          }

          ///separo le impostazioni per categoria
          List<MachineSetting> categorySettings = <MachineSetting>[];
          for (MachineSetting item in selectedSettings!) {
            if (categorySettingsList.firstWhereOrNull(
                    (element) => element.fieldId == item.vmcSettingFieldId) ==
                null) {
              categorySettingsList.add(MapSettingKey(
                  fieldId: item.vmcSettingFieldId,
                  machineSetting: item,
                  fieldName: item.name ?? '',
                  key: GlobalKey(debugLabel: item.name ?? '')));
            }

            if (item.categoryCode == element.vmcSettingCategoryCode) {
              categorySettings.add(item);
            }
          }

          ///creo le sezioni
          settingsSections.add(SettingsScrollSection(
            key: categoryKeysMap[element.vmcSettingCategoryCode],
            color: element.color != null
                ? isDarkTheme(context)
                    ? Color.alphaBlend(
                        Color(int.parse(element.color!)).withAlpha(200),
                        Color.alphaBlend(
                            Theme.of(context)
                                .colorScheme
                                .surface
                                .withAlpha(240),
                            Theme.of(context).colorScheme.primary))
                    : Color.alphaBlend(
                        Color(int.parse(element.color!)).withAlpha(200),
                        Theme.of(context).colorScheme.surface)
                : null,
            //element.color!=null ? Color(int.parse(element.color!)).withAlpha(80) : null,
            title: Text(element.name!),
            tiles: categorySettings.isNotEmpty
                ? List.generate(
                    categorySettings.length,
                    (index) => _settingSettingTile(categorySettings[index]),
                  )
                : List.generate(
                    1,
                    (index) => getCustomSettingTile(
                        child: const Text('Nessuna impostazione selezionata'))),
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectedSettings != null && settingsSections.isEmpty) {
      createSettingsSections();
    }

    return Column(
      children: [
        SizedBox(
          height: 120,
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IntrinsicWidth(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: _multiSelectorWidget(),
                      )),
                      IntrinsicWidth(child: _settingsFieldsDropDownWidget()),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: widget.closePressed,
              ),
            ],
          ),
        ),
        Expanded(
          child: SettingsScroll(
            controller: _scrollController,
            darkTheme: SettingsThemeData(
              settingsListBackground: isDarkTheme(context)
                  ? Color.alphaBlend(
                      Theme.of(context).colorScheme.surface.withAlpha(240),
                      Theme.of(context).colorScheme.primary)
                  : Theme.of(context).colorScheme.surface,
            ),
            lightTheme: const SettingsThemeData(
                settingsListBackground: Colors.transparent),
            //contentPadding: EdgeInsets.zero,
            platform: DevicePlatform.web,
            sections: [
              ...settingsSections,
            ],
          ),
        ),
      ],
    );
  }

  SettingsTile _settingSettingTile(MachineSetting item) {
    if (selectedSettings != null) {
      switch (item.type) {
        case 6:

          ///double input
          break;
        case 5:

          ///int input
          break;
        case 4:

          ///check box
          List<String> valuesToSelect = <String>[];

          if (item.params != null) {
            valuesToSelect = item.params!.split('|');
          }

          return getSwitchSettingTile(
              readOnly: true,
              key: categorySettingsList
                  .firstWhereOrNull(
                      (element) => element.fieldId == item.vmcSettingFieldId)
                  ?.key,
              title: item.name ?? '',
              description: item.description,
              icon: const Icon(Icons.settings),
              initialValue: valuesToSelect.isEmpty
                  ? item.value.toLowerCase() == "vero"
                      ? true
                      : false
                  : item.value.toLowerCase() == valuesToSelect[0].toLowerCase()
                      ? true
                      : false,
              textWhenTrue: valuesToSelect.isEmpty ? 'Vero' : valuesToSelect[0],
              textWhenFalse:
                  valuesToSelect.isEmpty ? 'Falso' : valuesToSelect[1],
              onToggle: (value) {
                for (int index = 0; index < selectedSettings!.length; index++) {
                  if (selectedSettings![index].vmcSettingFieldId ==
                      item.vmcSettingFieldId) {
                    setState(() {
                      String trueString = 'Vero';
                      String falseString = 'Falso';
                      if (valuesToSelect.isNotEmpty) {
                        trueString = valuesToSelect[0];
                        falseString = valuesToSelect[1];
                      }
                      selectedSettings![index] = selectedSettings![index]
                          .copyWith(value: value ? trueString : falseString);
                    });
                    break;
                  }
                }
              },
              defaultTextColor: isDarkTheme(context)
                  ? darkTileDescriptionTextColor
                  : lightTileDescriptionTextColor);

        case 3:

          ///Image
          break;
        case 2:

          ///UpDown

          List<String> valuesToSelect = <String>[];
          if (item.params != null) {
            ///min|max|step|fractionDigits
            valuesToSelect = item.params!.split('|');
          }
          return getUpDownSettingTile(
            readOnly: true,
            key: categorySettingsList
                .firstWhereOrNull(
                    (element) => element.fieldId == item.vmcSettingFieldId)
                ?.key,
            title: item.name ?? '',
            hint: item.name ?? '',
            description: item.description,
            initialValue: item.value.isEmpty ? "0" : item.value,
            quarterTurns: 0,
            icon: const Icon(Icons.settings),
            min: valuesToSelect.isEmpty ? 0 : double.parse(valuesToSelect[0]),
            step: valuesToSelect.isEmpty ? 1 : double.parse(valuesToSelect[2]),
            max:
                valuesToSelect.isEmpty ? 1000 : double.parse(valuesToSelect[1]),
            onResult: (String? result) {
              if (result != null) {
                for (int index = 0; index < selectedSettings!.length; index++) {
                  if (selectedSettings![index].vmcSettingFieldId ==
                      item.vmcSettingFieldId) {
                    setState(() {
                      selectedSettings![index] = selectedSettings![index]
                          .copyWith(
                              value: double.parse(result).toStringAsFixed(
                                  valuesToSelect.isEmpty
                                      ? 0
                                      : int.parse(valuesToSelect[3])));
                    });
                    break;
                  }
                }
              }
            },
          );
        case 1:

          ///Selection

          if (item.params != null) {
            List<String> valuesToSelect = <String>[];
            valuesToSelect = item.params!.split('|');
            return getSelectionSettingTile(
              readOnly: true,
              key: categorySettingsList
                  .firstWhereOrNull(
                      (element) => element.fieldId == item.vmcSettingFieldId)
                  ?.key,
              title: item.name,
              hint: item.name,
              description: item.description,
              icon: const Icon(Icons.settings),
              initialValue: item.value.isEmpty ? '' : item.value,
              children: [
                ...valuesToSelect.map((e) {
                  return SimpleDialogOption(
                      onPressed: () {
                        for (int index = 0;
                            index < selectedSettings!.length;
                            index++) {
                          if (selectedSettings![index].vmcSettingFieldId ==
                              item.vmcSettingFieldId) {
                            setState(() {
                              selectedSettings![index] =
                                  selectedSettings![index].copyWith(value: e);
                            });
                            break;
                          }
                        }

                        if (!mounted) return;
                        Navigator.of(context).maybePop();
                      },
                      //
                      child: Row(
                        children: [
                          /*type.toIcon(),
                      const SizedBox(
                      width: 8,
                      ),*/
                          Text(e),
                        ],
                      ));
                })
              ],
            );
          }
          break;
        case 0:
        default:

          ///TextInput

          return getTextInputSettingTile(
              readOnly: true,
              key: categorySettingsList
                  .firstWhereOrNull(
                      (element) => element.fieldId == item.vmcSettingFieldId)
                  ?.key,
              title: item.name,
              hint: item.name,
              description: item.description,
              onResult: (String? result) {
                if (result != null) {
                  for (int index = 0;
                      index < selectedSettings!.length;
                      index++) {
                    if (selectedSettings![index].vmcSettingFieldId ==
                        item.vmcSettingFieldId) {
                      setState(() {
                        selectedSettings![index] =
                            selectedSettings![index].copyWith(value: result);
                      });
                      break;
                    }
                  }
                }
              },
              initialValue: item.value.isEmpty ? '' : item.value,
              icon: const Icon(Icons.settings));
      }
    }
    return getCustomSettingTile(child: const Text('Errore'));
  }

  EdgeInsets getPadding() {
    return const EdgeInsets.symmetric(vertical: 8, horizontal: 16);
  }

  Widget _settingsFieldsDropDownWidget() {
    return Padding(
      padding: getPadding(),
      child: DropdownSearch<MapSettingKey>(
        enabled: true,
        popupProps: PopupPropsMultiSelection.dialog(
          containerBuilder: (context, child) {
            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: child);
          },
          itemBuilder: (context, item, isSelected) {
            return getMachineSettingItem(item.machineSetting,
                context: context, showClearButton: false);
          },
          scrollbarProps: const ScrollbarProps(thickness: 0),
          dialogProps: DialogProps(
            backgroundColor: getAppBackgroundColor(context),
          ),
          showSelectedItems: true,
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              autofocus: isWindows || isWindowsBrowser ? true : false,
              //    controller: settingFieldsController,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                labelText: "Cerca",
              )),
          emptyBuilder: (context, searchEntry) =>
              const Center(child: Text('Nessun risultato')),
        ),
        //popupBackgroundColor: getAppBackgroundColor(context),

        compareFn: (item, selectedItem) => item.fieldId == selectedItem.fieldId,
        //showClearButton: true,
        clearButtonProps: const ClearButtonProps(isVisible: true),
        itemAsString: (MapSettingKey? c) => c?.machineSetting.name ?? 'no name',

        dropdownBuilder: (context, MapSettingKey? item) {
          if (item != null) {
            return getMachineSettingItem(item.machineSetting,
                context: context, showClearButton: false);
          } else {
            return const Text("Seleziona un campo");
          }
        },
        selectedItem: _selectedMapSettingKey,
        onChanged: (MapSettingKey? newValue) async {
          setState(() {
            _selectedMapSettingKey = newValue;
          });
          if (_selectedMapSettingKey != null) {
            //RenderObject? renderObj = _selectedMapSettingKey?.key.currentContext?.findRenderObject();
            Scrollable.ensureVisible(
                _selectedMapSettingKey!.key.currentContext!,
                duration: const Duration(milliseconds: 500));
            Timer(const Duration(milliseconds: 500), () async {
              await tapTargetWithEffect(_selectedMapSettingKey!.key);
            });
            //await Future.delayed(const Duration(milliseconds: 1500),

            //);
            /*if (renderObj!=null) {
              await scrollTo(renderObj);
            }*/
          }
        },
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            //enabledBorder: OutlineInputBorder(),
            border: OutlineInputBorder(),
            labelText: 'Cerca impostazione',
            hintText: 'Seleziona un campo',
            isDense: true,
          ),
        ),

        validator: (item) {
          return null;
        },
        items: categorySettingsList,
        filterFn: (MapSettingKey? item, String? filter) {
          String json = item?.fieldName ?? '';
          String newString = json.removePunctuation();
          if (kDebugMode) {
            print(newString);
          }
          String filterString = filter?.removePunctuation() ?? '';
          return newString.toLowerCase().contains(filterString.toLowerCase());
        },
      ),
    );
  }

  Widget _multiSelectorWidget() {
    return MultiSelectorEx(
      key: _multiSelectorKey,
      onPressed: (index) async {
        statNavStatus = index;
        /*setState(() {
                        statNavStatus = index;
                    });*/
        _scrollToCurrentStatus();
        //widget.onNavigationPressed!.call(statNavStatus==0 ? _filterKey.currentContext! : _chartKey.currentContext!);
      },
      status: statNavStatus,
      selectorData: _getSelectorData(),
    );
  }

  void _scrollToCurrentStatus() async {
    if (statNavStatus >= 0) {
      RenderObject? renderObj;
      renderObj = categoryKeysMap[categoryKeysMap.keys.elementAt(statNavStatus)]
          ?.currentContext
          ?.findRenderObject();
      if (renderObj != null) {
        //_mainScrollController.jumpTo(_mainScrollController.offset);
        await scrollTo(renderObj);
      }
    }
  }

  Future scrollTo(RenderObject renderObj) async {
    // _mainScrollController.removeListener(scrollListener);
    await _scrollController.position.ensureVisible(renderObj,
        alignment: 0.0,
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeOut,
        targetRenderObject: renderObj,
        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit);
    // _mainScrollController.addListener(scrollListener);
  }

  List<SelectorData> _getSelectorData() {
    if (selectedSettings != null) {
      Map map = selectedSettings!.groupBy((p0) => p0.categoryName);
      List<SelectorData> result = <SelectorData>[];
      for (var element in map.keys) {
        result.add(
          SelectorData(
              periodString: element,
              child: const Icon(Icons.category),
              selectedColor: getMenuColor(selectedSettings!
                  .firstWhere((selSet) => selSet.categoryName == element)
                  .categoryColor)),
        );
      }
      return result;
    }
    return <SelectorData>[];
  }
}
