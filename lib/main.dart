import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thoughts/providers/user.dart';
import 'package:thoughts/screens/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Thoughts(),
    ),
  );
}

class Thoughts extends StatefulWidget {
  const Thoughts({super.key});

  @override
  State<Thoughts> createState() => _ThoughtsState();
}

class _ThoughtsState extends State<Thoughts> {
  @override
  void initState() {
    super.initState();

    context.read<UserProvider>().initAuth();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Thoughts",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: GoogleFonts.inter().fontFamily,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
