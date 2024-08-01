import 'package:fitness_app/screens/log_in.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'routine_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyADUUpBtWqUVBboA6BJqavsT8c0AFRa5c0",
          appId: "1:983797582372:android:43b71d43db18dab36326b1",
          messagingSenderId: "983797582372",
          projectId: "fitness-app-d3545"),);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RoutineData(),
      
      
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF478CCF),
          textTheme: GoogleFonts.robotoTextTheme(),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0XFF36C2CE)),
        ),
        home: const LogIn(),
      ),
    );
  }
}
