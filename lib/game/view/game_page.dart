import 'package:flame/game.dart' hide Route;
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:provider/provider.dart';
import 'package:super_dash_counter/game/game.dart';
import 'package:super_dash_counter/repository/repository.dart';

class GamePage extends StatefulWidget {
  const GamePage({
    required this.slot,
    super.key,
  });

  final int slot;

  static Route<void> route(int slot) {
    return NesVerticalCloseTransition.route(pageBuilder: (_, __, ___) {
      return GamePage(slot: slot);
    });
  }

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final SuperDashCounterGame _game;

  late final Future<void> _loadFuture;

  @override
  void initState() {
    super.initState();
    _loadFuture = _loadGame();
  }

  Future<void> _loadGame() async {
    final countRepository = context.read<CountRepository>();
    final count = await countRepository.loadCount(widget.slot);

    _game = SuperDashCounterGame(initialCounter: count);
  }

  @override
  Widget build(BuildContext context) {
    const iconSize = Size.square(48);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder(
              future: _loadFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: NesPixelRowLoadingIndicator());
                }
                return Column(
                  children: [
                    Row(
                      children: [
                        NesButton.icon(
                          type: NesButtonType.normal,
                          icon: NesIcons.leftArrowIndicator,
                          onPressed: () {
                            final counterRepository =
                                context.read<CountRepository>();
                            counterRepository.saveCount(
                                widget.slot, _game.counter.value);
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
                );
              }),
        ),
      ),
    );
  }
}
