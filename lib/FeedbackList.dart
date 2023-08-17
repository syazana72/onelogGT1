import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'DocumentCountPage.dart';
import 'FullReportAfter.dart';
import 'MainShowList.dart';

class FeedBackList extends StatefulWidget {
  final Map<String, dynamic> reportData; // Add this line

  FeedBackList({required this.reportData}); // Update the constructor

  @override
  _FeedBackState createState() => _FeedBackState();
}
class _FeedBackState extends State<FeedBackList> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late bool sortValue = true;
  late TextEditingController _searchController;

  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  void _performSearch(String value) {
    setState(() {
      _searchText = value;
    });
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
                  context, MaterialPageRoute(builder: (_) => MainShowList())),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff091647),
        title: Text('Report List (AFTER)'),
        actions: [
          IconButton(
            icon: Icon(Icons.lightbulb, color: Colors.yellow),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DocumentCountPage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
        .collection('feedback')
        .snapshots(),
    builder: (context, feedbackSnapshot) {
    if (feedbackSnapshot.hasError) {
    return Text('Error: ${feedbackSnapshot.error}');
    }

    if (feedbackSnapshot.connectionState == ConnectionState.waiting) {
    return CircularProgressIndicator();
    }

    List<Widget> reportWidgets = [];
    int index = 1;

    final feedbacks = feedbackSnapshot.data!.docs;
    for (var feedback in feedbacks) {
    final feedbackData = feedback.data() as Map<String, dynamic>;

            // Apply the search filter to the report data
            if ((_searchText.isEmpty) ||
                (feedbackData['Area']
                    .toLowerCase()
                    .contains(_searchText.toLowerCase()) ||
                    feedbackData['DateAfter']
                        .toLowerCase()
                        .contains(_searchText.toLowerCase()))) {
              final reportWidget = Card(
                color: Color(0xFFEF9A9A),
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
                      EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                      title: Text(
                        '$index) ${feedbackData['DateAfter']} | ${feedbackData['Area1']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'PIC/ATTN: ${feedbackData['PIC/ATTN1']}',),
                      //subtitle: Text(reportData['PIC/ATTN']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                FullReportAfter(feedbackData: feedbackData, reportData: widget.reportData,),
                          ),
                        );
                      },
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
                          hintText: "Search for report by Date or AREA",
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              _performSearch(_searchController.text);
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(25.0)),
                          ),
                          filled: true, // Set filled property to true
                          fillColor: Colors.white, // Set the fillColor to white
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
                            if (sortValue == true){
                              sortValue = false;
                            }
                            else if(sortValue == false){
                              sortValue = true;
                            }
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
      ),
      /*floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff091647),
        onPressed: () {},
        child: PopupMenuButton(
          icon: Icon(Icons.more_vert),
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry>[
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.add_circle_outlined),
                  iconColor: Colors.green,
                  title: Text('Go To Feedback List'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddReport()),
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
                      MaterialPageRoute(builder: (_) => AddReport()),
                    );
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.help),
                  iconColor: Colors.yellow,
                  title: Text('Help'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MyPhotoPage()),
                    );
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.logout),
                  iconColor: Colors.black,
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  hoverColor: Colors.blueAccent[300],
                  onTap: () {
                    SystemNavigator.pop();
                  },
                ),
              ),
            ];
          },
        ),
      ),*/
    );
  }
}
