import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:image/image.dart' as img;

class ReportPage extends StatefulWidget {
  final Map<String, dynamic> feedbackData;

  ReportPage({required this.feedbackData});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  Future<String?> getImageData() async {
    try {
      final ref = FirebaseStorage.instance.ref();
      final imageURL = await ref
          .child(
          "after/${widget.feedbackData['DateAfter']}-${widget.feedbackData['group']}-${widget.feedbackData['RandomNumber1']}.jpg")
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

  Future<Uint8List> generateDocument(PdfPageFormat format) async {
    final pdf = pw.Document();
    final fontRegular = await PdfGoogleFonts.openSansRegular();
    final fontBold = await PdfGoogleFonts.openSansBold();
    final ByteData bytes = await rootBundle.load('assets/images/1logicsticswhite.jpeg');
    final Uint8List byteList = bytes.buffer.asUint8List();
    final imageData = await getImageData();
    final resizedImage = await resizeImage(imageData!, 500, 400); // Adjust the dimensions as per your requirements

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            padding: pw.EdgeInsets.all(16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                    child: pw.Image(pw.MemoryImage(byteList), fit: pw.BoxFit.fitHeight, height: 60, width: 60)

                ),
                pw.Center(
                  child: pw.Text(
                    'ABNORMALITY FINDING GT REPORT (AFTER)',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  border: pw.TableBorder.all(),
                  headerAlignment: pw.Alignment.centerLeft,
                  cellAlignment: pw.Alignment.centerLeft,
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  cellStyle: const pw.TextStyle(),
                  columnWidths: const <int, pw.TableColumnWidth>{
                    0: pw.FlexColumnWidth(),
                    1: pw.FlexColumnWidth(),
                  },
                  data: <List<String>>[
                    ['Date: ${widget.feedbackData['DateAfter'] as String? ?? ''}'],
                    ['Area: ${widget.feedbackData['Area1'] as String? ?? ''}'],
                    ['PIC: ${widget.feedbackData['group'] as String? ?? ''}'],
                  ],
                ),
                pw.SizedBox(height: 10),
                if (resizedImage != null)
                  pw.Image(
                    pw.MemoryImage(Uint8List.fromList(img.encodeJpg(resizedImage))),
                  ),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  border: pw.TableBorder.all(),
                  headerAlignment: pw.Alignment.centerLeft,
                  cellAlignment: pw.Alignment.centerLeft,
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  cellStyle: const pw.TextStyle(),
                  columnWidths: const <int, pw.TableColumnWidth>{
                    0: pw.FlexColumnWidth(),
                    1: pw.FlexColumnWidth(),
                  },
                  data: <List<String>>[
                    ['Countermeasure Taken', '${widget.feedbackData['countermeasureTaken'] as String? ?? ''}'],
                  ],
                ),
                pw.SizedBox(height: 10),

                pw.Text(
                  'Issued By',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Name: ${widget.feedbackData['Issuer Name(After)'] as String? ?? ''}',
                  style: pw.TextStyle(fontSize: 16),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  'Email: ${widget.feedbackData['Email'] as String? ?? ''}',
                  style: pw.TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }
}
