import 'package:flutter/material.dart';

import 'gmss_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brilliance Diamond Store',
      theme: ThemeData(
        useMaterial3: true,
        // Using the Teal color scheme from your screenshots
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF009688),
          primary: const Color(0xFF009688),
        ),
      ),
      home: const GmssScreen(),
      // home: DiamondDesign(),
    );
  }
}
