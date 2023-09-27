import 'dart:typed_data';

import 'package:dpicenter/globals/system_global.dart';
import 'package:dpicenter/screen/widgets/print_qrcode/label_format.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_io/io.dart';

Future<pw.Document> createQrCodePdf(Uint8List qr1, Uint8List qr2,
    {String? label1, String? label2}) async {
  pw.Document pdf = pw.Document();

  pw.MemoryImage qrImage1 = pw.MemoryImage(
    qr1,
  );
  pw.MemoryImage qrImage2 = pw.MemoryImage(
    qr2,
  );

  pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4.copyWith(
          marginTop: 0.8 * PdfPageFormat.cm,
          marginBottom: 0.8 * PdfPageFormat.cm,
          marginLeft: 0,
          marginRight: 0),
      build: (pw.Context context) {
        return pw.Container(
            width: 21 * PdfPageFormat.cm,
            height: 28 * PdfPageFormat.cm,
            child: pw.Stack(alignment: pw.Alignment.topLeft, children: [
              pw.Container(
                  width: 10.5 * PdfPageFormat.cm,
                  height: 14 * PdfPageFormat.cm,
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    children: [
                      pw.SizedBox(
                          width: (10.5 / 2.5) * PdfPageFormat.cm,
                          height: (14 / 3) * PdfPageFormat.cm,
                          child: pw.Column(
                              mainAxisSize: pw.MainAxisSize.min,
                              children: [
                                pw.Image(qrImage1),
                                if (label1 != null)
                                  pw.SizedBox(height: 0.1 * PdfPageFormat.cm),
                                if (label1 != null)
                                  pw.Flexible(
                                    child: pw.Text(label1,
                                        style: const pw.TextStyle(fontSize: 8)),
                                  ),
                              ])),
                      pw.SizedBox(
                          width: (10.5 / 2.5) * PdfPageFormat.cm,
                          height: (14 / 3) * PdfPageFormat.cm,
                          child: pw.Column(
                              mainAxisSize: pw.MainAxisSize.min,
                              children: [
                                pw.Image(qrImage2),
                                if (label2 != null)
                                  pw.SizedBox(height: 0.1 * PdfPageFormat.cm),
                                if (label2 != null)
                                  pw.Flexible(
                                    child: pw.Text(label2,
                                        style: const pw.TextStyle(fontSize: 8)),
                                  ),
                              ])),
                    ],
                  ))
            ]));

        // Center
      }));

  return pdf;
}

Future<pw.Document> createQrCodePdf2(List<QrInfo> qrImages,
    {int repeatCount = 1, int startIndex = 1}) async {
  pw.Document pdf = pw.Document();

  PdfPageFormat pageFormat = PdfPageFormat.a4.copyWith(
      marginTop: 0.8 * PdfPageFormat.cm,
      marginBottom: 0.8 * PdfPageFormat.cm,
      marginLeft: 0,
      marginRight: 0);
  double maxWidthCm = pageFormat.availableWidth / PdfPageFormat.cm;
  double maxHeightCm = pageFormat.availableHeight / PdfPageFormat.cm;
  double labelWidth = 10.5;
  double labelHeight = 14;

  ///quante etichette ci stanno orizzontalmente
  int rowCount = (maxWidthCm / labelWidth).truncate();

  ///quante etichette ci stanno verticalmente
  int columnCount = (maxHeightCm / labelHeight).truncate();
  int currentIndex = 0;
  int totalLabelsAvaibleSpace = rowCount * columnCount;
  int totalPages = (repeatCount / totalLabelsAvaibleSpace).truncate() + 1;

  List<pw.MemoryImage> memoryImages = <pw.MemoryImage>[];
  for (QrInfo info in qrImages) {
    memoryImages.add(pw.MemoryImage(
      info.qrImage,
    ));
  }
  for (int currentPage = 0; currentPage < totalPages; currentPage++) {
    List<pw.Widget> children = <pw.Widget>[];
    for (int columnIndex = 0; columnIndex < columnCount; columnIndex++) {
      for (int rowIndex = 0; rowIndex < rowCount; rowIndex++) {
        if (currentIndex >= (startIndex - 1)) {
          print("add column${columnIndex}-row${rowIndex}");
          print("left: ${((rowIndex) * labelWidth)}");
          print("right: ${((rowIndex + 1) * labelWidth)}");
          print("top: ${((columnIndex) * labelHeight)}");
          print("bottom: ${((columnIndex + 1) * labelHeight)}");

          children.add(pw.Positioned.directional(
              textDirection: pw.TextDirection.ltr,
              start: ((rowIndex) * labelWidth) * PdfPageFormat.cm,
              top: ((columnIndex) * labelHeight) * PdfPageFormat.cm,
              child: pw.Container(
                  /*color: (currentIndex % 2 == 0) ? PdfColors.red : PdfColors.blue,*/
                  constraints: pw.BoxConstraints(
                      minWidth: labelWidth * PdfPageFormat.cm,
                      minHeight: labelHeight * PdfPageFormat.cm),
                  child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                          qrImages.length,
                          (index) => pw.Container(
                              width: (10.5 / 2.5) * PdfPageFormat.cm,
                              height: (14 / 3) * PdfPageFormat.cm,
                              child: pw.Column(
                                  mainAxisSize: pw.MainAxisSize.min,
                                  children: [
                                    pw.Image(memoryImages[index]),
                                    if (qrImages[index].label != null)
                                      pw.SizedBox(
                                          height: 0.1 * PdfPageFormat.cm),
                                    if (qrImages[index].label != null)
                                      pw.Flexible(
                                        child: pw.Text(qrImages[index].label!,
                                            style: const pw.TextStyle(
                                                fontSize: 8)),
                                      ),
                                  ])))))));
        }
        currentIndex++;
        if ((currentIndex - (startIndex - 1)) >= repeatCount) {
          break;
        }
      }

      if ((currentIndex - (startIndex - 1)) >= repeatCount) {
        break;
      }
    }
    pdf.addPage(pw.Page(
        pageFormat: pageFormat,
        build: (pw.Context context) {
          return pw.Container(
              /*color: PdfColors.yellow,*/
              width: 21 * PdfPageFormat.cm,
              height: 28 * PdfPageFormat.cm,
              child: pw.Stack(
                alignment: pw.Alignment.topLeft,
                fit: pw.StackFit.loose,
                children: children,
              ));
        }));
  }

  return pdf;
}

Future<pw.Document> createQrCodePdf3(
    {required List<QrInfo> qrImages,
    required LabelFormat labelFormat,
    int repeatCount = 1,
    int startIndex = 1}) async {
  pw.Document pdf = pw.Document();

  /*PdfPageFormat pageFormat = PdfPageFormat.a4.copyWith(
      marginTop: 0.8 * PdfPageFormat.cm,
      marginBottom: 0.8 * PdfPageFormat.cm,
      marginLeft: 0,
      marginRight: 0);*/
  /*double maxWidthCm = labelFormat.pageFormat!.availableWidth / PdfPageFormat.cm;
  double maxHeightCm= labelFormat.pageFormat!.availableHeight / PdfPageFormat.cm;*/

  /*double labelWidth=10.5;
  double labelHeight=14;*/

/*  ///quante etichette ci stanno orizzontalmente
  int rowCount=(labelFormat.maxWidthCm/labelFormat.labelWidth).truncate();
  ///quante etichette ci stanno verticalmente
  int columnCount= (labelFormat.maxHeightCm/labelFormat.labelHeight).truncate();*/
  int currentIndex = 0;
  //int totalLabelsAvaibleSpace=labelFormat.rowCount*labelFormat.columnCount;
  int totalPages =
      (repeatCount / labelFormat.totalLabelsAvaibleSpace).truncate() + 1;

  List<pw.MemoryImage> memoryImages = <pw.MemoryImage>[];
  for (QrInfo info in qrImages) {
    memoryImages.add(pw.MemoryImage(
      info.qrImage,
    ));
  }
  for (int currentPage = 0; currentPage < totalPages; currentPage++) {
    List<pw.Widget> children = <pw.Widget>[];
    for (int columnIndex = 0;
        columnIndex < labelFormat.columnCount;
        columnIndex++) {
      for (int rowIndex = 0; rowIndex < labelFormat.rowCount; rowIndex++) {
        if (currentIndex >= (startIndex - 1)) {
          print("add column${columnIndex}-row${rowIndex}");
          print("left: ${((rowIndex) * labelFormat.labelWidth)}");
          print("right: ${((rowIndex + 1) * labelFormat.labelWidth)}");
          print("top: ${((columnIndex) * labelFormat.labelHeight)}");
          print("bottom: ${((columnIndex + 1) * labelFormat.labelHeight)}");

          children.add(pw.Positioned.directional(
              textDirection: pw.TextDirection.ltr,
              start: ((rowIndex) * labelFormat.labelWidth) * PdfPageFormat.cm,
              top: ((columnIndex) * labelFormat.labelHeight) * PdfPageFormat.cm,
              child: pw.Container(
                  //color: (currentIndex % 2 == 0) ? PdfColors.red : PdfColors.blue,
                  constraints: pw.BoxConstraints(
                      minWidth: labelFormat.labelWidth * PdfPageFormat.cm,
                      minHeight: labelFormat.labelHeight * PdfPageFormat.cm),
                  child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      children: List.generate(qrImages.length, (index) {
                        print(
                            "width: ${(labelFormat.labelWidth) * PdfPageFormat.cm}, height: ${(labelFormat.labelHeight) * PdfPageFormat.cm} ");
                        double qrSize = 0;
                        pw.Axis direction = pw.Axis.vertical;

                        if (labelFormat.labelWidth <= labelFormat.labelHeight) {
                          direction = pw.Axis.vertical;
                          qrSize = (labelFormat.labelWidth) * PdfPageFormat.cm;
                        } else {
                          direction = pw.Axis.horizontal;
                          qrSize = (labelFormat.labelHeight) * PdfPageFormat.cm;
                        }

                        print("qrSize: ${qrSize}");

                        double containerHeight = (labelFormat.labelHeight /
                                (qrImages.length + 0.5)) *
                            PdfPageFormat.cm;

                        return pw.Container(
                            alignment: pw.Alignment.center,
                            width: (labelFormat.labelWidth) * PdfPageFormat.cm,
                            height: containerHeight,
                            child: pw.Column(
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                mainAxisSize: pw.MainAxisSize.min,
                                children: [
                                  pw.Image(memoryImages[index],
                                      width: qrSize / 4, height: qrSize / 4),
                                  if (qrImages[index].label != null)
                                    direction == pw.Axis.vertical
                                        ? pw.SizedBox(
                                            height: 0.1 * PdfPageFormat.cm)
                                        : pw.SizedBox(
                                            width: 0.1 * PdfPageFormat.cm),
                                  if (qrImages[index].label != null)
                                    pw.Flexible(
                                      child: pw.Text(qrImages[index].label!,
                                          style: pw.TextStyle(
                                              fontSize: qrSize < 80 ? 6 : 8)),
                                    ),
                                ]));
                      })))));
        }
        currentIndex++;
        if ((currentIndex - (startIndex - 1)) >= repeatCount) {
          break;
        }
      }

      if ((currentIndex - (startIndex - 1)) >= repeatCount) {
        break;
      }
    }
    pdf.addPage(pw.Page(
        pageFormat: labelFormat.pageFormat,
        build: (pw.Context context) {
          return pw.Container(
              //color: PdfColors.yellow,
              width: labelFormat.pageFormat!.width,
              height: labelFormat.pageFormat!.height,
              child: pw.Stack(
                alignment: pw.Alignment.topLeft,
                fit: pw.StackFit.loose,
                children: children,
              ));
        }));
    if ((currentIndex - (startIndex - 1)) >= repeatCount) {
      break;
    }
  }

  return pdf;
}

class QrInfo {
  final String? label;
  final Uint8List qrImage;

  const QrInfo({this.label, required this.qrImage});
}
