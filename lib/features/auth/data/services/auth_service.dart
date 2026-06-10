import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/constants/google_auth_config.dart';
import '../models/user_model.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rxn<UserModel> user = Rxn<UserModel>();

  Future<AuthService> init() async {
    await GoogleSignIn.instance.initialize(
      serverClientId: GoogleAuthConfig.serverClientId,
    );

    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      user.value = await _fetchUser(firebaseUser);
    }
    return this;
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      final googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      final firebaseUser = result.user;
      if (firebaseUser == null) {
        throw Exception('Sign in failed');
      }

      final profile = await _syncUser(firebaseUser);
      user.value = profile;
      return profile;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw Exception('Sign in cancelled');
      }
      throw Exception(e.description ?? 'Google sign in failed');
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _auth.signOut();
    user.value = null;
  }

  Future<UserModel> updateRole(String role) async {
    final current = user.value;
    if (current == null) {
      throw Exception('No user logged in');
    }

    await _firestore.collection('users').doc(current.uid).update({'role': role});
    final updated = current.copyWith(role: role);
    user.value = updated;
    return updated;
  }

  Future<UserModel> _syncUser(User firebaseUser) async {
    final doc = _firestore.collection('users').doc(firebaseUser.uid);
    final snapshot = await doc.get();

    if (snapshot.exists) {
      return UserModel.fromMap(firebaseUser.uid, snapshot.data()!);
    }

    final profile = UserModel(
      uid: firebaseUser.uid,
      name: firebaseUser.displayName ?? 'User',
      email: firebaseUser.email ?? '',
      photoUrl: firebaseUser.photoURL,
      role: 'buyer',
    );

    await doc.set(profile.toMap());
    return profile;
  }

  Future<UserModel> _fetchUser(User firebaseUser) async {
    final snapshot =
        await _firestore.collection('users').doc(firebaseUser.uid).get();

    if (snapshot.exists) {
      return UserModel.fromMap(firebaseUser.uid, snapshot.data()!);
    }

    return _syncUser(firebaseUser);
  }
}
