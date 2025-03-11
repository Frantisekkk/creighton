import 'package:flutter/material.dart';
import 'package:flutter_application_1/navigation/AppWrapper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/state/AppState.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Remove any stored JWT token on startup
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('jwt_token');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()), // Global State
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppWrapper(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
