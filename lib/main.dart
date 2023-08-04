import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:thoughts/dialogs/add_thought.dart';
import 'package:thoughts/firebase_options.dart';
import 'package:thoughts/providers/thought.dart';
import 'package:thoughts/providers/user.dart';
import 'package:thoughts/screens/settings.dart';
import 'package:thoughts/screens/thoughts.dart';
import 'package:thoughts/types/misc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ThoughtsProvider()),
      ],
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

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
      home: Thoughts(),
    );
  }
}

class Thoughts extends StatefulWidget {
  const Thoughts({super.key});

  @override
  State<Thoughts> createState() => _ThoughtsState();
}

class _ThoughtsState extends State<Thoughts> {
  int _selectedIndex = 0;
  int selectedDayTimestamp = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  ).millisecondsSinceEpoch;
  final todayTimestamp = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  ).millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();

    context.read<UserProvider>().initAuth();
    context.read<ThoughtsProvider>().listenForDay(selectedDayTimestamp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Thoughts",
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            showDatePicker(
                context: context,
                initialDate:
                    DateTime.fromMillisecondsSinceEpoch(selectedDayTimestamp),
                firstDate: DateTime(
                  DateTime.now().year - 10,
                  DateTime.now().month,
                  DateTime.now().day,
                ),
                lastDate: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                )).then((value) {
              if (value != null) {
                setState(() {
                  selectedDayTimestamp = value.millisecondsSinceEpoch;
                });
                context
                    .read<ThoughtsProvider>()
                    .listenForDay(value.millisecondsSinceEpoch);
              }
            });
          },
          icon: const Icon(Icons.calendar_month_outlined),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<ThoughtsProvider>().changeSortOrder(
                  context.read<ThoughtsProvider>().sortOrder ==
                          SortOrder.descending
                      ? SortOrder.ascending
                      : SortOrder.descending);
            },
            icon: Icon(context.watch<ThoughtsProvider>().sortOrder ==
                    SortOrder.descending
                ? Icons.arrow_downward_outlined
                : Icons.arrow_upward_outlined),
          ),
        ],
      ),
      floatingActionButton: _selectedIndex != 0
          ? null
          : FloatingActionButton(
              child: Icon(selectedDayTimestamp == todayTimestamp
                  ? Icons.add
                  : Icons.today_outlined),
              onPressed: () {
                if (selectedDayTimestamp == todayTimestamp) {
                  showAddThoughtDialog(
                    context: context,
                    dayTimestamp: selectedDayTimestamp,
                  );
                } else {
                  setState(() {
                    selectedDayTimestamp = todayTimestamp;
                  });
                  context.read<ThoughtsProvider>().listenForDay(todayTimestamp);
                }
              },
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
            return const SettingsScreen();
          default:
            return const Placeholder();
        }
      })(),
    );
  }
}
