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
        children: [
          const SizedBox(height: 16),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: NesContainer(
                width: double.infinity,
                child: Image.asset(
                  'assets/images/title.png',
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NesButton(
                  type: NesButtonType.primary,
                  onPressed: () {
                    Navigator.of(context).push(GamePage.route(0));
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
          ),
        ],
      ),
    );
  }
}
