import 'package:afrv1/PDFBefore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'FullReportAfter.dart';
import 'ImageFullBefore.dart';
import 'MainShowList.dart';
import 'NextReportBefore.dart';
import 'UpdateReport.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FullReportBefore extends StatefulWidget {
  final Map<String, dynamic> reportData;

  FullReportBefore({required this.reportData});

  @override
  _FullReportBeforeState createState() => _FullReportBeforeState();
}

class _FullReportBeforeState extends State<FullReportBefore> {
  String? imageUrl;
  bool reportExists = false;
  bool isReportIdMatched = false;

  @override
  void initState() {
    super.initState();
    checkReportExists();
    fetchImageUrl();
    checkReportIdMatched();
  }

  Future<void> checkReportExists() async {
    final reportID = widget.reportData['reportID'];
    final snapshot = await FirebaseFirestore.instance
        .collection('feedback')
        .where("reportID", isEqualTo: reportID).get();
    setState(() {
      reportExists = (snapshot.docs.isNotEmpty);
    });
  }

   Future <Map<String, dynamic>> getFeedback() async {
    final reportID = widget.reportData['reportID'];
    final snapshot = await FirebaseFirestore.instance
        .collection('feedback')
        .where("reportID", isEqualTo: reportID).snapshots().elementAt(0);
    return snapshot.docs.first.data();
  }

  Future<void> fetchImageUrl() async {
    final storageRef = FirebaseStorage.instance.ref();
    imageUrl = await storageRef
        .child("before/${widget.reportData['Date']}-${widget.reportData['Area']}-${widget.reportData['RandomNumber']}.jpg")
        .getDownloadURL();
    setState(() {
      // Update the state to trigger a rebuild with the fetched image URL
    });
  }

  Future<void> fetchDocuments() async {

    int currentIndex = 0;
    List<DocumentSnapshot> documents = [];
    // Query Firestore collection "reports"
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('reports').get();

    // Store the documents in the 'documents' list
    setState(() {
      documents = snapshot.docs;
      Text(documents.isNotEmpty ? documents[currentIndex].data().toString() : 'No documents available');
      currentIndex = (currentIndex + 1) % documents.length;
    //  Text(documents.isNotEmpty ? documents[currentIndex].data().toString() : 'No documents available');
    }
    );
  }

  Future<void> checkReportIdMatched() async {
    final reportID = widget.reportData['reportID'];
    final snapshot = await FirebaseFirestore.instance
        .collection('reports')
        .doc(reportID)
        .get();
    setState(() {
      isReportIdMatched = snapshot.exists;
    });
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Color(0xFFEFEBE9),
       appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MainShowList()),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff091647),
        title: Text('Report Information (BEFORE)'),
         /*actions: [
           IconButton(
             icon: Icon(Icons.arrow_forward),
             onPressed: () {
               fetchDocuments();
             },
           ),
         ],*/
       ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text(
                          '${widget.reportData['Date']}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      SizedBox(width:30),
                      Icon(Icons.access_time, color: Color(0xFF0D47A1)),
                      SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text(
                          'Shift ${widget.reportData['Shift']}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
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
                      '${widget.reportData['Area']}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height:7),
            Row(
              children: [
                Icon(Icons.group, color: Color(0xFF0D47A1)),
                SizedBox(width: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      '${widget.reportData['PIC/ATTN']}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            if (imageUrl != null)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FullScreenImage(imageUrl: imageUrl!),
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
                  imageUrl!,
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
                      'PROBLEM DESCRIPTION',
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
                    '${widget.reportData['problemDescription']}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.image, color: Color(0xFF4E342E)),
                    SizedBox(width: 8),
                    Text(
                      'IMAGE REMARKS',
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
                    '${widget.reportData['imageRemarks']}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.report_problem, color: Color(0xFF4E342E)),
                    SizedBox(width: 8),
                    Text(
                      'CATEGORIES',
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
                    '${widget.reportData['categories'].join (', ')}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
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
                    '${widget.reportData['group']}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),

            SizedBox(height: 15),

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
                  '${widget.reportData['Issuer Name']}',
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
                  '${widget.reportData['Email']}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 30),
        /*    Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Existing code for the "Add report" button
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF0D47A1)),
                  ),
                  child: Text(
                    reportExists ? (isReportIdMatched ? 'Matching Report (AFTER)' : 'View Report (AFTER)') : 'Add Report (AFTER)',
                  ),
                ),
                SizedBox(width: 10), // Add a desired width between the two buttons
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ReportPageBEFORE(reportData: widget.reportData)),
                  ),
                  icon: Icon(Icons.file_download_outlined, size: 30), // Replace Feather.save with the desired icon
                  color: Colors.black, // Change the color to your desired color
                ),
              ],
            ),*/
    Center(
    child: ElevatedButton(
    onPressed: () async {
     // var feedbackData = await getFeedback();
      if (reportExists) {
        var feedbackData = await getFeedback();
    if (isReportIdMatched) {
    // Handle the action for matching report IDs
    // Replace the below code with the logic to handle matching report IDs
    Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => FullReportAfter(feedbackData: feedbackData, reportData: widget.reportData)),
    );
    } else {
    // Handle the action for viewing the report
    // Replace the below code with the logic to handle viewing the report
    Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => FullReportAfter(feedbackData: feedbackData, reportData: widget.reportData)),
    );
    }
    } else {
    GetStorage box = GetStorage();
    box.write('reportID', widget.reportData['reportID']);
    box.write('Area', widget.reportData['Area']);
    Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => UpdateReport(box)),
    );
    }
    },
    style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF0D47A1)),
    ),
    child: Text(
    reportExists
    ? (isReportIdMatched ? 'Matching Report (AFTER)' : 'View Report (AFTER)')
        : 'Add Report (AFTER)',
    ),
    ),
            ),
         /*   SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ReportPageBEFORE(reportData: widget.reportData)),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue.shade300), // Change the color to your desired color
                ),
                child: Text('  Save PDF  '),
              ),
            ),*/
            SizedBox(height: 10),
        Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ // Add a desired width between the two buttons
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ReportPageBEFORE(reportData: widget.reportData)),
                  ),
                  icon: Icon(Icons.picture_as_pdf_sharp, size: 30), // Replace Feather.save with the desired icon
                  color: Colors.black, // Change the color to your desired color
                ),
                SizedBox(width: 10),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MainShowList()),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFB71C1C)), // Change the color to your desired color
                ),
                child: Text('   Close   '),
              ),
            ),
              ]
        ),
          ],
        ),
      ),
    );
  }
}






