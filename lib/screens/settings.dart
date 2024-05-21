import 'package:flutter/material.dart';
import '../helpers/prefs.dart';
import '../main.dart';
import '../widgets.dart';
import '../global.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Accordion(
            title: 'Theme',
            body: Column(
              children: <Widget>[
                SliderTheme(
                  data: const SliderThemeData(
                    thumbColor: Colors.red,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 20),
                  ),
                  child: Slider(
                    value: double.parse(Global.seedColor[0]),
                    min: 0,
                    max: 255,
                    divisions: 255,
                    onChanged: (double val) {
                      Global.seedColor[0] = val.toString();
                      setState(() {});
                    },
                  ),
                ),
                SliderTheme(
                  data: const SliderThemeData(
                    thumbColor: Colors.green,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 20),
                  ),
                  child: Slider(
                    value: double.parse(Global.seedColor[1]),
                    min: 0,
                    max: 255,
                    divisions: 255,
                    onChanged: (double val) {
                      Global.seedColor[1] = val.toString();
                      setState(() {});
                    },
                  ),
                ),
                SliderTheme(
                  data: const SliderThemeData(
                    thumbColor: Colors.blue,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 20),
                  ),
                  child: Slider(
                    value: double.parse(Global.seedColor[2]),
                    min: 0,
                    max: 255,
                    divisions: 255,
                    onChanged: (double val) {
                      Global.seedColor[2] = val.toString();
                      setState(() {});
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    PrefsManager.writeData(
                      'seedColor',
                      Global.seedColor,
                    );
                    currentTheme.add(Global.seedColor);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
