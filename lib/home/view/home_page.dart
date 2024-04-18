import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:super_dash_counter/game/game.dart';
import 'package:super_dash_counter/home/home.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Super Dash Counter',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          NesButton(
            type: NesButtonType.primary,
            onPressed: () {
              Navigator.of(context).push(GamePage.route());
            },
            child: const Text('Lets Count!'),
          ),
          const SizedBox(height: 8),
          NesButton(
            type: NesButtonType.normal,
            onPressed: () {
              SettingsDialog.show(context);
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }
}
