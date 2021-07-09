import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/controllers/user_preferences.dart';
import 'package:guideme/screens/homepage.dart';
import 'package:guideme/screens/mainpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await UserPrederences.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: MainScreen(),
    );
  }
}
