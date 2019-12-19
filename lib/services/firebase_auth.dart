import 'package:firebase/firebase.dart';
//import 'package:meta/meta.dart';

class FirebaseAuthService{
   FirebaseAuthService({Auth firebaseAuth, GoogleAuthProvider googleSignin})
      : _firebaseAuth = firebaseAuth?? auth();

  final Auth _firebaseAuth;

Future<UserCredential> createNewUser(
      String email, String password) async {
    try {
      print("trying to add new user from auth service");
      return await _firebaseAuth.createUserWithEmailAndPassword(email, password);
    } catch (e) {
      print('Error in sign in with credentials: $e');
      throw '$e';
    }
  }
}