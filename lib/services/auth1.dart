  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_auth/firebase_auth.dart';

  class AuthNgoServices {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    // Sign Up Method
    Future<String> signUpNgo({
      required String email,
      required String password,
      required String name,
      required String mobile,
      required String address,

    }) async {
      String res = "An error occurred";
      try {
        if (email.isNotEmpty &&
            password.isNotEmpty &&
            name.isNotEmpty &&
            mobile.isNotEmpty &&
            address.isNotEmpty) {
          // Create user in Firebase Authentication
          UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          // Add user data to Firestore
          await _firestore.collection("NgoUsers").doc(credential.user!.uid).set({
            'name': name,
            'email': email,
            'mobile': mobile,
            'address': address,
            'uid': credential.user!.uid,
          });

          res = "Successfully Signed Up";
        } else {
          res = "Please fill in all fields";
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          res = "Email is already registered";
        } else if (e.code == 'weak-password') {
          res = "Password is too weak";
        } else {
          res = e.message ?? "An error occurred";
        }
      } catch (e) {
        res = "An error occurred: ${e.toString()}";
      }
      return res;
    }

    // Login Method
    Future<String> loginNgo({
      required String email,
      required String password,
    }) async {
      String res = "An error occurred";
      try {
        if (email.isNotEmpty && password.isNotEmpty) {
          // Authenticate user with Firebase
          await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          res = "Successful Login";
        } else {
          res = "Please enter all fields";
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          res = "No user found for that email";
        } else if (e.code == 'wrong-password') {
          res = "Incorrect password";
        } else if (e.code == 'invalid-email') {
          res = "Invalid email format";
        } else {
          res = e.message ?? "An error occurred";
        }
      } catch (e) {
        res = "An error occurred: ${e.toString()}";
      }
      return res;
    }
  }
