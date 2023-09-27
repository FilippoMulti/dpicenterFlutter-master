import 'package:dpicenter/screen/widgets/dialog_ok_cancel.dart';
import 'package:dpicenter/screen/widgets/dialog_title.dart';
import 'package:flutter/material.dart';

// Define a custom Form widget.
class UrlEditForm extends StatefulWidget {
  final String? title;
  final String url;
  final bool showBackground;
  final double backgroundOpacity;
  final bool usePreRelease;

  const UrlEditForm({
    Key? key,
    required this.title,
    required this.url,
    required this.showBackground,
    required this.backgroundOpacity,
    required this.usePreRelease,
  }) : super(key: key);

  @override
  _UrlEditFormState createState() {
    return _UrlEditFormState();
  }
}

class _UrlEditFormState extends State<UrlEditForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  late TextEditingController urlServerController;
  bool showBackgroundImage = false;

  bool preReleaseChannel = false;

  double currentSlideValue = 0;

  @override
  void initState() {
    super.initState();
    urlServerController = TextEditingController(text: widget.url);
    showBackgroundImage = widget.showBackground;
    currentSlideValue = widget.backgroundOpacity;
    preReleaseChannel = widget.usePreRelease;
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    return Form(
        key: _formKey,
        child: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DialogTitle('Impostazioni'),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: urlServerController,
                    decoration: const InputDecoration(
                      //enabledBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                      labelText: 'Indirizzo server',
                      hintText: 'Inserisci l\'indirizzo del server',
                    ),
                    validator: (str) {
                      if (str!.isEmpty) {
                        return "Campo obbligatorio";
                      }
                      if (Uri.tryParse("http://$str") == null) {
                        return "Inserire un indirizzo valido";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 22),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: CheckboxListTile(
                    title: const Text("Scarica pre release"),
                    activeColor: Theme.of(context).colorScheme.primary,
                    tristate: false,
                    onChanged: (bool? value) {
                      setState(() {
                        preReleaseChannel = value ?? false;
                      });
                    },
                    value: preReleaseChannel,
                  ),
                ),
                const SizedBox(height: 22),
                /* Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: CheckboxListTile(
                    title: const Text("Visualizza immagine di sfondo"),
                    activeColor: Theme.of(context).colorScheme.primary,
                    tristate: false,
                    onChanged: (bool? value) {
                      setState(() {
                        showBackgroundImage = value ?? false;
                      });
                    },
                    value: showBackgroundImage,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                          child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text("Opacità sfondo"),
                      )),
                      const SizedBox(
                        width: 16,
                      ),
                      const Expanded(child: SizedBox()),
                      Expanded(
                        child: Column(
                          children: [
                            Slider(
                              value: currentSlideValue,
                              max: 1.00,
                              min: 0.50,

                              //divisions: 9,

                              onChanged: (double value) {
                                setState(() {
                                  currentSlideValue = value;
                                });
                              },
                            ),
                            Text(currentSlideValue.toStringAsPrecision(2))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),*/
                const SizedBox(height: 20),
                OkCancel(
                  borderRadius: BorderRadius.circular(20),
                  onCancel: () {
                    Navigator.pop(context, null);
                  },
                  onSave: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context, [
                        urlServerController.text,
                        showBackgroundImage,
                        currentSlideValue,
                        preReleaseChannel
                      ]);
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}
