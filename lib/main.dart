import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:note_app/change_notifiers/notes_provider.dart';
import 'package:note_app/core/constants.dart';
import 'package:note_app/pages/log_in.dart';
import 'package:note_app/pages/main_page.dart';
import 'package:note_app/pages/sign_up.dart';
import 'package:provider/provider.dart';
import 'package:note_app/change_notifiers/settings_provider.dart';
Future<void> main() async {
  //Khởi tạo kết nối firebase
  WidgetsFlutterBinding.ensureInitialized(); // Flutter cần khởi tạo binding trước khi sử dụng các API phụ thuộc vào engine.
  await Firebase.initializeApp(); // Giúp kết nối ứng dụng với Firebase. Đảm bảo Firebase được khởi tạo trước khi chạy ứng dụng
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) => NotesProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
        ),
      ],

      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {

          return MaterialApp(

            debugShowCheckedModeBanner: false,

            title: 'Flutter Demo',

            themeMode: settingsProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,

            darkTheme: ThemeData.dark().copyWith(
              textTheme: ThemeData.dark().textTheme.apply(
                fontFamily: 'Poppins',
              ),
            ),

            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
              ),

              useMaterial3: true,

              fontFamily: 'Poppins',

              scaffoldBackgroundColor: background,

              appBarTheme:
              Theme.of(context).appBarTheme.copyWith(
                backgroundColor: Colors.transparent,

                titleTextStyle: TextStyle(
                  color: primary,
                  fontFamily: 'Fredoka',
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            initialRoute: '/login',

            routes: {

              '/login': (context) => LogInPage(),

              '/signup': (context) => SignUpPage(),

              '/main': (context) => MainPage(),
            },
          );
        },
      ),
    );
  }
}
