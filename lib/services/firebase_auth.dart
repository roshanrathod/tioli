import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/cupertino.dart';

abstract class BaseAuthService with ChangeNotifier {
  Future<User> currentUser();
  Future<User> signIn(String email, String password);
  Future<User> updateUser(User user);
  Future<User> createNewUser(
      String nickname, String email, String password);
  //Future<void> signOut();
}

class FirebaseAuthService extends BaseAuthService {
  FirebaseAuthService({Auth firebaseAuth, GoogleAuthProvider googleSignin})
      : _firebaseAuth = firebaseAuth ?? auth();

  final Auth _firebaseAuth;
  @override
  Future<User> createNewUser(
      String nickname,  String email, String password) async {
    try {
      var auth =
          await _firebaseAuth.createUserWithEmailAndPassword(email, password);
      var info = fb.UserProfile();
      info.displayName = '$nickname';
      await auth.user.updateProfile(info);
      updateUser(auth.user);
      return auth.user;
    } catch (e) {
      print('Error in sign in with credentials: $e');
      throw '$e';
    }
  }

  Future<User> currentUser() async {
    return await _firebaseAuth.currentUser;
  }

  Future<User> signIn(String email, String password) async {
    try {
      var auth =
          await _firebaseAuth.signInWithEmailAndPassword(email, password);
          notifyListeners();
      return auth.user;
    } catch (e) {
      throw Exception(e);
    }
  }

  // @override
  // Future<void> signOut() {
  //     _firebaseAuth.signOut();
  //   notifyListeners();
  //   return null;
  // }

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
