  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_auth/firebase_auth.dart';

  class AuthServices {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    Future<String> signUPUser({
      required String email,
      required String password,
      required String name, required String phone,
    }) async {
      String res = "Some Error Occurred";
      try {
        if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
          UserCredential credential = await _auth.createUserWithEmailAndPassword(
              email: email, password: password);
          await _firestore.collection("users").doc(credential.user!.uid).set({
            'name': name,
            'email': email,
            'phone': phone,
            'uid': credential.user!.uid,
          });
          res = "Successfully SignUp";
        }
      } catch (e) {
        return e.toString();
      }
      return res;
    }

    Future<String> loginUser({
      required String email,
      required String password,
    }) async {
      String res = "Some Error Occurred !!!";
      try {
        if (email.isNotEmpty && password.isNotEmpty) {
          await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          res = "Successful Login";
        } else {
          res = "Please Enter all the Field";
        }
      } catch (e) {
        return e.toString();
      }
      return res;
    }
    Future<void> signOut() async{
      await _auth.signOut();
    }
  }
