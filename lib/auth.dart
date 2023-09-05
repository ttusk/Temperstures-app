import 'package:firebase_auth/firebase_auth.dart';

class Auth{
  FirebaseAuth _auth = FirebaseAuth.instance;

  //sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }catch(e){
      print("some error occured");
    }
    return null;
  }

  //sing in anon
  Future signInAnon() async {
    try{
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    }catch(e){
      print(e.toString());
      return null;

    }
  }

}

