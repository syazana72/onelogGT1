import 'package:afrv1/AddReportSG.dart';
import 'package:afrv1/GuidelineSG.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'DocumentCountPageSG.dart';
import 'FeedbackListSG.dart';
import 'FullReportBeforeSG.dart';
import 'FeedbackList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'MainPageSG.dart';
import 'flowpage.dart';
import 'package:path/path.dart' as path;
import 'main.dart';

class MainShowListSG extends StatefulWidget {
  @override
  _MainShowListState createState() => _MainShowListState();
}

class _MainShowListState extends State<MainShowListSG> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool sortValue = true;
  TextEditingController _searchController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  late FirebaseStorage storage;

  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    storage = FirebaseStorage.instance;
  }

  void _performSearch(String value) {
    setState(() {
      _searchText = value;
    });
  }

  bool isReportInFeedback(String reportID, List<QueryDocumentSnapshot> feedbacks) {
    for (var feedback in feedbacks) {
      final feedbackData = feedback.data() as Map<String, dynamic>;
      if (feedbackData['reportID'] == reportID) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFDE7),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => MyAppMain2())),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepOrange[800],
        title: Text('Report List'),
        actions: [
          IconButton(
            icon: Icon(Icons.lightbulb, color: Colors.yellow),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DocumentCountPageSG()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('reportsSG')
            .orderBy('Date', descending: sortValue)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('feedbackSG').snapshots(),
            builder: (context, feedbackSnapshot) {
              if (feedbackSnapshot.hasError) {
                return Text('Error: ${feedbackSnapshot.error}');
              }

              if (feedbackSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              List<Widget> reportWidgets = [];
              int index = 1;

              final reports = snapshot.data!.docs;
              final feedbacks = feedbackSnapshot.data!.docs;

              for (var report in reports) {
                final reportData = report.data() as Map<String, dynamic>;

                // Check if reportID exists in both collections
                final reportID = reportData['reportID'];
                final isReportInFeedbackList = isReportInFeedback(reportID, feedbacks);

                // Apply the search filter to the report data
                if ((_searchText.isEmpty) ||
                    (reportData['Location']
                        .toLowerCase()
                        .contains(_searchText.toLowerCase()) ||
                        reportData['Date'].toLowerCase().contains(_searchText.toLowerCase()))) {
                  final reportWidget = Card(
                    color: isReportInFeedbackList ? Color(0xFF9CCC65) : Color(0xFFFFF9C4),
                    // Change the card color here
                    elevation: 2,
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        ListTile(
                          contentPadding:
                          EdgeInsets.symmetric(
                              horizontal: 20, vertical: 1),
                          title: Text(
                            '$index) ${reportData['Date']} | ${reportData['Location']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Risk Assessment: ${reportData['Classification']}',
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    FullReportBeforeSG(
                                      reportData: reportData,
                                    ),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red[700],
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete Report'),
                                    content: Text(
                                        'Are you sure you want to delete this report?'),
                                    actions: [
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Delete'),
                                        onPressed: () async {
                                          final reportID = reportData['reportID'];

                                          report.reference.delete();

                                          // Delete from 'reports' collection
                                          await FirebaseFirestore.instance
                                              .collection('reportsSG')
                                              .doc(reportID)
                                              .delete();

                                          // Delete from 'feedback' collection
                                          await FirebaseFirestore.instance
                                              .collection('feedbackSG')
                                              .where('reportID',
                                              isEqualTo: reportID)
                                              .get()
                                              .then((querySnapshot) {
                                            querySnapshot.docs.forEach((
                                                doc) {
                                              doc.reference.delete();
                                            });
                                          });

                                          for (var feedback in feedbacks) {
                                            final feedbackData = feedback
                                                .data() as Map<
                                                String,
                                                dynamic>;
                                            try {
                                              // Delete the images from Firebase Storage
                                              final imagePath =
                                                  "beforeSG/${reportData['Date']}-${reportData['Location']}-${reportData['RandomNumber']}.jpg";
                                              final imagePathAfter =
                                                  "afterSG/${feedbackData['DateAfter']}-${feedbackData['Agreed by']}-${feedbackData['RandomNumber1']}.jpg";
                                              final fileName = path.basename(imagePath);
                                              final fileName2 = path.basename(imagePathAfter);
                                              print(
                                                  'Attempting to delete file: $imagePathAfter'); // Debug statement
                                              if (fileName.isNotEmpty) {
                                                // Get references to the image file
                                                final storageRef = storage
                                                    .ref(imagePath);
                                                // Delete the image
                                                await storageRef.delete();
                                              }
                                              if (fileName2.isNotEmpty) {
                                                // Get references to the image file
                                                final storageRef1 = storage
                                                    .ref(imagePathAfter);

                                                // Delete the image
                                                await storageRef1
                                                    .delete();
                                              }
                                            } catch (e) {
                                              print(
                                                  'Error deleting images: $e');
                                            }

                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                  reportWidgets.add(reportWidget);
                  index++;
                }
              }


              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              labelText: "Search",
                              hintText: "Search for report by date or Location",
                              suffixIcon: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  _performSearch(_searchController.text);
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                              ),
                              filled: true,
                              // Set filled property to true
                              fillColor: Colors.white,
                              // Set the fillColor to white
                              contentPadding: EdgeInsets.symmetric(horizontal: 20),
                            ),
                          ),
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            iconTheme: IconThemeData(
                              color: Colors.black87, // Change the icon color to white
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.unfold_more_rounded),
                            onPressed: () {
                              setState(() {
                                sortValue = !sortValue;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: reportWidgets,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff091647),
        onPressed: () {},
        child: PopupMenuButton(
          icon: Icon(Icons.more_vert),
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry>[
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.article_outlined),
                  iconColor: Colors.blueGrey,
                  title: Text('Go To Report (AFTER)'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => FeedBackListSG(reportData: {})),
                    );
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.add_circle_outlined),
                  iconColor: Colors.green,
                  title: Text('Add Report'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddReportSG()),
                    );
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.help_outline_sharp),
                  iconColor: Color(0xFFFFC400),
                  title: Text('Help'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => GuidelineSG()),
                    );
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MyApp()),
                    );
                  },
                ),
              ),

            ];
          },
        ),
      ),
    );
  }
}
