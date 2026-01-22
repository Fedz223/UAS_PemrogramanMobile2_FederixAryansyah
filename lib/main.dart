import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lumiere/firebase_options.dart';
import 'package:lumiere/features/auth/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const LumiereApp());
}

class LumiereApp extends StatelessWidget {
  const LumiereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LUMIÈRE',
      theme: ThemeData(useMaterial3: true),
      home: const AuthGate(),
    );
  }
}   
