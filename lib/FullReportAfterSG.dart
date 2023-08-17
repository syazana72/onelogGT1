import 'FeedbackListSG.dart';
import 'PDFAll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'ImageFullAfter.dart';
import 'FeedbackList.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'PDFafter.dart';

class FullReportAfterSG extends StatefulWidget {
  final Map<String, dynamic> reportData;
  final Map<String, dynamic> feedbackData; // Add this line

  FullReportAfterSG({required this.feedbackData, required this.reportData});

  @override
  _FullReportAfterState createState() => _FullReportAfterState();
}

class _FullReportAfterState extends State<FullReportAfterSG> {
  String? imageUrl1;
  // Add a variable to store the 'Area' field

  @override
  void initState() {
    super.initState();
    fetchImageUrl1();
  }

  Future<void> fetchImageUrl1() async {
    final storageRef = FirebaseStorage.instance.ref();
    imageUrl1 = await storageRef
        .child(
        "afterSG/${widget.feedbackData['DateAfter']}-${widget.feedbackData['Agreed by']}-${widget.feedbackData['RandomNumber1']}.jpg")
        .getDownloadURL();

    setState(() {
      // Update the state to trigger a rebuild with the fetched image URL
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBE9E7),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => FeedBackListSG(reportData: widget.reportData)),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepOrange[800],
        title: Text('DIVISION SAFETY PATROL (FEEDBACK)'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Color(0xFF0D47A1)),
                      SizedBox(width: 8),
                      Container(
                        //width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text(
                          '${widget.feedbackData['DateAfter']}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                    child: Row(
                    children: [
                    Icon(Icons.location_on, color: Color(0xFF0D47A1)),
        SizedBox(width: 8),
                   Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      '${widget.feedbackData['Location1']}',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ]
                    ),
                ),
              ],
            ),
         //   SizedBox(height: 7),
            SizedBox(height: 15),
            if (imageUrl1 != null)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FullScreenImageAfter(imageUrl1: imageUrl1!),
                    ),
                  );
                },
                /*child: Hero(
        tag: imageUrl!,
        child: InteractiveViewer(
          boundaryMargin: EdgeInsets.all(20),
          minScale: 0.1,
          maxScale: 5.0,*/
                child: Image.network(
                  imageUrl1!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            //  ),
            // ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(Icons.report_problem, color: Color(0xFF4E342E)),
                    SizedBox(width: 8),
                    Text(
                      'Action Plan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4E342E),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    '${widget.feedbackData['ActionTaken']}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 7),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(Icons.groups, color: Color(0xFF4E342E)),
                    SizedBox(width: 8),
                    Text(
                      'PIC',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4E342E),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    '${widget.feedbackData['PIC']}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.grade_outlined, color: Color(0xFF4E342E)),
                        SizedBox(width: 8),
                        Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4E342E),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(
                        '${widget.reportData['status']}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            /*  Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.groups, color: Color(0xFF4E342E)),
                      SizedBox(width: 8),
                      Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4E342E),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      '${widget.reportData['status']}',
                    ),
                  ),
                ],
              ),
            ),*/

            SizedBox(height: 10),
            // crossAxisAlignment: CrossAxisAlignment.start,
            SizedBox(width: 8),
            Text(
              'Agreed by :',
              style: TextStyle(
                fontSize: 16,
                //   fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.person), // Replace ICON_NAME with the desired icon
                SizedBox(width: 8),
                Text(
                  '${widget.feedbackData['Agreed by']}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 3),
            Row(
              children: [
                Icon(Icons.email), // Replace ICON_NAME with the desired icon
                SizedBox(width: 8),
                Text(
                  '${widget.feedbackData['Email']}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 30),
            /*Center(
              child: ElevatedButton(
                onPressed: (){
                  GetStorage box = GetStorage();
                  box.write('reportID', widget.reportData['reportID']);
                  Navigator.push(context,
                    MaterialPageRoute(builder: (_) => UpdateReport(box)),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF0D47A1)), // Change the color to your desired color
                ),
                child: Text('Add Report (AFTER)'),
              ),
            ),
            SizedBox(height: 10),*/
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ReportPageAll(
                        feedbackData: widget.feedbackData,
                        reportData: widget.reportData,
                      )),
                ),
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Color(0xFF0D47A1)),
                ),
                child: Text('Save PDF'),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => FeedBackList(reportData: widget.reportData)),
                ),
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Color(0xFFB71C1C)), // Change the color to your desired color
                ),
                child: Text('   Close   '),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
