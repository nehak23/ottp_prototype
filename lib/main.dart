import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ottp_prototype/home_page.dart';
import 'package:ottp_prototype/utils/text_constants.dart';

void main() {
  runApp(const OTTApp());
}

class OTTApp extends StatelessWidget {
  const OTTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TextConstants.ottPrototypeText,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFFE50914),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme)
            .copyWith(
              headlineMedium: GoogleFonts.bebasNeue(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              titleLarge: GoogleFonts.bebasNeue(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              bodyLarge: GoogleFonts.openSans(color: Colors.white),
            ),
      ),
      home: const HomePage(),
    );
  }
}
