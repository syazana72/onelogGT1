import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireAuth {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      // Check whether the email and password entered by the user match the email and password stored in Firebase
      if (user != null && user.email == email) {
        return user;
      } else {
        throw FirebaseException(
          code: 'ERROR_INVALID_EMAIL_PASSWORD',
          message: 'Invalid email or password',
          plugin: 'Firebase Auth',
        );
      }
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }
}
