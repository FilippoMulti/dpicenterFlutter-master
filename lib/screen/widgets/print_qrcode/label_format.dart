import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dpicenter/models/server/mixin/mixin_json.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pdf/pdf.dart';

part 'label_format.g.dart';

@JsonSerializable()
@CopyWith()
class LabelFormat extends Equatable implements JsonPayload, Comparable {
  @JsonKey(ignore: true)
  final PdfPageFormat? pageFormat;

  final double labelWidth;
  final double labelHeight;

  int get rowCount =>
      pageFormat != null ? (maxWidthCm / labelWidth).truncate() : 0;

  int get columnCount =>
      pageFormat != null ? (maxHeightCm / labelHeight).truncate() : 0;

  double get maxWidthCm => pageFormat!.availableWidth / PdfPageFormat.cm;

  double get maxHeightCm => pageFormat!.availableHeight / PdfPageFormat.cm;

  int get totalLabelsAvaibleSpace => rowCount * columnCount;

  factory LabelFormat.count(
      {required PdfPageFormat pageFormat,
      int rowCount = 1,
      int columnCount = 1}) {
    return LabelFormat(
        pageFormat: pageFormat,
        labelWidth: (pageFormat.availableWidth / rowCount) / PdfPageFormat.cm,
        labelHeight:
            (pageFormat.availableHeight / columnCount) / PdfPageFormat.cm);
  }

  @override
  @JsonKey(ignore: true)
  final dynamic json;

  ///concretizzazione della classe astratta
  @override
  set json(json) => json = json;

  const LabelFormat({
    this.pageFormat,
    this.labelWidth = 10.5,
    this.labelHeight = 14,
    this.json,
  });

  factory LabelFormat.fromJson(Map<String, dynamic> json) {
    var result = _$LabelFormatFromJson(json);
    result = result.copyWith(json: json);
    return result;
  }

  Map<String, dynamic> toJson() => _$LabelFormatToJson(this);

  static LabelFormat fromJsonModel(Map<String, dynamic> json) =>
      LabelFormat.fromJson(json);

  /*
  @override
  String toString() {
    return '$description';
  }*/

  @override
  List<Object?> get props => [
        pageFormat,
        labelHeight,
        labelWidth,
      ];

  @override
  int compareTo(other) {
    if (other is LabelFormat) {
      return "$labelWidth$labelHeight$pageFormat".compareTo(
          "${other.labelWidth}${other.labelHeight}${other.pageFormat}");
    }
    return -1;
  }
}
