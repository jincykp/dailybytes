import 'package:dailybytes/view/screens/home_screen.dart';
import 'package:dailybytes/viewmodel/article_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ArticleProvider(),
      child: MaterialApp(
        title: 'Daily Bytes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          cardTheme: CardTheme(
            elevation: 1,
            shadowColor: Colors.black.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          appBarTheme: AppBarTheme(
            centerTitle: false,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          textTheme: TextTheme(
            titleLarge: TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
            titleMedium: TextStyle(fontWeight: FontWeight.w500),
            bodyLarge: TextStyle(height: 1.5),
            bodyMedium: TextStyle(height: 1.4),
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          cardTheme: CardTheme(
            elevation: 1,
            shadowColor: Colors.black.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          textTheme: TextTheme(
            titleLarge: TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
            titleMedium: TextStyle(fontWeight: FontWeight.w500),
            bodyLarge: TextStyle(height: 1.5),
            bodyMedium: TextStyle(height: 1.4),
          ),
        ),
        themeMode: ThemeMode.system,
        home: HomeScreen(),
      ),
    );
  }
}
