import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';
import 'MainPageSG.dart';
import 'ReportDetailsSG.dart';

class AddReportSG extends StatelessWidget {
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
  String? selectedOption;
  String? selectedLocation;
//  String? selectedFindingNo;
  TimeOfDay? selectedTime;
  DateTime? selectedDateTime;

  final box = GetStorage();

  Future<void> _onNextPressed() async {

    box.write('Date', userDateController.text );
    box.write('Time', userTimeController.text);
    box.write('Theme', userThemeController.text );
    final randomNumber = random.nextInt(50);
    box.write('RandomNumber', randomNumber);
    box.write('Inspected by', userNameController.text );
    box.write('Location', selectedLocation);
  //  box.write('Total Finding', selectedFindingNo );
    final reportID = Uuid().v1();
    box.write('reportID', reportID);

    /* final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final userEmail = user?.email;*/

    /*final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('reports').add({
      'Date': userDateController.text,
      'Area': userThemeController.text,
      'Issuer Name': userNameController.text,
      'PIC/ATTN': selectedLocation,
      'Shift': selectedFindingNo,
      'Email': userEmail,
    });*/
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ReportDetailSG(box)),
    );
  }

  final userDateController = TextEditingController();
  final userThemeController = TextEditingController(text: 'USA/USC/ENV');
  final userNameController = TextEditingController();
  final userLocationController = TextEditingController();
  final userTimeController = TextEditingController();

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();
  //  selectedFindingNo = 'A';
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
                  context, MaterialPageRoute(builder: (_) => MyAppMain2())),
        ),
        centerTitle: true,
        title: Text('Add New Report'),
        backgroundColor: Colors.deepOrange[800],
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
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
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
                    ),
                    SizedBox(width: 20), // Add some spacing between the TextFormFields
                    Expanded(
                      child: TextFormField(
                        controller: userTimeController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.access_time),
                          border: OutlineInputBorder(),
                          labelText: 'Time',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        readOnly: true,
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              selectedTime = pickedTime;
                              // Format the TimeOfDay into a DateTime object
                              selectedDateTime = DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                              String formattedTime =
                              DateFormat('h:mm a').format(selectedDateTime!);
                              userTimeController.text = formattedTime;
                            });
                          }
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a time';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
            SizedBox(
             // width: 345,
                child: DropdownButtonFormField<String>(
                  // controller: userLocationController,
                  value: selectedLocation,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLocation = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Location [shop/dept]',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.group),
                  ),
                  items: <String>[
                    'RECEIVING  ',
                    'W SUPPLY ',
                    'LG W   ',
                    'EMPTY BOX',
                    'P - LANE',
                    'JIT    ',
                    'BF     ',
                    'LG ENGINE (K SHOP)',
                    'KR STORE   ',
                    'SPC    ',
                    'JUNDATE  ',
                    'F/L MAINT  ',
                    'CKD      ',
                    'CMK KR   ',
                    'LG BUMPER',
                    'CKD WAREHOUSE',
                    'BC     ',
                    'CTS & SUB M.',
                    'TINTED ',
                    'CY     ',
                    'TLS      ',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                     child: Padding(
                        padding: EdgeInsets.only(left: 16),
                      child: RichText(
                        text: TextSpan(
                          text: value, // Add this line to display the value in the DropdownMenuItem
                          style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
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
                  controller: userThemeController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.category),
                    labelText: 'Theme',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    userThemeController.text = value.toUpperCase(); // Convert input to capital letters
                    userThemeController.selection = TextSelection.fromPosition(TextPosition(offset: userThemeController.text.length)); // Maintain cursor position at the end
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
                    labelText: 'Inspected By',
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
             //   SizedBox(height: 20),
             /*   Row(
                  children: [
                    Icon(
                      Icons.note_add_outlined,
                      color: Colors.black54,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Total Gemba Finding (max: 4)',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),*/
              /*  SizedBox(height: 10),
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
                              title: Text('1'),
                              value: '1',
                              groupValue: state.value,
                              onChanged: (String? value) {
                                setState(() {
                                  state.didChange(value);
                                  selectedFindingNo = value;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: RadioListTile<String>(
                              title: Text('2'),
                              value: '2',
                              groupValue: state.value,
                              onChanged: (String? value) {
                                setState(() {
                                  state.didChange(value);
                                  selectedFindingNo = value;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: RadioListTile<String>(
                              title: Text('3'),
                              value: '3',
                              groupValue: state.value,
                              onChanged: (String? value) {
                                setState(() {
                                  state.didChange(value);
                                  selectedFindingNo = value;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: RadioListTile<String>(
                              title: Text('4'),
                              value: '4',
                              groupValue: state.value,
                              onChanged: (String? value) {
                                setState(() {
                                  state.didChange(value);
                                  selectedFindingNo = value;
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
                ),*/
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          selectedOption != null &&
                          selectedLocation != null /*&&
                          selectedFindingNo != null*/) {
                        await _onNextPressed();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ReportDetailSG(box)),
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
