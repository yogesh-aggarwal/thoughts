import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:thoughts/core/auth.dart';
import 'package:thoughts/firebase_options.dart';
import 'package:thoughts/providers/thought.dart';
import 'package:thoughts/providers/user.dart';
import 'package:thoughts/screens/thoughts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ThoughtsProvider()),
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
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    context.read<UserProvider>().initAuth();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Thoughts",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.transparent),
        useMaterial3: true,
        fontFamily: GoogleFonts.inter().fontFamily,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Thoughts",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.calendar_month_outlined),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: const <NavigationDestination>[
            NavigationDestination(
              selectedIcon: Icon(Icons.psychology),
              icon: Icon(Icons.psychology_alt_outlined),
              label: 'Thoughts',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.settings),
              icon: Icon(Icons.settings_outlined),
              label: 'Settings',
            ),
          ],
        ),
        body: (() {
          switch (_selectedIndex) {
            case 0:
              return const ThoughtsScreen();
            case 1:
              return IconButton(
                onPressed: () {
                  signInWithGoogle();
                },
                icon: Icon(Icons.settings),
              );
            default:
              return const Placeholder();
          }
        })(),
      ),
    );
  }
}
