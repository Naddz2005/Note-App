import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/core/constants.dart';
import 'package:note_app/sevices/auth.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = Auth();

  bool _obscureText = true; // Trạng thái ẩn mật khẩu
  String _errorMessage = '';
  bool _isLoading = false;

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true; // Bắt đầu quá trình đăng ký
    });

    try {
      // Đăng ký tài khoản và lấy UserCredential
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Lấy user mới từ UserCredential
      User? newUser = userCredential.user;

      if (newUser != null) {
        // Kết nối Firebase Database
        final databaseReference = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
          "https://note-app-70fe2-default-rtdb.asia-southeast1.firebasedatabase.app",
        ).ref("Note_App");

        // Thêm user vào database
        DatabaseReference userRef = databaseReference.child(newUser.uid);
        await userRef.set({
          "notes": {}, // Node rỗng để chứa ghi chú
          "email": newUser.email,  // Lưu email vào database
          "createdAt": DateTime.now().toIso8601String(), // Thời gian tạo tài khoản
        });

        print("User registered and added to database: ${newUser.uid}");

        // Chuyển hướng sau khi đăng ký thành công
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        throw Exception("Không thể lấy thông tin người dùng sau khi đăng ký.");
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString(); // Hiển thị lỗi nếu có
      });
    } finally {
      setState(() {
        _isLoading = false; // Kết thúc quá trình đăng ký
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đăng kí"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Tạo tài khoản mới",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primary)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: primary),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primary)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: primary),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              icon: Icon(_obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility))),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary, // Màu nền của nút
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(
                              color: Colors
                                  .white) // Hiển thị loader khi đang đăng ký
                          : Text(
                              'Đăng kí',
                              style: TextStyle(color: white),
                            ),
                    ),
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text(
                        "Đã có tài khoản? Đăng nhập",
                        style: TextStyle(color: black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
