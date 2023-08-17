import 'dart:ui';
import 'ReportDetailsSG.dart';
import 'package:flutter/material.dart';

class GuidelineSG extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange[800],
      ),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Justification guideline:', // Replace this text with your actual help content
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Add the table with 3 columns and 2 rows here
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Table(
                  border: TableBorder.all(color: Colors.white),
                  children: [
                    TableRow(children: [
                      TableCell(
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          color: Colors.grey,
                          child: Text(
                            'Justfication',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          color: Colors.grey,
                          child: Text(
                            'Severity',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          color: Colors.grey,
                          child: Text(
                            'Completion',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Expanded(
                              child: Container(
                                height: 100,
                                padding: EdgeInsets.all(8.0),
                                color: Colors.grey[300], // Change this color for the first cell in the first row
                                child: Text('Rank A\n\n '),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TableCell(
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Expanded(
                              child: Container(
                                height: 100,
                                padding: EdgeInsets.all(8.0),
                                color: Colors.grey[300], // Change this color for the second cell in the first row
                                child: Text('Potential for serious injury or fatal OR not-comply act/regulation.\n '),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TableCell(
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Expanded(
                              child: Container(
                                height: 100,
                                padding: EdgeInsets.all(8.0),
                                color: Colors.grey[300], // Change this color for the third cell in the first row
                                child: Text('1 day\n\n '),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Expanded(
                              child: Container(
                                height: 100,
                                padding: EdgeInsets.all(8.0),
                                color: Colors.grey[300], // Change this color for the first cell in the second row
                                child: Text('Rank B\n\n '),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TableCell(
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Expanded(
                              child: Container(
                                height: 100,
                                padding: EdgeInsets.all(8.0),
                                color: Colors.grey[300], // Change this color for the second cell in the second row
                                child: Text('Potential minor injured, health issue, dangerous occurrence, and property damage.'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TableCell(
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Expanded(
                              child: Container(
                                height: 100,
                                padding: EdgeInsets.all(8.0),
                                color: Colors.grey[300], // Change this color for the third cell in the second row
                                child: Text('10 days\n\n '),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
