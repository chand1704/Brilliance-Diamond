import 'package:brilliance_diamond/diamonds_details_pages.dart';
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF009688),
          // primary: const Color(0xFF009688),
        ),
      ),
      onGenerateRoute: (settings) {
        if (settings.name != null && settings.name!.startsWith('/details')) {
          final uri = Uri.parse(settings.name!);
          final stoneId = uri.queryParameters['id'];
          // return MaterialPageRoute(builder: (_) => const GmssScreen());

          // return MaterialPageRoute(
          //   builder: (_) => DiamondDetailScreen(
          //     stoneId: stoneId,
          //     isFavorite: false,
          //     onFavoriteToggle: (val) {},
          //     stone: null,
          //   ),
          // );
          return PageRouteBuilder(
            settings: settings,
            transitionDuration: Duration.zero,
            // reverseTransitionDuration: Duration.zero,
            pageBuilder: (_, __, ___) => DiamondDetailScreen(
              stoneId: stoneId,
              stone: null,
              isFavorite: false,
              onFavoriteToggle: (val) {},
            ),
            // transitionsBuilder: (_, animation, __, child) =>
            //     FadeTransition(opacity: animation, child: child),
          );
        }
        return null;
      },
      home: const GmssScreen(),
    );
  }
}
