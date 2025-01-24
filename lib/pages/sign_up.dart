import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/sevices/auth.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = Auth();

  String _errorMessage = '';
  bool _isLoading = false;

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true; // Bắt đầu quá trình đăng ký
    });

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Chuyển hướng tới trang chính sau khi đăng ký thành công
      Navigator.pushReplacementNamed(context, '/main');
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
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text("Sign Up"),
        backgroundColor: Colors.deepOrange,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
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
                    "Create a New Account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
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
                        borderSide: BorderSide(color: Colors.deepOrange),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange, // Màu nền của nút
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white) // Hiển thị loader khi đang đăng ký
                        : Text('Sign Up'),
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
                      "Already have an account? Log In",
                      style: TextStyle(color: Colors.deepOrange),
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
