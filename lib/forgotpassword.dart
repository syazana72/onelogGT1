import 'package:flutter/material.dart';
//import 'package:flutter_url/splash_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';

class ForgotPassword extends StatelessWidget {

/* _launchURLBrowser() async {
      final url = Uri.parse('https://flutterdevs.com/');
      if (await canLaunchUrl(url as Uri)) {
        await launchUrl(url as Uri);
      } else {
        throw 'Could not launch $url';
      }
    }

  _launchURLApp() async {
    final url = Uri.parse('https://flutterdevs.com/');
    if (await canLaunchUrl(url as Uri)) {
      await launchUrl(url as Uri);
    } else {
      throw 'Could not launch $url';
    }
  } */


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xff091647),
          title: Text('Forgot Password')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ignore: deprecated_member_use
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              onPressed: () {
              launch('https://www.wasap.my/60176548203/forgot password');
    },
              child: Text('Contact Admin 1',style: TextStyle(color: Colors.white),),
            ),
            SizedBox(height: 8,),
            // ignore: deprecated_member_use
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              onPressed: () {
                launch('https://www.wasap.my/60177152142/forgot password');
    },
             // padding: EdgeInsets.only(left: 30,right: 30),
              child: Text('Contact Admin 2',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}