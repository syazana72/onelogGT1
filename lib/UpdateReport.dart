import 'package:afrv1/MainShowList.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:html' as html;

class UpdateReport extends StatelessWidget {
  final GetStorage box;
  UpdateReport(this.box);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Add new report (after)",
      home: _UpdateReport(box),
    );
  }
}

class _UpdateReport extends StatefulWidget {
  final GetStorage box;
  _UpdateReport(this.box);
  @override
  State<StatefulWidget> createState() {
    return ReportUpdate(box);
  }
}

class ReportUpdate extends State<_UpdateReport> {
  final GetStorage box;
  ReportUpdate(this.box);
  final _formKey = GlobalKey<FormState>();
  bool isFirstTimePhotoSelection = true;

  final box1 = GetStorage();

  List<html.File>? pickedFiles = [];
  UploadTask? uploadTask;
  TextEditingController problemDescriptionController = TextEditingController();
  TextEditingController groupController = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  final userName1Controller = TextEditingController();
  FirebaseFirestore firestore1 = FirebaseFirestore.instance;
  final userDateController = TextEditingController();
  String? selectedOption;

  Future uploadFiles() async {
    final path = 'after/';
    for (final file in pickedFiles!) {
      final date1 = userDateController.text;
      final group1 = groupController.text;
      final randomNumber = box.read('RandomNumber');
      final fileName = '$date1-$group1-$randomNumber.jpg';
      final ref = FirebaseStorage.instance.ref().child(path + fileName);
      setState(() {
        uploadTask = ref.putBlob(file);
      });
      final snapshot = await uploadTask!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      print('Download Link: $urlDownload');
      setState(() {
        box1.write('imageUrl1', urlDownload);
      });
    }

    setState(() {
      pickedFiles = null;
      uploadTask = null;
    });
  }

  void selectFile() {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      if (uploadInput.files!.isNotEmpty) {
        setState(() {
          isFirstTimePhotoSelection = false;
          pickedFiles = uploadInput.files;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MainShowList())),
        ),
        centerTitle: true,
        title: Text('Add New Report'),
        backgroundColor: Color(0xff091647),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Report Information Form (AFTER)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      color: Colors.black54,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Feedback photo : ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: selectFile,
                      child: Text(
                        isFirstTimePhotoSelection ? 'Add photo' : 'Change Photo',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff122a7e),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: problemDescriptionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.report_problem),
                    labelText: 'Countermeasure Taken',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '*Required';
                    }
                    return null;
                  },
                  maxLines: 2,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: userDateController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                    labelText: 'Report Date',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                      setState(() {
                        userDateController.text = formattedDate;
                        selectedOption = formattedDate;
                      });
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a report date';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: groupController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.groups),
                    labelText: 'PIC',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '*Required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: userName1Controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.person),
                    labelText: 'Name of Issuer',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    userName1Controller.text = value.toUpperCase(); // Convert input to capital letters
                    userName1Controller.selection = TextSelection.fromPosition(TextPosition(offset: userName1Controller.text.length)); // Maintain cursor position at the end
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '*Required';
                    }
                    if (value != value.toUpperCase()) {
                      return 'Please use capital letters only';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          bool isFirstTimePhotoSelection = pickedFiles == null || pickedFiles!.isEmpty;
                          if (_formKey.currentState!.validate() && !isFirstTimePhotoSelection) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Confirm submission"),
                                  content: Text("Are you sure you want to submit this report?"),
                                  actions: [
                                    TextButton(
                                      child: Text("CANCEL"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ElevatedButton(
                                      child: Text("SUBMIT"),
                                      onPressed: () {
                                        uploadFiles();
                                        saveReport();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (isFirstTimePhotoSelection) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please add a photo')),
                            );
                          }
                        },
                        child: Text('SUBMIT'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                          fixedSize: MaterialStateProperty.all<Size>(Size.fromHeight(50)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveReport() async {
    // Get the input values
    String countermeasureTaken = problemDescriptionController.text;
    String group = groupController.text;

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final userEmail = user?.email;

    // Create a new document in Firestore
    try {
      print(box.read('reportId'));
      await firestore1.collection('feedback').add({
        'DateAfter': userDateController.text,
        // 'Area': box1.read('Area'),
        'Email': userEmail,
        'countermeasureTaken': countermeasureTaken,
        'Area1': box.read('Area'),
        'PIC/ATTN1': box.read('PIC/ATTN'),
        'group': group,
        'RandomNumber1': box.read('RandomNumber'),
        'imageUrl1': box1.read('imageUrl1'),
        'reportID': box.read('reportID'),
        'Issuer Name(After)': userName1Controller.text,
      });
      // Show success message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Report submitted successfully"),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  // Navigate to the report list page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => MainShowList()),
                  );
                },
              ),
            ],
          );
        },
      );
    } catch (error) {
      print(error);
      // Show error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("An error occurred while submitting the report. Please try again."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
