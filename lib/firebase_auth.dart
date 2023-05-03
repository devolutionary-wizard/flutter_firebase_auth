import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Authentication {
  static Future<User?> register(
      {required String name,
      required String email,
      required String password}) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
      await user?.reload();
      user = firebaseAuth.currentUser;
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('=' * 40);
        debugPrint('The password provided is too weak.');
        debugPrint('=' * 40);
      } else if (e.code == 'email-already-in-use') {
        debugPrint('=' * 40);
        debugPrint('The account already exists for that email.');
        debugPrint('=' * 40);
      }
    } catch (e) {
      rethrow;
    }
    return user;
  }

  static Future<User?> login({required String email, required password}) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided.');
      }
    } catch (e) {
      rethrow;
    }
    return user;
  }

  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }
}
