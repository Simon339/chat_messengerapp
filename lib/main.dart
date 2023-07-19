import 'package:chat_messengerapp/theme/darkmode.dart';
import 'package:chat_messengerapp/theme/lightmode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:chat_messengerapp/services/auth/auth_gate/auth.dart';
import 'package:chat_messengerapp/services/auth_service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      theme: lightTheme,
      darkTheme: dartTheme,
      home: AuthGate(),
    );
  }
}
