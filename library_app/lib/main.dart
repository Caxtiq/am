import 'package:flutter/material.dart';
import 'package:library_app/providers/storage.dart';
import 'package:library_app/screens/login_screen.dart';
import 'package:provider/provider.dart';

import './providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Storage().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Library App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
