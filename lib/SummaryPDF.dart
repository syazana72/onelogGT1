import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:image/image.dart' as img;
import 'package:afrv1/MainPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DocumentCountPage extends StatefulWidget {
  @override
  _DocumentCountPageState createState() => _DocumentCountPageState();
}

class _DocumentCountPageState extends State<DocumentCountPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue, // Adjust the color to match your app's theme
            accentColor: Colors.blue, // Adjust the color to match your app's theme
            colorScheme: ColorScheme.light(primary: Colors.blue), // Adjust the color to match your app's theme
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary), // Adjust the color to match your app's theme
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/ffdb7b09281029297629c7caa5123458.png'), // Replace 'assets/background_image.jpg' with your image path
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        /*   appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MainPage())),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Text(
                  DateFormat('MMMM yyyy').format(selectedDate),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),*/
        appBar:AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MainPage())),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent, // Set the app bar background color to transparent
          title: Text('Summary GT Findings'),
        ),
        backgroundColor: Colors.transparent, // Set the scaffold background color to transparent
        body: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('reports').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final reportsCount = snapshot.data?.size ?? 0;

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Icon(Icons.rectangle_rounded, color: Colors.yellow),
                          SizedBox(width: 8),
                          Text(
                            'TOTAL FINDING : $reportsCount',
                            style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //  SizedBox(height: 10),
                  /*    Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Selected Date:',
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: Text(
                        DateFormat('yyyy-MM-dd').format(selectedDate),
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),*/
                  Center(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: firestore.collection('feedback').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        final feedbackCount = snapshot.data?.size ?? 0;
                        final pendingCount = reportsCount - feedbackCount;

                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.rectangle_rounded, color: Colors.green),
                                SizedBox(width: 8),
                                Text(
                                  'CLOSED : $feedbackCount',
                                  style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 10),
                                Icon(Icons.rectangle_rounded, color: Colors.redAccent),
                                SizedBox(width: 8),
                                Text(
                                  'PENDING : $pendingCount',
                                  style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 16),
                  Table(
                    border: TableBorder.all(color: Colors.white),
                    columnWidths: {
                      0: FlexColumnWidth(2.5), // Adjust the value to increase or decrease the width
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'PIC/ATTN',
                                style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.rectangle_rounded, color: Colors.yellow),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.rectangle_rounded, color: Colors.green),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.rectangle_rounded, color: Colors.redAccent),
                              /*child: Text(
                                'PENDING',
                                style: TextStyle(fontSize: 15, color: Colors.redAccent, fontWeight: FontWeight.bold),
                              ),*/
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    color: Colors.grey.shade400, // Set your desired background color here
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Text(
                                        'CKD KR',
                                        style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '  - SAHPARIN',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('reports').where(FieldPath(['PIC/ATTN']), isEqualTo: 'CKD KR - SAHPARIN').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.yellow, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('feedback').where(FieldPath(['PIC/ATTN1']), isEqualTo: 'CKD KR - SAHPARIN').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('reports')
                                        .where(FieldPath(['PIC/ATTN']), isEqualTo: 'LG SUPPLY ASSY - MOHAMMAD FITRI')
                                        .snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
                                      if (snapshot1.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot1.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot1.error}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      } else {
                                        // Calculate the document count and display it in the second column
                                        int documentCount = snapshot1.data!.docs.length;
                                        return StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('feedback')
                                              .where(FieldPath(['PIC/ATTN1']), isEqualTo: 'LG SUPPLY ASSY - MOHAMMAD FITRI')
                                              .snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                                            if (snapshot2.connectionState == ConnectionState.waiting) {
                                              // Display a loading indicator while fetching the document count
                                              return CircularProgressIndicator();
                                            } else if (snapshot2.hasError) {
                                              // Display an error message if fetching the document count encounters an error
                                              return Text(
                                                'Error: ${snapshot2.error}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            } else {
                                              // Calculate the document count and display it in the second column
                                              int documentFeedback = snapshot2.data!.docs.length;
                                              int totalPending = documentCount - documentFeedback;
                                              return Text(
                                                '$totalPending',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    color: Colors.grey.shade400, // Set your desired background color here
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Text(
                                        'CKD TLS',
                                        style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '  - MOHD NADZRI',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '  - AZAIMI',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('reports').where(FieldPath(['PIC/ATTN']), isEqualTo: 'CKD TLS - MOHD NADZRI').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.yellow, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 8), // Add spacing between the two lines
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('reports').where(FieldPath(['PIC/ATTN']), isEqualTo: 'CKD TLS - AZAIMI').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.yellow, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('feedback').where(FieldPath(['PIC/ATTN1']), isEqualTo: 'CKD TLS - MOHD NADZRI').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 8), // Add spacing between the two lines
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('feedback').where(FieldPath(['PIC/ATTN1']), isEqualTo: 'CKD TLS - AZAIMI').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('reports')
                                        .where(FieldPath(['PIC/ATTN']), isEqualTo: 'CKD TLS - MOHD NADZRI')
                                        .snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
                                      if (snapshot1.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot1.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot1.error}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      } else {
                                        // Calculate the document count and display it in the second column
                                        int documentCount = snapshot1.data!.docs.length;
                                        return StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('feedback')
                                              .where(FieldPath(['PIC/ATTN1']), isEqualTo: 'CKD TLS - MOHD NADZRI')
                                              .snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                                            if (snapshot2.connectionState == ConnectionState.waiting) {
                                              // Display a loading indicator while fetching the document count
                                              return CircularProgressIndicator();
                                            } else if (snapshot2.hasError) {
                                              // Display an error message if fetching the document count encounters an error
                                              return Text(
                                                'Error: ${snapshot2.error}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            } else {
                                              // Calculate the document count and display it in the second column
                                              int documentFeedback = snapshot2.data!.docs.length;
                                              int totalPending = documentCount - documentFeedback;
                                              return Text(
                                                '$totalPending',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('reports')
                                        .where(FieldPath(['PIC/ATTN']), isEqualTo: 'CKD TLS - AZAIMI')
                                        .snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
                                      if (snapshot1.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot1.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot1.error}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      } else {
                                        // Calculate the document count and display it in the second column
                                        int documentCount = snapshot1.data!.docs.length;
                                        return StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('feedback')
                                              .where(FieldPath(['PIC/ATTN1']), isEqualTo: 'CKD TLS - AZAIMI')
                                              .snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                                            if (snapshot2.connectionState == ConnectionState.waiting) {
                                              // Display a loading indicator while fetching the document count
                                              return CircularProgressIndicator();
                                            } else if (snapshot2.hasError) {
                                              // Display an error message if fetching the document count encounters an error
                                              return Text(
                                                'Error: ${snapshot2.error}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            } else {
                                              // Calculate the document count and display it in the second column
                                              int documentFeedback = snapshot2.data!.docs.length;
                                              int totalPending = documentCount - documentFeedback;
                                              return Text(
                                                '$totalPending',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      }
                                    },
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    color: Colors.grey.shade400, // Set your desired background color here
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Text(
                                        'LG BODY',
                                        style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '  - ASNARI',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '  - MOHD HAFIZAN',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('reports').where(FieldPath(['PIC/ATTN']), isEqualTo: 'LG RECEIVING ASSY - MOHD YUTI').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.yellow, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 8), // Add spacing between the two lines
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('reports').where(FieldPath(['PIC/ATTN']), isEqualTo: 'LG BODY - MOHD HAFIZAN').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.yellow, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('feedback').where(FieldPath(['PIC/ATTN1']), isEqualTo: 'LG BODY - ASNARI').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 8), // Add spacing between the two lines
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('feedback').where(FieldPath(['PIC/ATTN1']), isEqualTo: 'LG BODY - MOHD HAFIZAN').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('reports')
                                        .where(FieldPath(['PIC/ATTN']), isEqualTo: 'LG BODY - ASNARI')
                                        .snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
                                      if (snapshot1.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot1.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot1.error}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      } else {
                                        // Calculate the document count and display it in the second column
                                        int documentCount = snapshot1.data!.docs.length;
                                        return StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('feedback')
                                              .where(FieldPath(['PIC/ATTN1']), isEqualTo: 'LG BODY - ASNARI')
                                              .snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                                            if (snapshot2.connectionState == ConnectionState.waiting) {
                                              // Display a loading indicator while fetching the document count
                                              return CircularProgressIndicator();
                                            } else if (snapshot2.hasError) {
                                              // Display an error message if fetching the document count encounters an error
                                              return Text(
                                                'Error: ${snapshot2.error}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            } else {
                                              // Calculate the document count and display it in the second column
                                              int documentFeedback = snapshot2.data!.docs.length;
                                              int totalPending = documentCount - documentFeedback;
                                              return Text(
                                                '$totalPending',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('reports')
                                        .where(FieldPath(['PIC/ATTN']), isEqualTo: 'LG BODY - MOHD HAFIZAN')
                                        .snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
                                      if (snapshot1.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot1.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot1.error}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      } else {
                                        // Calculate the document count and display it in the second column
                                        int documentCount = snapshot1.data!.docs.length;
                                        return StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('feedback')
                                              .where(FieldPath(['PIC/ATTN1']), isEqualTo: 'LG BODY - MOHD HAFIZAN')
                                              .snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                                            if (snapshot2.connectionState == ConnectionState.waiting) {
                                              // Display a loading indicator while fetching the document count
                                              return CircularProgressIndicator();
                                            } else if (snapshot2.hasError) {
                                              // Display an error message if fetching the document count encounters an error
                                              return Text(
                                                'Error: ${snapshot2.error}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            } else {
                                              // Calculate the document count and display it in the second column
                                              int documentFeedback = snapshot2.data!.docs.length;
                                              int totalPending = documentCount - documentFeedback;
                                              return Text(
                                                '$totalPending',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      }
                                    },
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    color: Colors.grey.shade400, // Set your desired background color here
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Text(
                                        'LG CKD',
                                        style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '  - MOHD AZIMI',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '  - SYAHRIZAL',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('reports').where(FieldPath(['PIC/ATTN']), isEqualTo: 'LG CKD - MOHD AZIMI').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.yellow, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 8), // Add spacing between the two lines
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('reports').where(FieldPath(['PIC/ATTN']), isEqualTo: 'LG CKD - SYAHRIZAL').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.yellow, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('feedback').where(FieldPath(['PIC/ATTN1']), isEqualTo: 'LG CKD - MOHD AZIMI').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 8), // Add spacing between the two lines
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('feedback').where(FieldPath(['PIC/ATTN1']), isEqualTo: 'LG CKD - SYAHRIZAL').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('reports')
                                        .where(FieldPath(['PIC/ATTN']), isEqualTo: 'LG CKD - MOHD AZIMI')
                                        .snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
                                      if (snapshot1.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot1.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot1.error}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      } else {
                                        // Calculate the document count and display it in the second column
                                        int documentCount = snapshot1.data!.docs.length;
                                        return StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('feedback')
                                              .where(FieldPath(['PIC/ATTN1']), isEqualTo: 'LG CKD - MOHD AZIMI')
                                              .snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                                            if (snapshot2.connectionState == ConnectionState.waiting) {
                                              // Display a loading indicator while fetching the document count
                                              return CircularProgressIndicator();
                                            } else if (snapshot2.hasError) {
                                              // Display an error message if fetching the document count encounters an error
                                              return Text(
                                                'Error: ${snapshot2.error}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            } else {
                                              // Calculate the document count and display it in the second column
                                              int documentFeedback = snapshot2.data!.docs.length;
                                              int totalPending = documentCount - documentFeedback;
                                              return Text(
                                                '$totalPending',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('reports')
                                        .where(FieldPath(['PIC/ATTN']), isEqualTo: 'LG CKD - SYAHRIZAL')
                                        .snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
                                      if (snapshot1.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot1.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot1.error}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      } else {
                                        // Calculate the document count and display it in the second column
                                        int documentCount = snapshot1.data!.docs.length;
                                        return StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('feedback')
                                              .where(FieldPath(['PIC/ATTN1']), isEqualTo: 'LG CKD - SYAHRIZAL')
                                              .snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                                            if (snapshot2.connectionState == ConnectionState.waiting) {
                                              // Display a loading indicator while fetching the document count
                                              return CircularProgressIndicator();
                                            } else if (snapshot2.hasError) {
                                              // Display an error message if fetching the document count encounters an error
                                              return Text(
                                                'Error: ${snapshot2.error}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            } else {
                                              // Calculate the document count and display it in the second column
                                              int documentFeedback = snapshot2.data!.docs.length;
                                              int totalPending = documentCount - documentFeedback;
                                              return Text(
                                                '$totalPending',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      }
                                    },
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    color: Colors.grey.shade400, // Set your desired background color here
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Text(
                                        'LG CMK',
                                        style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '  - FAIZAL',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '  - AZLAN',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('reports').where(FieldPath(['PIC/ATTN']), isEqualTo: 'LG CMK - FAIZAL').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.yellow, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 8), // Add spacing between the two lines
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('reports').where(FieldPath(['PIC/ATTN']), isEqualTo: 'LG CMK - AZLAN').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.yellow, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('feedback').where(FieldPath(['PIC/ATTN1']), isEqualTo: 'LG CMK - FAIZAL').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 8), // Add spacing between the two lines
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('feedback').where(FieldPath(['PIC/ATTN1']), isEqualTo: 'LG CMK - AZLAN').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('reports')
                                        .where(FieldPath(['PIC/ATTN']), isEqualTo: 'LG CMK - FAIZAL')
                                        .snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
                                      if (snapshot1.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot1.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot1.error}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      } else {
                                        // Calculate the document count and display it in the second column
                                        int documentCount = snapshot1.data!.docs.length;
                                        return StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('feedback')
                                              .where(FieldPath(['PIC/ATTN1']), isEqualTo: 'LG CMK - FAIZAL')
                                              .snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                                            if (snapshot2.connectionState == ConnectionState.waiting) {
                                              // Display a loading indicator while fetching the document count
                                              return CircularProgressIndicator();
                                            } else if (snapshot2.hasError) {
                                              // Display an error message if fetching the document count encounters an error
                                              return Text(
                                                'Error: ${snapshot2.error}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            } else {
                                              // Calculate the document count and display it in the second column
                                              int documentFeedback = snapshot2.data!.docs.length;
                                              int totalPending = documentCount - documentFeedback;
                                              return Text(
                                                '$totalPending',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('reports')
                                        .where(FieldPath(['PIC/ATTN']), isEqualTo: 'LG CMK - AZLAN')
                                        .snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
                                      if (snapshot1.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot1.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot1.error}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      } else {
                                        // Calculate the document count and display it in the second column
                                        int documentCount = snapshot1.data!.docs.length;
                                        return StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('feedback')
                                              .where(FieldPath(['PIC/ATTN1']), isEqualTo: 'LG CMK - AZLAN')
                                              .snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                                            if (snapshot2.connectionState == ConnectionState.waiting) {
                                              // Display a loading indicator while fetching the document count
                                              return CircularProgressIndicator();
                                            } else if (snapshot2.hasError) {
                                              // Display an error message if fetching the document count encounters an error
                                              return Text(
                                                'Error: ${snapshot2.error}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            } else {
                                              // Calculate the document count and display it in the second column
                                              int documentFeedback = snapshot2.data!.docs.length;
                                              int totalPending = documentCount - documentFeedback;
                                              return Text(
                                                '$totalPending',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      }
                                    },
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    color: Colors.grey.shade400, // Set your desired background color here
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Text(
                                        'LG RECEIVING',
                                        style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '  - MOHD YUTI',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '  - AZMAN',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('reports').where(FieldPath(['PIC/ATTN']), isEqualTo: 'LG RECEIVING - MOHD YUTI').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.yellow, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 8), // Add spacing between the two lines
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('reports').where(FieldPath(['PIC/ATTN']), isEqualTo: 'LG RECEIVING - AZMAN').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.yellow, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('feedback').where(FieldPath(['PIC/ATTN1']), isEqualTo: 'LG RECEIVING - MOHD YUTI').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 8), // Add spacing between the two lines
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('feedback').where(FieldPath(['PIC/ATTN1']), isEqualTo: 'LG RECEIVING - AZMAN').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('reports')
                                        .where(FieldPath(['PIC/ATTN']), isEqualTo: 'LG RECEIVING - MOHD YUTI')
                                        .snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
                                      if (snapshot1.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot1.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot1.error}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      } else {
                                        // Calculate the document count and display it in the second column
                                        int documentCount = snapshot1.data!.docs.length;
                                        return StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('feedback')
                                              .where(FieldPath(['PIC/ATTN1']), isEqualTo: 'LG RECEIVING - MOHD YUTI')
                                              .snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                                            if (snapshot2.connectionState == ConnectionState.waiting) {
                                              // Display a loading indicator while fetching the document count
                                              return CircularProgressIndicator();
                                            } else if (snapshot2.hasError) {
                                              // Display an error message if fetching the document count encounters an error
                                              return Text(
                                                'Error: ${snapshot2.error}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            } else {
                                              // Calculate the document count and display it in the second column
                                              int documentFeedback = snapshot2.data!.docs.length;
                                              int totalPending = documentCount - documentFeedback;
                                              return Text(
                                                '$totalPending',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('reports')
                                        .where(FieldPath(['PIC/ATTN']), isEqualTo: 'LG RECEIVING - AZMAN')
                                        .snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
                                      if (snapshot1.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot1.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot1.error}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      } else {
                                        // Calculate the document count and display it in the second column
                                        int documentCount = snapshot1.data!.docs.length;
                                        return StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('feedback')
                                              .where(FieldPath(['PIC/ATTN1']), isEqualTo: 'LG RECEIVING - AZMAN')
                                              .snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                                            if (snapshot2.connectionState == ConnectionState.waiting) {
                                              // Display a loading indicator while fetching the document count
                                              return CircularProgressIndicator();
                                            } else if (snapshot2.hasError) {
                                              // Display an error message if fetching the document count encounters an error
                                              return Text(
                                                'Error: ${snapshot2.error}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            } else {
                                              // Calculate the document count and display it in the second column
                                              int documentFeedback = snapshot2.data!.docs.length;
                                              int totalPending = documentCount - documentFeedback;
                                              return Text(
                                                '$totalPending',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      }
                                    },
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    color: Colors.grey.shade400, // Set your desired background color here
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Text(
                                        'LG STORE ASSY',
                                        style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '  - MOHD AZWAN',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '  - SARUDIN',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('reports').where(FieldPath(['PIC/ATTN']), isEqualTo: 'LG STORE ASSY - MOHD AZWAN').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.yellow, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 8), // Add spacing between the two lines
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('reports').where(FieldPath(['PIC/ATTN']), isEqualTo: 'LG STORE ASSY - SARUDIN').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.yellow, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('feedback').where(FieldPath(['PIC/ATTN1']), isEqualTo: 'LG STORE ASSY - MOHD AZWAN').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 8), // Add spacing between the two lines
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('feedback').where(FieldPath(['PIC/ATTN1']), isEqualTo: 'LG STORE ASSY - SARUDIN').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('reports')
                                        .where(FieldPath(['PIC/ATTN']), isEqualTo: 'LG STORE ASSY - MOHD AZWAN')
                                        .snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
                                      if (snapshot1.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot1.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot1.error}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      } else {
                                        // Calculate the document count and display it in the second column
                                        int documentCount = snapshot1.data!.docs.length;
                                        return StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('feedback')
                                              .where(FieldPath(['PIC/ATTN1']), isEqualTo: 'LG STORE ASSY - MOHD AZWAN')
                                              .snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                                            if (snapshot2.connectionState == ConnectionState.waiting) {
                                              // Display a loading indicator while fetching the document count
                                              return CircularProgressIndicator();
                                            } else if (snapshot2.hasError) {
                                              // Display an error message if fetching the document count encounters an error
                                              return Text(
                                                'Error: ${snapshot2.error}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            } else {
                                              // Calculate the document count and display it in the second column
                                              int documentFeedback = snapshot2.data!.docs.length;
                                              int totalPending = documentCount - documentFeedback;
                                              return Text(
                                                '$totalPending',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('reports')
                                        .where(FieldPath(['PIC/ATTN']), isEqualTo: 'LG STORE ASSY - SARUDIN')
                                        .snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
                                      if (snapshot1.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot1.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot1.error}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      } else {
                                        // Calculate the document count and display it in the second column
                                        int documentCount = snapshot1.data!.docs.length;
                                        return StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('feedback')
                                              .where(FieldPath(['PIC/ATTN1']), isEqualTo: 'LG STORE ASSY - SARUDIN')
                                              .snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                                            if (snapshot2.connectionState == ConnectionState.waiting) {
                                              // Display a loading indicator while fetching the document count
                                              return CircularProgressIndicator();
                                            } else if (snapshot2.hasError) {
                                              // Display an error message if fetching the document count encounters an error
                                              return Text(
                                                'Error: ${snapshot2.error}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            } else {
                                              // Calculate the document count and display it in the second column
                                              int documentFeedback = snapshot2.data!.docs.length;
                                              int totalPending = documentCount - documentFeedback;
                                              return Text(
                                                '$totalPending',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    color: Colors.grey.shade400, // Set your desired background color here
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Text(
                                        'LG SUPPLY ASSY',
                                        style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '  - MOHAMMAD FITRI',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '  - AHMAD NURZUHAIR',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('reports').where(FieldPath(['PIC/ATTN']), isEqualTo: 'LG SUPPLY ASSY - MOHAMMAD FITRI').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.yellow, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 8), // Add spacing between the two lines
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('reports').where(FieldPath(['PIC/ATTN']), isEqualTo: 'LG SUPPLY ASSY - AHMAD NURZUHAIR').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.yellow, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('feedback').where(FieldPath(['PIC/ATTN1']), isEqualTo: 'LG SUPPLY ASSY - MOHAMMAD FITRI').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 8), // Add spacing between the two lines
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection('feedback').where(FieldPath(['PIC/ATTN1']), isEqualTo: 'LG SUPPLY ASSY - AHMAD NURZUHAIR').snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot.error}',
                                          style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        // Calculate the document count and display it
                                        int documentCount = snapshot.data!.docs.length;
                                        return Text(
                                          '$documentCount',
                                          style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('reports')
                                        .where(FieldPath(['PIC/ATTN']), isEqualTo: 'LG SUPPLY ASSY - MOHAMMAD FITRI')
                                        .snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
                                      if (snapshot1.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot1.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot1.error}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      } else {
                                        // Calculate the document count and display it in the second column
                                        int documentCount = snapshot1.data!.docs.length;
                                        return StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('feedback')
                                              .where(FieldPath(['PIC/ATTN1']), isEqualTo: 'LG SUPPLY ASSY - MOHAMMAD FITRI')
                                              .snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                                            if (snapshot2.connectionState == ConnectionState.waiting) {
                                              // Display a loading indicator while fetching the document count
                                              return CircularProgressIndicator();
                                            } else if (snapshot2.hasError) {
                                              // Display an error message if fetching the document count encounters an error
                                              return Text(
                                                'Error: ${snapshot2.error}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            } else {
                                              // Calculate the document count and display it in the second column
                                              int documentFeedback = snapshot2.data!.docs.length;
                                              int totalPending = documentCount - documentFeedback;
                                              return Text(
                                                '$totalPending',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('reports')
                                        .where(FieldPath(['PIC/ATTN']), isEqualTo: 'LG SUPPLY ASSY - AHMAD NURZUHAIR')
                                        .snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
                                      if (snapshot1.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while fetching the document count
                                        return CircularProgressIndicator();
                                      } else if (snapshot1.hasError) {
                                        // Display an error message if fetching the document count encounters an error
                                        return Text(
                                          'Error: ${snapshot1.error}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      } else {
                                        // Calculate the document count and display it in the second column
                                        int documentCount = snapshot1.data!.docs.length;
                                        return StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('feedback')
                                              .where(FieldPath(['PIC/ATTN1']), isEqualTo: 'LG SUPPLY ASSY - AHMAD NURZUHAIR')
                                              .snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                                            if (snapshot2.connectionState == ConnectionState.waiting) {
                                              // Display a loading indicator while fetching the document count
                                              return CircularProgressIndicator();
                                            } else if (snapshot2.hasError) {
                                              // Display an error message if fetching the document count encounters an error
                                              return Text(
                                                'Error: ${snapshot2.error}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            } else {
                                              // Calculate the document count and display it in the second column
                                              int documentFeedback = snapshot2.data!.docs.length;
                                              int totalPending = documentCount - documentFeedback;
                                              return Text(
                                                '$totalPending',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      }
                                    },
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => MainPage()),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.amberAccent),
                      ),
                      child: Text(
                        'Get Report',
                        style: TextStyle(
                          color: Colors.black, // Set the text color to black
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
