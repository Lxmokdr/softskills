// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:softskills/firebase/user.dart'; // Assuming this is your custom user class
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Function to map Firebase User to custom user class
  use? _userFromFirebaseUser(User? user) {
    // Only return user if email is verified
    return user != null && user.emailVerified ? use(uid: user.uid) : null;
  }

  // Stream to listen to auth state changes and map to custom user class
  Stream<use?> get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future<void> sendEmailVerificationLink() async {
    User? user = _firebaseAuth.currentUser;

    // Check if the user is logged in
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        print("Verification email sent to ${user.email}");
      } catch (e) {
        print("Error sending verification email: $e");
      }
    } else {
      print("No user is logged in or user is already verified.");
    }
  }

Future<use?> signUpWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = result.user;

    // Send email verification
    await sendEmailVerificationLink();

    // Return the user immediately without checking verification
    return use(uid: user!.uid); // This assumes `use` has an initializer for `uid`
  } catch (e) {
    if (e is FirebaseAuthException) {
      if (e.code == 'email-already-in-use') {
        print('The email address is already in use by another account.');
      } else if (e.code == 'invalid-email') {
        print('The email address is not valid.');
      } else if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      }
    }
    print(e.toString());
    return null;
  }
}


Future<use?> logInWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = result.user;

    if (user != null && user.emailVerified) {
      return _userFromFirebaseUser(user);
    } else {
      print("Email not verified. Please verify your email.");
      await signOut();
      return null;
    }
  } catch (e) {
    print(e.toString());
    return null;
  }
}


  // Method to sign out the current user
  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Method to sign in with Google
  Future<use?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/userinfo.profile',
        ],
      );

      // Prompt user to select a Google account
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the Google credential
        UserCredential result = await _firebaseAuth.signInWithCredential(credential);
        
        // Check if the user's email is verified
        if (result.user != null && result.user!.emailVerified) {
          return _userFromFirebaseUser(result.user);
        } else {
          print("Email not verified. Please verify your email.");
          // Optionally sign out the user if not verified
          await signOut();
          return null;
        }
      }
    } catch (error) {
      print(error);
    }
    return null;
  }
}
