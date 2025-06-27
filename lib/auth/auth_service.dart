import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // TO ACCESS CURRENT USER AT ANY POINT
  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  // Signin Method.
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Create account Method
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
      return await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  // Signout
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  // Change Password
  Future<void> changePassword({
    required String email
  }) async {
      return await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // Change username
  Future<void> changeUsername({
    required String username,
  }) async {
      return await currentUser!.updateDisplayName(username);
  }

  // Delete Useraccount
  Future<void> deleteUser({
    required String email,
    required String password,
  }) async {
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
      await currentUser!.reauthenticateWithCredential(credential);
      await currentUser!.delete();
      await firebaseAuth.signOut();
  }

}
