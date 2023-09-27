import 'package:intl/intl.dart';

extension BoolParsing on String {
  bool parseBool() {
    return toLowerCase() == 'true';
  }
}

extension RemovePunctuation on String {
  String removePunctuation() {
    String regex =
        r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]+';
    return replaceAll(RegExp(regex, unicode: true), '');
  }
}

extension DateParsing on String {
  DateTime toDate() {
    return DateTime.parse(this);
  }

  String toLocalDateTimeString({bool isUtc = false}) {
    return DateFormat('dd-MM-yyyy HH:mm')
        .format(DateTime.parse('${this}${isUtc ? 'Z' : ''}').toLocal());
  }

// ···
}
