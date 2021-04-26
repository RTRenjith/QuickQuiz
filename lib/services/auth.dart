import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_quiz/models/user.dart';
import 'package:quick_quiz/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //covert firebase user to custom user model
  CustomUser _customUserfromFBUser(User user) {
    return user != null ? CustomUser(uid: user.uid,isverified: user.emailVerified) : null;
  }

  //auth change user stream
  Stream<CustomUser> get user {
    return _auth
        .authStateChanges()
        .map(_customUserfromFBUser);
  }

  //anon
  // Future signInAnon() async {
  //   try {
  //     UserCredential result = await _auth.signInAnonymously();
  //     User userdata = result.user;
  //     return _customUserfromFBUser(userdata);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }


  //sign in
  Future signInwithEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User userdata = result.user;
      return _customUserfromFBUser(userdata);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register
  Future registerwithEmailandPassword(String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password).whenComplete(() => _auth.currentUser.sendEmailVerification()).whenComplete(signOut);
      User userdata = result.user;
      await DatabaseService(uid: userdata.uid).addUserData(username);
      return  _customUserfromFBUser(userdata);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
