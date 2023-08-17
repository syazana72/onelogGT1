import 'package:afrv1/PDFAll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:get_storage/get_storage.dart';
import 'ImageFullAfter.dart';
import 'FeedbackList.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'PDFafter.dart';

class FullReportAfter extends StatefulWidget {
  final Map<String, dynamic> reportData;
  final Map<String, dynamic> feedbackData;// Add this line

  FullReportAfter({required this.feedbackData, required this.reportData});

  @override
  _FullReportAfterState createState() => _FullReportAfterState();
}

class _FullReportAfterState extends State<FullReportAfter> {
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
        .child("after/${widget.feedbackData['DateAfter']}-${widget.feedbackData['group']}-${widget.feedbackData['RandomNumber1']}.jpg")
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
            MaterialPageRoute(builder: (_) => FeedBackList(reportData: widget.reportData)),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff091647),
        title: Text('Report Information (AFTER)'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
           //   mainAxisSize: MainAxisSize.min,
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
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text(
                          '${widget.feedbackData['DateAfter']}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 7),
            Row(
              children: [
                Icon(Icons.location_on, color: Color(0xFF0D47A1)),
                SizedBox(width: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      '${widget.feedbackData['Area1']}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
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
                      'COUNTERMEASURE TAKEN',
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
                    '${widget.feedbackData['countermeasureTaken']}',
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
                      'GROUP',
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
                    '${widget.feedbackData['group']}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),
            // crossAxisAlignment: CrossAxisAlignment.start,
            SizedBox(width: 8),
            Text(
              'Issued By :',
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
                  '${widget.feedbackData['Issuer Name(After)']}',
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
              child:  ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ReportPageAll(feedbackData: widget.feedbackData, reportData: widget.reportData,)),
                  ),
                  style:ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF0D47A1)),
                  ),
                child: Text('Save PDF'),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FeedBackList(reportData: widget.reportData)),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFB71C1C)), // Change the color to your desired color
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
