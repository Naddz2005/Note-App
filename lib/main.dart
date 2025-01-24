import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:note_app/core/constants.dart';
import 'package:note_app/pages/log_in.dart';
import 'package:note_app/pages/main_page.dart';
import 'package:note_app/pages/sign_up.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: background,
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              backgroundColor: Colors.transparent,
              titleTextStyle: TextStyle(
                color: primary,
                fontFamily: 'Fredoka',
                fontSize: 32,
                fontWeight: FontWeight.w600
              ),
            ),
      ),
      initialRoute: '/login', // Trang đầu tiên khi ứng dụng chạy
      routes: {
        '/login': (context) => LogInPage(), // Route trang đăng nhập
        '/signup': (context) => SignUpPage(), // Route trang đăng ký
        '/main': (context) => MainPage(), // Route trang MainPage
      },
    );
  }
}
