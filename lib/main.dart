import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:thoughts/dialogs/thoughts/add_thought.dart';
import 'package:thoughts/dialogs/time_tracker/add_time_track.dart';
import 'package:thoughts/firebase_options.dart';
import 'package:thoughts/providers/thought.dart';
import 'package:thoughts/providers/time_track.dart';
import 'package:thoughts/providers/user.dart';
import 'package:thoughts/screens/analysis.dart';
import 'package:thoughts/screens/login.dart';
import 'package:thoughts/screens/settings.dart';
import 'package:thoughts/screens/thoughts.dart';
import 'package:thoughts/screens/time_tracking.dart';
import 'package:thoughts/types/misc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ThoughtsProvider()),
        ChangeNotifierProvider(create: (_) => TimeTracksProvider()),
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
          bodySmall: TextStyle(
            color: Colors.black54,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          headlineMedium: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.inter().fontFamily,
        textTheme: const TextTheme(
          titleSmall: TextStyle(
            color: Colors.white,
            fontSize: 38,
            fontWeight: FontWeight.w500,
          ),
          titleMedium: TextStyle(
            color: Colors.white,
            fontSize: 38,
            fontWeight: FontWeight.w500,
          ),
          titleLarge: TextStyle(
            color: Colors.white,
            fontSize: 38,
            fontWeight: FontWeight.w500,
          ),
          headlineMedium: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w500,
          ),
          bodySmall: TextStyle(
            color: Colors.white38,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          bodyLarge: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.transparent).copyWith(
          background: Colors.black54,
          surface: Colors.black54,
        ),
      ),
      themeMode: ThemeMode.light,
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

    context.read<UserProvider>().initAuth(
      onUserAvailable: () {
        context.read<ThoughtsProvider>().listenForDay(selectedDayTimestamp);
        context.read<TimeTracksProvider>().listenForDay(selectedDayTimestamp);
      },
    );

    context.read<UserProvider>().addListener(() {
      if (context.read<UserProvider>().user == null) {
        setState(() {
          _selectedIndex = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    if (user == null) {
      return const Scaffold(
        body: SafeArea(child: LoginScreen()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thoughts",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 19,
                fontWeight: FontWeight.w500,
              ),
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
                context
                    .read<TimeTracksProvider>()
                    .listenForDay(value.millisecondsSinceEpoch);
              }
            });
          },
          icon: Icon(
            Icons.calendar_month_outlined,
            color: Theme.of(context).textTheme.bodyMedium!.color,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              switch (_selectedIndex) {
                case 0:
                  context.read<ThoughtsProvider>().changeSortOrder(
                      context.read<ThoughtsProvider>().sortOrder ==
                              SortOrder.descending
                          ? SortOrder.ascending
                          : SortOrder.descending);
                  break;
                case 1:
                  context.read<TimeTracksProvider>().changeSortOrder(
                      context.read<TimeTracksProvider>().sortOrder ==
                              SortOrder.descending
                          ? SortOrder.ascending
                          : SortOrder.descending);
                  break;
              }
            },
            icon: (() {
              switch (_selectedIndex) {
                case 0:
                  return Icon(
                    context.watch<ThoughtsProvider>().sortOrder ==
                            SortOrder.descending
                        ? Icons.arrow_downward_outlined
                        : Icons.arrow_upward_outlined,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  );
                case 1:
                  return Icon(
                    context.watch<TimeTracksProvider>().sortOrder ==
                            SortOrder.descending
                        ? Icons.arrow_downward_outlined
                        : Icons.arrow_upward_outlined,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  );
                default:
                  return Container();
              }
            })(),
          ),
        ],
      ),
      floatingActionButton: (() {
        switch (_selectedIndex) {
          case 0:
            return FloatingActionButton(
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
            );
          case 1:
            return FloatingActionButton(
              child: Icon(selectedDayTimestamp == todayTimestamp
                  ? Icons.add
                  : Icons.today_outlined),
              onPressed: () {
                if (selectedDayTimestamp == todayTimestamp) {
                  showAddTimeTrackDialog(
                    context: context,
                    dayTimestamp: selectedDayTimestamp,
                  );
                } else {
                  setState(() {
                    selectedDayTimestamp = todayTimestamp;
                  });
                  context
                      .read<TimeTracksProvider>()
                      .listenForDay(todayTimestamp);
                }
              },
            );
          case 2:
          case 3:
          default:
            return null;
        }
      })(),
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
            selectedIcon: Icon(Icons.timer),
            icon: Icon(Icons.timer_outlined),
            label: 'Tracker',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.analytics),
            icon: Icon(Icons.analytics_outlined),
            label: 'Analysis',
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
            return const TimeTrackingScreen();
          case 2:
            return const AnalysisScreen();
          case 3:
            return const SettingsScreen();
          default:
            return const Placeholder();
        }
      })(),
    );
  }
}
