import 'dart:async';

import 'package:flutter/material.dart';

import '../global.dart';
import 'helpers/prefs.dart';
import 'screens/home.dart';
import 'screens/player.dart';
import 'screens/search.dart';
import 'screens/settings.dart';
import 'screens/library.dart';
import 'screens/subscriptions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Global.searchList = await PrefsManager.readData('searchList') ?? <String>[];
  Global.seedColor =
      await PrefsManager.readData('seedColor') ?? Global.seedColor;
  runApp(const MyApp());
}

StreamController<List<String>> currentTheme = StreamController<List<String>>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      initialData: Global.seedColor,
      stream: currentTheme.stream,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Luxview',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(
                255,
                double.parse(snapshot.data?[0] ?? Global.seedColor[0]).toInt(),
                double.parse(snapshot.data?[1] ?? Global.seedColor[1]).toInt(),
                double.parse(snapshot.data?[2] ?? Global.seedColor[2]).toInt(),
              ),
            ),
          ),
          routes: <String, WidgetBuilder>{
            '/': (BuildContext context) => const Luxview(),
            'home_page': (BuildContext context) => const HomePage(),
            'search_page': (BuildContext context) => const SearchPage(),
            'player_page': (BuildContext context) => const PlayerPage(),
            'settings_page': (BuildContext context) => const SettingsPage(),
          },
        );
      },
    );
  }
}

class Luxview extends StatefulWidget {
  const Luxview({super.key});
  @override
  State<Luxview> createState() => _LuxviewState();
}

class _LuxviewState extends State<Luxview> {
  int _currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    Widget currentWidget = const HomePage();
    switch (_currentIndex) {
      case 0:
        currentWidget = const SubscriptionsPage();
        break;
      case 1:
        currentWidget = const HomePage();
        break;
      case 2:
        currentWidget = const LibraryPage();
        break;
    }
    return Scaffold(
      body: currentWidget,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() => _currentIndex = index);
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_rounded),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions_rounded),
            label: 'Subscriptions',
          ),
        ],
      ),
    );
  }
}
