import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ruas_connect/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  static Future<FirebaseUser> get getCurrentUser {
    return FirebaseAuth.instance.currentUser();
  }

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    final FirebaseUser user =
        await _firebaseAuth.signInWithCredential(credential);

    print('signed in using Google : ${user.email}');

    return user;
  }

  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password) async {
    final FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    print('signed in using Email : ${user.email}');

    return user;
  }

  Future<FirebaseUser> signUpWithEmailAndPassword(
      {String email, String password}) async {
    final FirebaseUser user =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return user;
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<String> getUid() async {
    String uid = (await _firebaseAuth.currentUser()).uid;
    return uid;
  }

  Future<String> getUserEmail() async {
    String email = (await _firebaseAuth.currentUser()).email;
    return email;
  }

  Future<String> getUsername() async {
    String name = (await _firebaseAuth.currentUser()).displayName;
    return name;
  }

  Future<UserDetails> getUserDetails() async {
    final uid = await getUid();
    final userRef = Firestore.instance.collection('users').document(uid);
    final userFirestore = (await userRef.get()).data;
    print('userFirestore : $userFirestore');
    final userData = UserDetails.fromFirestoreDocument(userFirestore);
    if (!UserDetails.isValidUserDetails(userData)) {
      throw UserDetailsFieldException('Exception : { found null fields }');
    } else {
      return userData;
    }
  }

  static Future<void> resetPassword() async {
    String email = (await FirebaseAuth.instance.currentUser()).email;

    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> sendVerificationEmail() async {
    return (await _firebaseAuth.currentUser()).sendEmailVerification();
  }

  Future<bool> get isEmailVerified async {
    return (await _firebaseAuth.currentUser()).isEmailVerified;
  }

  // remove the uid from here or remove the currentUser
  Future<void> updateProfileDetails(
      String uid, String userName, String branch, String semester) async {
    // Update the userProfile
    final currentUser = await _firebaseAuth.currentUser();
    final uidN = currentUser.uid;
    final email = currentUser.email;
    final userInfo = UserUpdateInfo();
    userInfo.displayName = userName;
    await currentUser.updateProfile(userInfo);

    print('Email : $email');

    // Update in Firestore
    final userRef = Firestore.instance.collection('users').document(uidN);
    return await userRef.setData({
      'uid': uidN,
      'userName': userName,
      'branch': branch,
      'semester': semester,
      'email': email,
    }, merge: true);
  }
}
