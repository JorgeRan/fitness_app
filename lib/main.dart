import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/auth_gate.dart';
import 'package:fitness_app/authentication.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'routine_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RoutineData(),
      child: Provider<AuthenticationService>(
        create: (_) => AuthenticationService(FirebaseAuth.instance, GoogleSignIn()),
        child: MaterialApp(
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFF478CCF),
            textTheme: GoogleFonts.robotoTextTheme(),
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0XFF36C2CE)),
          ),
          home: const AuthGate(),
        ),
      ),
    );
  }
}
