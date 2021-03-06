import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/controllers/user_preferences.dart';
import 'package:guideme/screens/mainpage.dart';
import 'package:guideme/services/notificationservice.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await UserPrederences.init();

  await NotificationService().init();

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
