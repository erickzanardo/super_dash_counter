import 'package:flame/game.dart' hide Route;
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:super_dash_counter/game/game.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  static Route<void> route() {
    return NesVerticalCloseTransition.route(pageBuilder: (_, __, ___) {
      return const GamePage();
    });
  }

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final _game = SuperDashCounterGame();

  @override
  Widget build(BuildContext context) {
    const iconSize = Size.square(48);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  NesButton.icon(
                    type: NesButtonType.normal,
                    icon: NesIcons.leftArrowIndicator,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Super Dash Counter',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              NesDropshadow(
                child: NesWindow(
                  title: 'Counter',
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ValueListenableBuilder<int>(
                      valueListenable: _game.counter,
                      builder: (context, value, child) {
                        return Text(
                          value.toString(),
                          style: Theme.of(context).textTheme.titleMedium,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: NesDropshadow(
                  child: ClipRect(child: GameWidget(game: _game)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      NesPressable(
                        child: NesIcon(
                          size: iconSize,
                          iconData: NesIcons.leftArrowIndicator,
                        ),
                        onPressStart: () {
                          _game.startMoving(-1);
                        },
                        onPressEnd: () {
                          _game.stopMoving(-1);
                        },
                      ),
                      const SizedBox(width: 16),
                      NesPressable(
                        child: NesIcon(
                          size: iconSize,
                          iconData: NesIcons.rightArrowIndicator,
                        ),
                        onPressStart: () {
                          _game.startMoving(1);
                        },
                        onPressEnd: () {
                          _game.stopMoving(1);
                        },
                      ),
                    ],
                  ),
                  NesPressable(
                    child: NesIcon(
                      size: iconSize,
                      iconData: NesIcons.topArrowIndicator,
                    ),
                    onPress: () {
                      _game.jump();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
