import 'dart:html' as html;
import 'AddReportSG.dart';
import 'GuidelineSG.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'MainShowListSG.dart';

class ReportDetailSG extends StatelessWidget {
  final GetStorage box;
  const ReportDetailSG(this.box);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Add new report (before)",
      home: HomePagee(box),
    );
  }
}

class HomePagee extends StatefulWidget {
  final GetStorage box;
  const HomePagee(this.box);

  @override
  State<StatefulWidget> createState() {
    return _HomePage(box);
  }
}

class _HomePage extends State<HomePagee> {
  final _formKey = GlobalKey<FormState>();
  bool isFirstTimePhotoSelection = true;

  final GetStorage box;
  _HomePage(this.box);

  html.FileUploadInputElement? uploadInput;
  UploadTask? uploadTask;
  TextEditingController problemDescriptionController = TextEditingController();
  TextEditingController imageRemarksController = TextEditingController();
  TextEditingController groupController = TextEditingController();
  String selectedTheme = '';
  String selectedRank = '';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future uploadFiles() async {
    final path = 'beforeSG/';

    for (final html.File file in uploadInput!.files!) {
      final date = box.read('Date');
      final location = box.read('Location');
      final randomNumber = box.read('RandomNumber');
      final fileName = '$date-$location-$randomNumber.jpg'; // use unique ID and date in the filename
      final ref = FirebaseStorage.instance.ref().child(path + fileName);
      setState(() {
        uploadTask = ref.putBlob(file);
      });
      final snapshot = await uploadTask!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      print('Download Link: $urlDownload');
      setState(() {
        box.write('imageUrl', urlDownload);
      });
    }

    setState(() {
      uploadInput!.value = null;
      uploadTask = null;
    });
  }

  void selectFile() {
    uploadInput!.click();
  }

  @override
  void initState() {
    super.initState();
    uploadInput = html.FileUploadInputElement();
    uploadInput!.accept = 'image/*';
    uploadInput!.multiple = true;
    uploadInput!.style.display = 'none';
    uploadInput!.onChange.listen((e) {
      setState(() {
        isFirstTimePhotoSelection = false;
      });
    });
    html.document.body!.append(uploadInput!);
  }

  @override
  void dispose() {
    uploadInput!.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => AddReportSG())),
        ),
        centerTitle: true,
        title: Text('Add New Report'),
        actions: [
          IconButton(
            icon: Icon(Icons.question_mark_rounded, color: Colors.yellow),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => GuidelineSG()),
              );
            },
          ),
        ],
        backgroundColor: Colors.deepOrange[800],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              // Existing UI
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Report Information Form (DIVISION SAFETY PATROL)',
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
                          'Problem photo : ',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        Spacer(),
                        ElevatedButton(
                          onPressed: selectFile,
                          child: Text(
                            isFirstTimePhotoSelection
                                ? 'Add photo'
                                : 'Change Photo',
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
                        labelText: 'Potential risk',
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
                      controller: imageRemarksController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.image_search_sharp),
                        labelText: 'Hazard Finding [situation]',
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
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Icon(
                          Icons.category,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 20),
                        Text(
                          'Assessment Risk',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 0, 16.0, 0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'High',
                                  groupValue: selectedTheme,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedTheme = value!;
                                    });
                                  },
                                ),
                                Text('High'),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Medium',
                                  groupValue: selectedTheme,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedTheme = value!;
                                    });
                                  },
                                ),
                                Text('Medium'),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Low',
                                  groupValue: selectedTheme,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedTheme = value!;
                                    });
                                  },
                                ),
                                Text('Low'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(
                          Icons.grade_outlined,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 20),
                        Text(
                          'Rank',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 0, 16.0, 0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Rank A',
                                  groupValue: selectedRank,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedRank = value!;
                                    });
                                  },
                                ),
                                Text('Rank A'),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Rank B',
                                  groupValue: selectedRank,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedRank = value!;
                                    });
                                  },
                                ),
                                Text('Rank B'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              bool isAnyChecked = selectedTheme.isNotEmpty && selectedRank.isNotEmpty;
                              bool isFirstTimePhotoSelection = uploadInput!.files!
                                  .isEmpty;
                              if (_formKey.currentState!.validate() &&
                                  isAnyChecked && !isFirstTimePhotoSelection) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirm submission"),
                                      content: Text(
                                          "Are you sure you want to submit this report?"),
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
                              } else if (!isAnyChecked) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(
                                      'Please select one theme and rank')),
                                );
                              } else if (isFirstTimePhotoSelection) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Please add a photo')),
                                );
                              }
                            },
                            child: Text(' SUBMIT '),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blueAccent),
                              fixedSize: MaterialStateProperty.all<Size>(Size
                                  .fromHeight(50)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40), // Space between duplicated UIs
            ],
          ),
        ),
      ),
    );
  }

  void saveReport() {
    List<String> classification = [];
    List<String> rank = [];

    if (selectedTheme.isNotEmpty) {
      classification.add(selectedTheme);
    }

    if (selectedRank.isNotEmpty) {
      rank.add(selectedRank);
    }

    String problemDescription = problemDescriptionController.text;
    String imageRemarks = imageRemarksController.text;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final userEmail = user?.email;

    firestore.collection('reportsSG').add({
      'Date': box.read('Date'),
      'Time': box.read('Time'),
      'Inspected by': box.read('Inspected by'),
      'Location': box.read('Location'),
      'Theme': box.read('Theme'),
      'Email': userEmail,
      'Potential Risk': problemDescription,
      'Hazard Finding': imageRemarks,
      'Classification': selectedTheme,
      'rank': selectedRank,
      'imageUrl': box.read('imageUrl'),
      'RandomNumber': box.read('RandomNumber'),
      'reportID': box.read('reportID'),
      'Total Finding': box.read('Total Finding'),
    }).then((value) {
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => MainShowListSG()),
                  );
                },
              ),
            ],
          );
        },
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(
                "An error occurred while submitting the report. Please try again."),
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
    });
  }
}
