import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:cup_and_soup/services/cloudFirestore.dart';
import 'package:cup_and_soup/services/cloudFunctions.dart';

class AuthService {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;

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
        _user = user;
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
    if (_user != null)
      return _user.uid;
    else {
      await refreshUser();
      if (_user != null) 
        return _user.uid;
      await loginWithGoogle();
      if (_user != null)
        return _user.uid;
      else
        return null;
    }
  }

  Future<List<String>> getRoles() async {
    if (_user != null)
      return await cloudFirestoreService.getRoles();
    else {
      await loginWithGoogle();
      if (_user != null)
        return await cloudFirestoreService.getRoles();
      else
        return null;
    }
  }

    Future<bool> signOut() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
    cloudFirestoreService.resetUserData();
    _user = null;
    return true;
  }

  Future<bool> changeName(String name) async {
    String uid = await getUid();
    if (uid == null) return false;
    bool res = await cloudFunctionsService.changeName(uid, name);
    if (res) {
      await cloudFirestoreService.loadUserData();
    }
    return res;
  }

  Future<FirebaseUser> refreshUser() async {
    FirebaseUser user = await _auth.currentUser();
    _user = user;
    return user;
  }

}

final AuthService authService = AuthService();
