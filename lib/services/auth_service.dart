import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth? _authOverride;

  AuthService({FirebaseAuth? auth}) : _authOverride = auth;

  FirebaseAuth get _auth => _authOverride ?? FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser {
    try {
      return _auth.currentUser;
    } catch (_) {
      return null;
    }
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    await userCredential.user?.updateDisplayName(name.trim());
    return userCredential;
  }

  Future<UserCredential> logIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  static String parseAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'This email address is already registered.';
        case 'invalid-email':
          return 'The email address is invalid.';
        case 'operation-not-allowed':
          return 'Email/Password sign-in is not enabled in Firebase Console.';
        case 'weak-password':
          return 'The password is too weak. Please use a stronger password.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'user-not-found':
          return 'No account found with this email.';
        case 'wrong-password':
        case 'invalid-credential':
          return 'Incorrect email or password. Please try again.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        default:
          return error.message ?? 'An authentication error occurred.';
      }
    }
    return error.toString();
  }
}
