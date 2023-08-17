import 'dart:html' as html;
import 'package:afrv1/AddReport.dart';
import 'package:afrv1/MainShowList.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class ReportDetail extends StatelessWidget {
  final GetStorage box;
  const ReportDetail(this.box);
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
  List<bool> checkBoxState = [false, false, false, false];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future uploadFiles() async {
    final path = 'before/';

    for (final html.File file in uploadInput!.files!) {
      final date = box.read('Date');
      final area = box.read('Area');
      final randomNumber = box.read('RandomNumber');
      final fileName = '$date-$area-$randomNumber.jpg'; // use unique ID and date in the filename
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
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddReport())),
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
                  'Report Information Form (BEFORE)',
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
                    labelText: 'Problem Description',
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
                    icon: Icon(Icons.image),
                    labelText: 'Image Remarks',
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
                      'Category',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
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
                            Checkbox(
                              value: checkBoxState[0],
                              onChanged: (value) {
                                setState(() {
                                  checkBoxState[0] = value!;
                                });
                              },
                            ),
                            Text('SOP/RULE'),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: checkBoxState[1],
                              onChanged: (value) {
                                setState(() {
                                  checkBoxState[1] = value!;
                                });
                              },
                            ),
                            Text('SAFETY'),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: checkBoxState[2],
                              onChanged: (value) {
                                setState(() {
                                  checkBoxState[2] = value!;
                                });
                              },
                            ),
                            Text('2S'),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: checkBoxState[3],
                              onChanged: (value) {
                                setState(() {
                                  checkBoxState[3] = value!;
                                });
                              },
                            ),
                            Text('OTHERS'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: groupController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.groups),
                    labelText: 'Group',
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
                SizedBox(height: 40),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          bool isAnyChecked = checkBoxState.contains(true);
                          bool isFirstTimePhotoSelection = uploadInput!.files!.isEmpty;
                          if (_formKey.currentState!.validate() && isAnyChecked && !isFirstTimePhotoSelection) {
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
                          } else if (!isAnyChecked) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please select at least one category')),
                            );
                          } else if (isFirstTimePhotoSelection) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please add a photo')),
                            );
                          }
                        },
                        child: Text(' SUBMIT '),
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

  void saveReport() {
    List<String> categories = [];
    for (int i = 0; i < checkBoxState.length; i++) {
      if (checkBoxState[i]) {
        switch (i) {
          case 0:
            categories.add('SOP/RULE');
            break;
          case 1:
            categories.add('SAFETY');
            break;
          case 2:
            categories.add('2S');
            break;
          case 3:
            categories.add('OTHERS');
            break;
        }
      }
    }

    String problemDescription = problemDescriptionController.text;
    String imageRemarks = imageRemarksController.text;
    String group = groupController.text;

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final userEmail = user?.email;

    firestore.collection('reports').add({
      'Date': box.read('Date'),
      'Area': box.read('Area'),
      'Issuer Name': box.read('Issuer Name'),
      'PIC/ATTN': box.read('PIC/ATTN'),
      'Shift': box.read('Shift'),
      'Email': userEmail,
      'problemDescription': problemDescription,
      'imageRemarks': imageRemarks,
      'categories': categories,
      'group': group,
      'imageUrl': box.read('imageUrl'),
      'RandomNumber': box.read('RandomNumber'),
      'reportID': box.read('reportID'),
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
                    MaterialPageRoute(builder: (_) => MainShowList()),
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
    });
  }
}
