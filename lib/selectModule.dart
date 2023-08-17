import 'dart:io';
import 'dart:ui';
import 'MainPage.dart';
import 'package:flutter/material.dart';
import 'FadeAnimation.dart';
import 'MainPageSG.dart';
import 'ReportDetailsSG.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceContainer extends StatefulWidget {
  final String image;
  final String name;
  final String desc;
  final String total;

  ServiceContainer(
      {required this.image, required this.name, required this.desc, required this.total});

  @override
  _ServiceContainerState createState() => _ServiceContainerState();
}


class _ServiceContainerState extends State<ServiceContainer> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: GestureDetector(
        onTap: () {
        // Navigate to a new page or class based on the data of this ServiceContainer.
        // For example, you can check the name of the service to determine which class to navigate to.
        if (widget.name == 'Safety Gemba') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MyAppMain2()),
          );
        } else if (widget.name == 'Daily Finding') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MyAppMain()),
          );
        } else {
          // Handle the case for other services if needed.
        }
      },
      child: Container(
        width: 420,
        height: 130,
        margin: EdgeInsets.only(right: 20),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isHovered ? Colors.grey.withOpacity(0.3) : Colors.grey.shade100, // Change color when hovered
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20.0),

        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           Image.network(widget.image, height: 100),
            SizedBox(width: 20),// Add some spacing between the image and texts
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              //  Spacer(),
                Text(widget.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(widget.desc, style: TextStyle(fontSize: 15)),
                SizedBox(height: 20),
                Text(widget.total, style: TextStyle(fontSize: 15, color: Colors.deepOrange)),
              ],
            ),
           /* Image.network(image, height: 100),
            SizedBox(width: 10),*/
          ],
        ),
      ),
    ),
    );
  }
}

class MyMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SelectModule(),
      routes: {
        '/second': (context) => SecondPage(),
        '/third': (context) => ThirdPage(),
      },
    );
  }
}

class SelectModule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainPageContent();
  }
}

final List<Map<String, String>> services = [
  {
    'image': 'assets/images/safetylogo.png',
    'name': 'Safety Gemba',
    'desc': 'Division Safety Patrol',
    'total': 'Total Finding: 12',
  },
  {
    'image': 'assets/images/dailyfinding.jpeg',
    'name': 'Daily Finding',
    'desc': 'Abnormality Finding',
    'total': 'Total Finding: 11',
  },
];

class MainPageContent extends StatefulWidget {
  @override
  _MainPageContentState createState() => _MainPageContentState();
}

class _MainPageContentState extends State<MainPageContent> {
  String userName = '';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      // Get the currently logged-in user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Get the user's email from Firebase Authentication
        String userEmail = user.email ?? "";

        // Query the Firestore collection 'users' based on the user's email
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('Email', isEqualTo: userEmail)
            .limit(1)
            .get();

        // If the query returns any documents, update the greeting with the user's name
        if (snapshot.docs.isNotEmpty) {
          String name = snapshot.docs.first.get('Name');
          setState(() {
            userName = name;
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: null,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/backgroundONELOG.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          //////////////////////
          Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
                  SizedBox(height: 80),
                  Padding(
                  padding: EdgeInsets.fromLTRB(150, 15, 150, 15),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.center, // You can adjust the alignment as needed
                      children: <Widget>[
                        Stack(
                          children: [
                            Text(
                              "Hi $userName",
                              style: TextStyle(
                                fontSize: 30,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 2
                                  ..color = Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Hi $userName",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10), // Add some space between the text and the image
                        Image.asset(
                          "assets/images/profile.png",
                          width: 50, // Adjust the width of the image as needed
                          height: 50, // Adjust the height of the image as needed
                        ),
                      ],
                    ),

                  SizedBox(height: 10),
                  FadeAnimation(
                  1.3,
                  Text(
                  "Please select menu",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  ),
                    SizedBox(height: 20),
                  ],
                  ),
                  ),
                  SizedBox(height: 20),
                  ]
                        ),
          Positioned(
            top: 200,
            left: 30,
            right: 30, // Add right constraint to limit the width of the Column
            child: Center(
              child: Column(
                children: services
                    .map(
                      (service) => Column(
                    children: [
                      ServiceContainer(
                        image: service['image']!,
                        name: service['name']!,
                        desc: service['desc']!,
                        total: service['total']!,
                      ),
                      SizedBox(height: 40), // Add a SizedBox for the gap between ServiceContainer widgets
                    ],
                  ),
                )
                    .toList(),
              ),
            ),
          ),

          /*   Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddReport()),
                    );
                  },
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.black, //box color for icon
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/pngwing.com (26).png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'DAILY FINDING',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MainShowList()),
                    );
                  },
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.black, //box color for icon
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/pngwing.com (27).png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'SAFETY GEMBA',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),*/
          Positioned(
            top: 40.0,
            right: 50.0,
            child: IconButton(
              /*  onPressed: () {
                exit(0);
              },*/
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirmation'),
                      content: Text(
                          'Proceed to exit?'),
                      actions: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Logout'),
                          onPressed: () async {
                            // Perform logout actions here
                            // For example, clear user authentication state, navigate to login screen, etc.
                            // Example:
                            //    await AuthService.logout();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => MyApp()),
                            );
                          },
                        ),

                      ],
                    );
                  },
                );
              },
              icon: Row(
                children: [
                  Text(
                    'Logout  ',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.logout, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
   //   ),
    ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
      ),
      body: Center(
        child: Text('This is the second page.'),
      ),
    );
  }
}

class ThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Third Page'),
      ),
      body: Center(
        child: Text('This is the third page.'),
      ),
    );
  }
}
