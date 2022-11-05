import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth fireBaseAuth;

  AuthRepository({FirebaseAuth? fireBaseAuth})
      : fireBaseAuth = fireBaseAuth ?? FirebaseAuth.instance;

  Future<void> signOut() async {
    await fireBaseAuth.signOut();
  }

  bool isSignIn() {
    return getUser() != null;
  }

  User? getUser() {
    return fireBaseAuth.currentUser;
  }
}
