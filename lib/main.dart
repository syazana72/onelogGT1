import 'dart:ui';

import 'selectModule.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FadeAnimation.dart';
import 'forgotpassword.dart';
import 'fire_auth.dart';
import 'validator.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:logger/logger.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Add a logger instance for debug logging
  Logger logger = Logger();

  // Logging debug information using assert
  assert(() {
    logger.d('This will be visible during development');
    return true; // Return true for debug builds
  }());

  await Firebase.initializeApp(
    options: kIsWeb || Platform.isAndroid
        ? FirebaseOptions(
        databaseURL: "https://afrv1-70b59-default-rtdb.firebaseio.com",
        apiKey: "AIzaSyC0knCyzK0CI7SyVuyD1xG_UX0LwWi5m7E",
        authDomain: "oneloggt.firebaseapp.com",
        projectId: "oneloggt",
        storageBucket: "oneloggt.appspot.com",
        messagingSenderId: "679201416023",
        appId: "1:679201416023:web:41f1608af33d182b8dd412"
    )
        : null,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(MyApp());
  FlutterNativeSplash.remove();
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '1LOG Finding',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  bool _isProcessing = false;
  SharedPreferences? _prefs;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _initPreferences();
  }

  Future<void> _initPreferences() async {
    _prefs = await SharedPreferences.getInstance();

    setState(() {
      rememberMe = _prefs?.getBool('rememberMe') ?? false;

      if (rememberMe) {
        _emailTextController.text = _prefs?.getString('email') ?? '';
        _passwordTextController.text = _prefs?.getString('password') ?? '';
      }
    });
  }

  Future<bool> verifyAdmin(String email) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "* Required";
    } else if (value.length < 6) {
      return "Password should be at least 6 characters";
    } else if (value.length > 15) {
      return "Password should not be greater than 15 characters";
    } else
      return null;
  }

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
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
                SizedBox(height: 80),
                Padding(
                  padding: EdgeInsets.fromLTRB(150, 15, 150, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Text(
                            "1LOG FINDING",
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
                            "1LOG FINDING",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      FadeAnimation(
                        1.3,
                        Text(
                          "Welcome Back!",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(150, 20, 150, 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50, // Adjust opacity value (0.0 to 1.0)
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 60),
                              FadeAnimation(
                                1.4,
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromRGBO(225, 95, 27, .3),
                                        blurRadius: 20,
                                        offset: Offset(0, 10),
                                      )
                                    ],
                                  ),
                                  child: Form(
                                    key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.fromLTRB(20, 8, 0, 8),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(color: Colors.grey.shade200),
                                          ),
                                        ),
                                        child: TextFormField(
                                          controller: _emailTextController,
                                          focusNode: _focusEmail,
                                          validator: (value) => Validator.validateEmail(
                                            email: value,
                                          ),
                                          decoration: InputDecoration(
                                            border:  InputBorder.none,
                                            labelText: "Email Address",
                                            labelStyle:   TextStyle(color: Colors.grey.shade600),
                                            hintText: "Enter email address",
                                            hintStyle: TextStyle(color: Colors.grey.shade600),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(6.0),
                                              borderSide: BorderSide(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      //  SizedBox(height: 15.0),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(20,8,0,8),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(color: Colors.grey.shade200),
                                          ),
                                        ),
                                        child: TextFormField(
                                          controller: _passwordTextController,
                                          focusNode: _focusPassword,
                                          obscureText: _isObscure,
                                          validator: (value) => validatePassword(value!),
                                          decoration: InputDecoration(
                                            border:  InputBorder.none,
                                            labelText: "Password",
                                            labelStyle: TextStyle(color: Colors.grey.shade600),
                                            hintText: "Enter secure password",
                                            hintStyle: TextStyle(color: Colors.grey.shade600),
                                            suffixIcon: IconButton(
                                              icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                                              onPressed: (){
                                                setState(() {
                                                  _isObscure = !_isObscure;
                                                });
                                              },
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(6.0),
                                              borderSide: BorderSide(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ),
                                  ),
                              ),
                              SizedBox(height: 15),
                              CheckboxListTile(
                                title: Text(
                                  'Remember Me',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value!;
                                  });
                                },
                              ),
                              SizedBox(height: 20),
                              _isProcessing ? CircularProgressIndicator()
                                  : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    height: 50,
                               //     width: 250,
                                    margin: EdgeInsets.symmetric(horizontal: 50),
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange[800],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: TextButton(
                                      onPressed: () async {
                                        _focusEmail.unfocus();
                                        _focusPassword.unfocus();

                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            _isProcessing = true;
                                          });

                                          if (rememberMe) {
                                            // Save the user's login credentials in SharedPreferences
                                            await _prefs?.setString('email', _emailTextController.text);
                                            await _prefs?.setString('password', _passwordTextController.text);
                                          } else {
                                            // Clear the saved login credentials
                                            await _prefs?.remove('email');
                                            await _prefs?.remove('password');
                                          }

                                          User? user = await FireAuth.signInUsingEmailPassword(
                                            email: _emailTextController.text,
                                            password: _passwordTextController.text,
                                          );

                                          setState(() {
                                            _isProcessing = false;
                                          });

                                          if (user != null) {
                                            bool isAdmin = await verifyAdmin(_emailTextController.text);

                                            if (isAdmin) {
                                              print('admin');
                                              Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) => SelectModule(),
                                                ),
                                              );
                                            } else {
                                              print('user');
                                              Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) => SelectModule(),
                                                ),
                                              );
                                            }
                                          } else {
                                            // Show an error message
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Invalid email or password'),
                                                duration: Duration(seconds: 3),
                                              ),
                                            );
                                          }

                                          if (rememberMe) {
                                            // Save the "Remember Me" preference
                                            await _prefs?.setBool('rememberMe', true);
                                          } else {
                                            // Clear the "Remember Me" preference
                                            await _prefs?.remove('rememberMe');
                                          }
                                        }
                                      },
                                      child: Text(
                                        'Sign In',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => ForgotPassword()),
                                      );
                                    },
                                    child: Text(
                                      'Forgot Password',
                                      style: TextStyle(color: Colors.grey, fontSize: 15),
                                    ),
                                  ),
                                ],

                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
