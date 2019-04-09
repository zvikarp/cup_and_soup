import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cup_and_soup/services/sharedPreferences.dart';
import 'package:cup_and_soup/pages/home.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId;
  String _uid;
  String _phoneNumber;

  Future verifyPhoneNumber(String phoneNumber, BuildContext context) async {
    _phoneNumber = phoneNumber;
    final PhoneVerificationCompleted verificationCompleted =
        (FirebaseUser user) {
      _uid = user.uid ?? "";
      print("the uid" + _uid);
      if (_uid != "") {
        sharedPreferencesService.setPhoneNumber(_phoneNumber);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {};

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  Future<String> signInWithPhoneNumber(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: smsCode,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    sharedPreferencesService.setPhoneNumber(_phoneNumber);
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

  Future<String> signIn(BuildContext context) async {
    final FirebaseUser currentUser = await _auth.currentUser();
    if ((_uid != null) && (currentUser != null) && (_uid == currentUser.uid)) return _uid;
    String phoneNumber = await sharedPreferencesService.getPhoneNumber();
    if ((phoneNumber != "") && (phoneNumber != null)) {
      String uid = await verifyPhoneNumber(phoneNumber, context);
      _uid = uid;
      return uid;
    } else {
      return _uid;
    }
  }

  Future<bool> signOut() async {
    await FirebaseAuth.instance.signOut();
    return true;
  }
}

final AuthService authService = AuthService();
