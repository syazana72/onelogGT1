import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

class ReportPageBEFORESG extends StatefulWidget {
  final Map<String, dynamic> reportData;

  ReportPageBEFORESG({required this.reportData});

  @override
  _ReportPageState1 createState() => _ReportPageState1();
}

class _ReportPageState1 extends State<ReportPageBEFORESG> {
  Future<String?> getImageData() async {
    try {
      final ref = FirebaseStorage.instance.ref();
      final imageURL = await ref
          .child(
          "beforeSG/${widget.reportData['Date']}-${widget.reportData['Location']}-${widget.reportData['RandomNumber']}.jpg")
          .getDownloadURL();
      print(imageURL);
      return imageURL;
    } catch (e) {
      print("Failed to get image data: $e");
      return null;
    }
  }

  Future<img.Image> resizeImage(String imageURL, int width, int height) async {
    final response = await http.get(Uri.parse(imageURL));
    final bytes = response.bodyBytes;
    final image = img.decodeImage(bytes);
    final resizedImage = img.copyResize(image!, width: width, height: height);
    return resizedImage;
  }

  @override
  Widget build(BuildContext context) {
    return PdfPreview(
      build: (format) => generateDocument(format),
    );
  }
  pw.Widget _buildCustomImageWithText(
      img.Image resizedImage, String hazardFinding) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Image(
          pw.MemoryImage(Uint8List.fromList(img.encodeJpg(resizedImage))),
          width: 50, // Adjust the width as needed
          height: 50, // Adjust the height as needed
        ),
        pw.SizedBox(width: 10), // Add some spacing between image and text
        pw.Text(hazardFinding),
      ],
    );
  }

  Future<Uint8List> generateDocument(PdfPageFormat format) async {
    final pdf = pw.Document();
    final fontRegular = await PdfGoogleFonts.openSansRegular();
    final fontBold = await PdfGoogleFonts.openSansBold();
    final ByteData bytes = await rootBundle.load('assets/images/perodua.png');
    final ByteData bytes3 = await rootBundle.load('assets/images/triangle.png');
    final ByteData bytes2 = await rootBundle.load('assets/images/circle.png');
    final Uint8List byteList3 = bytes3.buffer.asUint8List();
    final Uint8List byteList2 = bytes2.buffer.asUint8List();
    final Uint8List byteList = bytes.buffer.asUint8List();
    final imageData = await getImageData();
    final resizedImage = await resizeImage(imageData!, 75, 80);
   /* final tableHeaders = [
      'No',
      'Hazard Finding\n[situation]',
      'Potential risk\n[condition.action.effect]',
      'Rank',
      'Risk Assessment',
    ];

    final tableData = [
      [
        '1',
        pw.Container(
          child: _buildCustomImageWithText(
            resizedImage,
            widget.reportData['Hazard Finding'] as String? ?? '',
          ),
        ),
        '${widget.reportData['Potential Risk'] as String? ?? ''}',
        '${widget.reportData['rank'] as String? ?? ''}',
        '${widget.reportData['Classification'] as String? ?? ''}',
      ],
    ];*/

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          return <pw.Widget>[ pw.Container(
            // padding: pw.EdgeInsets.all(1),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Image(pw.MemoryImage(byteList), fit: pw.BoxFit.fitHeight, height: 31, width: 44),
                pw.SizedBox(width: 1 * PdfPageFormat.mm),
                pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children:[
                    pw.Text(
                      'Perodua Manufacturing Sdn Bhd \nPerodua Engine Manufacturing Sdn Bhd \nSHE Department',
                      style: pw.TextStyle(
                        fontSize: 9.0,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.Spacer(),
                pw.Column(
                    mainAxisSize: pw.MainAxisSize.min,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                          '\nCHECK SHEET rev B',
                          style: pw.TextStyle(
                            fontSize: 12.0,
                            fontWeight: pw.FontWeight.bold,
                          )
                      )
                    ]
                ),
              ],
            ),
          ),
            //    pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Divider(),
            //  pw.SizedBox(height: 1 * PdfPageFormat.mm),
            pw.Center(
              child: pw.Text(
                'DIVISION SAFETY PATROL',
                style: pw.TextStyle(
                  fontSize: 14.0,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            //   pw.Divider(),
            pw.SizedBox(height: 5),
            pw.Row(
                children:[
                  pw.Table.fromTextArray(
                    border: pw.TableBorder.all(),
                    headerAlignment: pw.Alignment.centerLeft,
                    cellAlignment: pw.Alignment.centerLeft,
                    headerStyle: pw.TextStyle(fontSize: 10),
                    cellStyle: pw.TextStyle(fontSize:10),
                    /*   columnWidths: const <int, pw.TableColumnWidth>{
                    0: pw.FlexColumnWidth(90.0),
                    1: pw.FlexColumnWidth(90.0),
                    2: pw.FlexColumnWidth(90.0),
                    3: pw.FlexColumnWidth(90.0),
                  },*/
                    data: <List<String>>[
                      ['  Location[shop/dept]: ${widget.reportData['Location'] as String? ?? ''}  '],
                      ['  Date: ${widget.reportData['Date'] as String? ?? ''}      '],
                      ['  Time: ${widget.reportData['Time'] as String? ?? ''}    '],
                      ['  Theme: ${widget.reportData['Theme'] as String? ?? ''}     '],
                    ],
                  ),
                  //   pw.SizedBox(height:5),
                  pw.Spacer(),
                  // pw.SizedBox(width: 80),
                  pw.Table.fromTextArray(
                    context: context,
                    data: <List<String>>[
                      <String>['Inspected by', 'Agreed by', 'Approved by'],
                      <String>['\n${widget.reportData['Inspected by'] as String? ?? ''}\n\n', '   \n\n ', '    \n\n '],
                      <String>['Finder', 'Supervisor Line', 'AM/MANAGER'],
                    ],
                    headerCount: 1,
                    headerAlignment: pw.Alignment.center,
                    cellAlignment: pw.Alignment.center,
                    headerStyle: pw.TextStyle(
                      fontSize: 8.0,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    cellStyle: pw.TextStyle(
                      fontSize: 8.0,
                    ),
                    columnWidths: <int, pw.TableColumnWidth>{
                      0: pw.FixedColumnWidth(70.0), // Width for Column 1
                      1: pw.FixedColumnWidth(70.0), // Width for Column 2
                      2: pw.FixedColumnWidth(70.0), // Width for Column 3
                    },
                  ),
                ]
            ),
            pw.SizedBox(height:5),
            pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Justification guideline:',
                  style: pw.TextStyle(
                    fontSize: 8.0,
                  ),
                ),
                pw.SizedBox(height: 2),
                pw.Table(
                  border: pw.TableBorder.all(width: 1, color: PdfColors.black),
                  children: [
                    pw.TableRow(children: [
                      pw.Text(' Justification', style: pw.TextStyle(fontSize: 8.0)),
                      pw.Text(' Severity', style: pw.TextStyle(fontSize: 8.0)),
                      pw.Text(' Completion', style: pw.TextStyle(fontSize: 8.0)),
                    ]),
                    pw.TableRow(children: [
                      pw.Text(' Rank A\n Rank B', style: pw.TextStyle(fontSize: 8.0)),
                      pw.Text(' Potential for serious injury of fatal OR not-comply act/regulation\n Potential minor injured, health issue, dangerous occurance and property damage', style: pw.TextStyle(fontSize: 8.0)),
                      pw.Text(' 1 day\n 10 days', style: pw.TextStyle(fontSize: 8.0)),
                    ]),
                  ],
                ),
              ],
            ),
            /* pw.SizedBox(height: 10),
                if (resizedImage != null)
                  pw.Image(
                    pw.MemoryImage(Uint8List.fromList(img.encodeJpg(resizedImage))),
                  ),
                pw.SizedBox(height: 10),*/
            pw.SizedBox(height:5),
            pw.Text(
              'A. Gemba Finding',
              style: pw.TextStyle(
                fontSize: 8.0, fontWeight: pw.FontWeight.bold,
              ),
            ),
        /*    pw.Table.fromTextArray(
              headers: tableHeaders,
              data: tableData,
              border: pw.TableBorder.all(width: 1, color: PdfColors.black),
              headerStyle: pw.TextStyle(fontSize:9.5, fontWeight: pw.FontWeight.bold),
              headerDecoration:
              const pw.BoxDecoration(color: PdfColors.grey300),
              // cellHeight: 30.0,
              cellStyle: pw.TextStyle(fontSize: 9.5),
              cellAlignments: {
                0: pw.Alignment.center,
                1: pw.Alignment.center,
                2: pw.Alignment.center,
                3: pw.Alignment.center,
                4: pw.Alignment.center,
              },
            ),*/
            pw.Table(
              border: pw.TableBorder.all(width: 1, color: PdfColors.black),
              children: [
                pw.TableRow(children: [
                  pw.Center(child: pw.Text('Hazard Finding\n[situation]', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.0))),
                  pw.Center(child: pw.Text('Potential Risk\n[condition.action.effect]', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.0))),
                  pw.Center(child: pw.Text('Risk Assessment\n[High/Medium/Low]', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.0))),
                  pw.Center(child: pw.Text('Rank', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.0))),
                ]),
                pw.TableRow(children: [
                  pw.Center(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Image(
                          pw.MemoryImage(Uint8List.fromList(img.encodeJpg(resizedImage))),
                        ),
                        pw.Center(child: pw.Text('${widget.reportData['Hazard Finding'] as String? ?? ''}', style: pw.TextStyle(fontSize: 9.0))),
                      ],
                    ),
                  ),
                  pw.Center(child: pw.Text('${widget.reportData['Potential Risk'] as String? ?? ''}', style: pw.TextStyle(fontSize: 10.0))),
                  pw.Center(child: pw.Text('${widget.reportData['Classification'] as String? ?? ''}', style: pw.TextStyle(fontSize: 10.0))),
                  pw.Center(child: pw.Text('${widget.reportData['rank'] as String? ?? ''}', style: pw.TextStyle(fontSize: 10.0))),
                ]),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Row(
          children: [
            pw.Table(
          border: pw.TableBorder.all(width: 1, color: PdfColors.black),
          children: [
          pw.TableRow(children: [
          pw.Center(child: pw.Text('  USA ', style: pw.TextStyle(fontSize: 8.0))),
          pw.Center(child: pw.Text(' empty space   ', style: pw.TextStyle(fontSize: 8.0, color: PdfColors.white ))),
          pw.Center(child: pw.Text('  Rank A  ', style: pw.TextStyle(fontSize: 8.0))),
          pw.Center(child: pw.Text('      ', style: pw.TextStyle(fontSize: 8.0))),
          ]),
            pw.TableRow(children: [
              pw.Center(child: pw.Text('  USC ', style: pw.TextStyle(fontSize: 8.0))),
              pw.Center(child: pw.Text('       ', style: pw.TextStyle(fontSize: 8.0))),
              pw.Center(child: pw.Text('  Rank B  ', style: pw.TextStyle(fontSize: 8.0))),
              pw.Center(child: pw.Text(' empty space   ', style: pw.TextStyle(fontSize: 8.0, color: PdfColors.white ))),
            ]),
            ]),
            pw.Spacer(),
            ]),
            pw.SizedBox(height:5),
            pw.Text(
              'B. Gemba skill [fill up SHE Coor/Safety Personnel]',
              style: pw.TextStyle(
                fontSize: 8.0, fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Row(
                children: [
                  pw.Table(
                      border: pw.TableBorder.all(width: 1, color: PdfColors.black),
                      children: [
                        pw.TableRow(children: [
                          pw.Center(child: pw.Text('  Finding ', style: pw.TextStyle(fontSize: 8.0))),
                          pw.Center(child: pw.Text(' Judgement ', style: pw.TextStyle(fontSize: 8.0))),
                        ]),
                        pw.TableRow(children: [
                          pw.Center(child: pw.Text('\n\n  >= 3 Items   \n\n ', style: pw.TextStyle(fontSize: 8.0))),
                          pw.Center(child: pw.Image(pw.MemoryImage(byteList2), fit: pw.BoxFit.fitHeight, height: 10, width: 10),),
                        ]),
                        pw.TableRow(children: [
                          pw.Center(child: pw.Text('\n\n  <= 2 Items   \n\n ', style: pw.TextStyle(fontSize: 8.0))),
                          pw.Center(child: pw.Image(pw.MemoryImage(byteList3), fit: pw.BoxFit.fitHeight, height: 10, width: 10),),
                        ]),
                      ]),
                  pw.Spacer(),
                ]),

          ];
        },
      ),
    );
    return pdf.save();
  }
}