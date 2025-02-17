import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class Auth {
  final FirebaseAuth _firebaseAuth;

  Auth() : _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Xử lý lỗi đăng nhập
      if (e.code == 'user-not-found') {
        throw Exception('user not found.');
      } else if (e.code == 'wrong-password') {
        throw Exception('wrong-password. try again');
      } else if (e.code == 'invalid-email') {
        throw Exception('invalid-email');
      } else {
        // Lỗi chung khác
        throw Exception('${e.message}');
      }
    } catch (e) {
      // Xử lý lỗi không phải từ Firebase
      throw Exception('Lỗi không xác định');
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      if (!_isValidEmail(email)) {
        throw Exception('Email không đúng định dạng.');
      }
      if (password.length < 6) {
        throw Exception('Mật khẩu phải dài ít nhất 6 ký tự.');
      }

      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception('${e.message}');
    }
  }
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }
}

Future<String?> getUserUID() async {
  await Future.delayed(Duration(seconds: 1)); // Chờ 1 giây (tuỳ chọn)
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    print("User UID: ${user.uid}");
    return user.uid; // Trả về UID dưới dạng String
  } else {
    print("No user is signed in.");
    return null; // Trả về null nếu không có người dùng
  }
}
