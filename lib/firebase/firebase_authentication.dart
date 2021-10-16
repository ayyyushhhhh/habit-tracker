import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthentication {
  static late FirebaseAuth _auth; //FirebaseAuth instance

  static initFirebaseAuth() {
    _auth = FirebaseAuth.instance;
  }

  static Stream<String> get getUserStream {
    return _auth.authStateChanges().map((User? user) {
      if (user == null) {
        return "";
      } else {
        return user.uid;
      }
    });
  }

  static bool isLoggedIn() {
    User? user = _auth.currentUser;
    if (user != null) {
      return true;
    }
    return false;
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
