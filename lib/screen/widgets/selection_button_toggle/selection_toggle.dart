import 'package:flutter/material.dart';

class SelectionToggle extends StatefulWidget {
  const SelectionToggle(
      {this.initialValue, this.onTap, this.foregroundColor, super.key});

  final Function()? onTap;
  final Color? foregroundColor;
  final String? initialValue;

  @override
  SelectionToggleState createState() => SelectionToggleState();
}

class SelectionToggleState extends State<SelectionToggle> {
  String? _currentValue;

  String? get currentValue => _currentValue;

  set currentValue(String? currentValue) {
    if (_currentValue != currentValue) {
      setState(() {
        _currentValue = currentValue;
      });
    }
  }

  @override
  void initState() {
    currentValue = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_box,
              color: widget.foregroundColor,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              currentValue ?? '',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: widget.foregroundColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
