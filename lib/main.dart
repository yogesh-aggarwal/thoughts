import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:thoughts/dialogs/thoughts/add_thought.dart';
import 'package:thoughts/dialogs/time_tracker/add_time_track.dart';
import 'package:thoughts/core/firebase_options.dart';
import 'package:thoughts/providers/thought.dart';
import 'package:thoughts/providers/time_track.dart';
import 'package:thoughts/providers/user.dart';
import 'package:thoughts/screens/login.dart';
import 'package:thoughts/screens/settings.dart';
import 'package:thoughts/screens/story.dart';
import 'package:thoughts/screens/thoughts.dart';
import 'package:thoughts/screens/time_tracking.dart';
import 'package:thoughts/types/misc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await dotenv.load(fileName: ".env");

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
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          title: "Thoughts",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: lightDynamic,
            useMaterial3: true,
            fontFamily: GoogleFonts.inter().fontFamily,
          ),
          darkTheme: ThemeData(
            colorScheme: darkDynamic,
            useMaterial3: true,
            fontFamily: GoogleFonts.inter().fontFamily,
          ),
          themeMode: ThemeMode.system,
          home: Thoughts(),
        );
      },
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
        context.read<ThoughtsProvider>().listenForDay(selectedDayTimestamp);
        context.read<TimeTracksProvider>().listenForDay(selectedDayTimestamp);
      }
    });
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        "Thoughts",
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 19,
              fontWeight: FontWeight.w500,
            ),
      ),
      centerTitle: true,
      leading: _selectedIndex == 3
          ? Container()
          : IconButton(
              onPressed: () {
                showDatePicker(
                    context: context,
                    initialDate: DateTime.fromMillisecondsSinceEpoch(
                        selectedDayTimestamp),
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
                Clipboard.setData(ClipboardData(text: lastGeneratedContent));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Copied your story to clipboard"),
                  ),
                );
                break;
              case 2:
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
                  Icons.copy,
                  size: 22,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                );
              case 2:
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
    );
  }

  Widget? _buildFloatingActionButton() {
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
        break;
      case 2:
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
              context.read<TimeTracksProvider>().listenForDay(todayTimestamp);
            }
          },
        );
      case 3:
      default:
        return null;
    }
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const ThoughtsScreen();
      case 1:
        return const StoryScreen();
      case 2:
        return const TimeTrackingScreen();
      case 3:
        return const SettingsScreen();
      default:
        return const Placeholder();
    }
  }

  Widget _buildBottomNavigationBar() {
    return NavigationBar(
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
          selectedIcon: Icon(Icons.waterfall_chart_rounded),
          icon: Icon(Icons.waterfall_chart_rounded),
          label: 'My Story',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.timer),
          icon: Icon(Icons.timer_outlined),
          label: 'Tracker',
        ),
        // NavigationDestination(
        //   selectedIcon: Icon(Icons.analytics),
        //   icon: Icon(Icons.analytics_outlined),
        //   label: 'Analysis',
        // ),
        NavigationDestination(
          selectedIcon: Icon(Icons.settings),
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
    );
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
      appBar: _buildAppBar(),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: _buildBody(),
    );
  }
}
