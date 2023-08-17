import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void mainExcel() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase to Excel',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: FirebaseToExcelPage(),
    );
  }
}

class FirebaseToExcelPage extends StatefulWidget {
  @override
  _FirebaseToExcelPageState createState() => _FirebaseToExcelPageState();
}

class _FirebaseToExcelPageState extends State<FirebaseToExcelPage> {
  List<Map<String, dynamic>> collectionReportsData = [];
  List<Map<String, dynamic>> collectionFeedbackData = [];

  @override
  void initState() {
    super.initState();
    fetchFirestoreData();
  }

  void fetchFirestoreData() async {
    // Fetch data from collection1 in Firestore
    QuerySnapshot collection1Snapshot =
    await FirebaseFirestore.instance.collection('reports').get();
    setState(() {
      collectionReportsData = collection1Snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });

    // Fetch data from collection2 in Firestore
    QuerySnapshot collection2Snapshot =
    await FirebaseFirestore.instance.collection('feedback').get();
    setState(() {
      collectionFeedbackData = collection2Snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });

    // Export data to Excel
    await exportDataToExcel();
  }

  Future<void> exportDataToExcel() async {
    // Create a new Excel workbook
    var excel = Excel.createExcel();

    // Create a worksheet for collection1
    var collection1Sheet = excel['ReportBefore'];

    // Add headers to the collection1 worksheet
    collection1Sheet.appendRow(['Date', 'Area']);

    // Iterate over collection1 data and add it to the worksheet
    for (var i = 0; i < collectionReportsData.length; i++) {
      var document = collectionReportsData[i];
      collection1Sheet.appendRow([document['Date'], document['Area']]);
    }

    // Create a worksheet for collection2
    var collection2Sheet = excel['ReportFeedback'];

    // Add headers to the collection2 worksheet
    collection2Sheet.appendRow(['DateAfter', 'Area1']);

    // Iterate over collection2 data and add it to the worksheet
    for (var i = 0; i < collectionFeedbackData.length; i++) {
      var document = collectionFeedbackData[i];
      collection2Sheet.appendRow([document['DateAfter'], document['Area1']]);
    }

    // Get the directory for saving the Excel file
    Directory appDocumentsDirectory =
    await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;

// Save the Excel file
    var excelBytes = await excel.encode();
    await File('${appDocumentsPath}/firebase_data.xlsx')
        .writeAsBytes(excelBytes!);


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase to Excel'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

}
