import 'dart:math';

import 'package:afrv1/MainPage.dart';
import 'package:afrv1/ReportDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';

class AddReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Add New Report",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageee();
  }
}

class _HomePageee extends State<HomePage> {

  final random = Random();
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateInput = TextEditingController();
  String? selectedOption; // DATE
  String? selectedOptions; // PIC
  String? selectedOptionss; // SHIFT


  final box = GetStorage();

  Future<void> _onNextPressed() async {

    box.write('Date', userDateController.text );
    box.write('Area', userAreaController.text );
    final randomNumber = random.nextInt(50);
    box.write('RandomNumber', randomNumber);
    box.write('Issuer Name', userNameController.text );
    box.write('PIC/ATTN', selectedOptions);
    box.write('Shift', selectedOptionss );
    final reportID = Uuid().v1();
    box.write('reportID', reportID);

  /* final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final userEmail = user?.email;*/

    /*final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('reports').add({
      'Date': userDateController.text,
      'Area': userAreaController.text,
      'Issuer Name': userNameController.text,
      'PIC/ATTN': selectedOptions,
      'Shift': selectedOptionss,
      'Email': userEmail,
    });*/
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ReportDetail(box)),
    );
  }

  final userDateController = TextEditingController();
  final userAreaController = TextEditingController();
  final userNameController = TextEditingController();
  final userPicController = TextEditingController();

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();
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
                  context, MaterialPageRoute(builder: (_) => MainPage())),
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
                  'Report Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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
                      String formattedDate = DateFormat('dd-MM-yyyy').format(
                          pickedDate);
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
                SizedBox(
                  width: 520,
                  child: DropdownButtonFormField<String>(
                   // controller: userPicController,
                    value: selectedOptions,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedOptions = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select PIC and Area',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.group),
                    ),
                    items: <String>[
                      'CKD KR - SAHPARIN',
                      'CKD TLS - MOHD NADZRI',
                      'CKD TLS - AZAIMI',
                      'LG BODY - ASNARI',
                      'LG BODY - MOHD HAFIZAN',
                      'LG CKD - MOHD AZIMI',
                      'LG CKD - SYAHRIZAL',
                      'LG CMK - FAIZAL',
                      'LG CMK - AZLAN',
                      'LG RECEIVING - MOHD YUTI',
                      'LG RECEIVING - AZMAN',
                      'LG STORE ASSY - MOHD AZWAN',
                      'LG STORE ASSY - SARUDIN',
                      'LG SUPPLY ASSY - MOHAMMAD FITRI',
                      'LG SUPPLY ASSY - AHMAD NURZUHAIR',
                    ].map((String value) {
                      final parts = value.split('-');
                      return DropdownMenuItem<String>(
                        value: value,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            children: [
                              TextSpan(
                                text: parts[0],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: '- ${parts[1]}', // Display the second part in bold
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Required';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: userAreaController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.location_on),
                    labelText: 'Section Area',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    userAreaController.text = value.toUpperCase(); // Convert input to capital letters
                    userAreaController.selection = TextSelection.fromPosition(TextPosition(offset: userAreaController.text.length)); // Maintain cursor position at the end
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


                SizedBox(height: 20),
                TextFormField(
                  controller: userNameController,
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
                    userNameController.text = value.toUpperCase(); // Convert input to capital letters
                    userNameController.selection = TextSelection.fromPosition(TextPosition(offset: userNameController.text.length)); // Maintain cursor position at the end
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
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.black54,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Shift',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                FormField<String>(
                  validator: (value) {
                    if (value == null) {
                      return '*Please select an option';
                    }
                    return null;
                  },
                  builder: (FormFieldState<String> state) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: RadioListTile<String>(
                              title: Text('A'),
                              value: 'A',
                              groupValue: state.value,
                              onChanged: (String? value) {
                                setState(() {
                                  state.didChange(value);
                                  selectedOptionss = value;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: RadioListTile<String>(
                              title: Text('B'),
                              value: 'B',
                              groupValue: state.value,
                              onChanged: (String? value) {
                                setState(() {
                                  state.didChange(value);
                                  selectedOptionss = value;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: RadioListTile<String>(
                              title: Text('N'),
                              value: 'N',
                              groupValue: state.value,
                              onChanged: (String? value) {
                                setState(() {
                                  state.didChange(value);
                                  selectedOptionss = value;
                                });
                              },
                            ),
                          ),
                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                state.errorText!,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          selectedOption != null &&
                          selectedOptions != null &&
                          selectedOptionss != null) {
                        await _onNextPressed();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ReportDetail(box)),
                        );
                      }
                    },
                    child: Text('NEXT'),
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                      fixedSize:
                      MaterialStateProperty.all<Size>(Size.fromHeight(50)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),

  //  ),
    );
  }
}
