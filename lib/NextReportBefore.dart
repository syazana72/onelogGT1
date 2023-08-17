import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'MainShowList.dart';

class NextDocumentPage extends StatefulWidget {
  @override
  _NextDocumentPageState createState() => _NextDocumentPageState();
}

class _NextDocumentPageState extends State<NextDocumentPage> {
  // Declare variables
  int currentIndex = 0;
  List<DocumentSnapshot> documents = [];

  @override
  void initState() {
    super.initState();
    // Fetch documents from the Firestore collection "reports"
    fetchDocuments();
  }

  Future<void> fetchDocuments() async {
    // Query Firestore collection "reports"
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('reports').get();

    // Store the documents in the 'documents' list
    setState(() {
      documents = snapshot.docs;
    });
  }

  void showNextDocument() {
    setState(() {
      // Increment the current index
      currentIndex = (currentIndex + 1) % documents.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NextDocumentPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Display the current document content
          Text(documents.isNotEmpty ? documents[currentIndex].data().toString() : 'No documents available'),

          // Add space between the document content and the next icon
          SizedBox(height: 20),

          // Display the 'next' icon button
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              showNextDocument();
            },
          ),
        ],
      ),
    );
  }
}
