import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tioli/common/global.dart';

abstract class BaseAuthService with ChangeNotifier {
  Future<User> currentUser();
  Future<User> signIn(String email, String password);
  Future<User> updateUser(User user);
  Future<User> createNewUser(String nickname, String email, String password);
  //Future<void> signOut();
}

class FirebaseAuthService extends BaseAuthService {
  FirebaseAuthService({Auth firebaseAuth, GoogleAuthProvider googleSignin})
      : _firebaseAuth = firebaseAuth ?? auth();

  final Auth _firebaseAuth;

  @override
  Future<User> createNewUser(
      String nickname, String email, String password) async {
    try {
      var auth =
          await _firebaseAuth.createUserWithEmailAndPassword(email, password);
      var info = fb.UserProfile();
      info.displayName = '$nickname';
      await auth.user.updateProfile(info);
      updateUser(auth.user);
      setGlobalLoggedIn(auth.user.displayName);
      return auth.user;
    } catch (e) {
      print('Error creating new user: $e');
      throw '$e';
    }
  }

  setGlobalLoggedIn(String displayName) {
    var global = new Global();
    global.isLoggedIn = true;
    global.currentUserName = displayName;
  }

  @override
  Future<User> signIn(String email, String password) async {
    try {
      var auth =
          await _firebaseAuth.signInWithEmailAndPassword(email, password);
      if (auth.user != null) {
        setGlobalLoggedIn(auth.user.displayName);
      }
      return auth.user;
    } catch (e) {
      print("Error signin in with given credentials : "+ e.hashCode.toString());
      showToast(
        '$e'+'\n' + 'Please try again',
        duration: Duration(seconds: 10),
        position: ToastPosition.bottom,
        backgroundColor: Colors.white,
        radius: 5.0,
        textStyle: TextStyle(
            fontSize: 16.0, color: Colors.red, fontFamily: 'comic sans ms'),
      );
    }
    return null;
  }

  Future<User> currentUser() async {
    return _firebaseAuth.currentUser;
  }

  @override
  Future<User> updateUser(User user) async {
    final CollectionReference ref = fb.firestore().collection('users');
    String displayName = user.displayName;

    if (displayName == null) {
      displayName = "No Name yet";
    }
    var newData = {
      'uid': user.uid,
      'name': displayName,
      'email': user.email,
      'lastActive': DateTime.now()
    };

    await ref.doc(user.uid).set(newData, SetOptions(merge: true));

    return user;
  }
}
