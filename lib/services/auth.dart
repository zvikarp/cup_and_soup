import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:cup_and_soup/services/cloudFirestore.dart';

class AuthService {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _firebaseUser;

  Future<FirebaseUser> loginWithGoogle() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      FirebaseUser user = await _auth.signInWithCredential(credential);
      if (user != null) {
        _firebaseUser = user;
        return user;
      }
    } catch (e) {
      try {
        _auth.signOut();
      } catch (e) {
        print(e);
      }
      return null;
    }
    return null;
  }

  Future<String> getUid() async {
    if (_firebaseUser != null)
      return _firebaseUser.uid;
    else {
      await refreshUser();
      if (_firebaseUser != null) 
        return _firebaseUser.uid;
      await loginWithGoogle();
      if (_firebaseUser != null)
        return _firebaseUser.uid;
      else
        return null;
    }
  }

    Future<bool> signOut() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
    await cloudFirestoreService.resetUserData();
    _firebaseUser = null;
    return true;
  }

  Future<FirebaseUser> refreshUser() async {
    FirebaseUser user = await _auth.currentUser();
    _firebaseUser = user;
    return user;
  }

}

final AuthService authService = AuthService();
