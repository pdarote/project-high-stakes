import "package:flutter/material.dart";
import "game_table.dart";
import "package:provider/provider.dart";
import "../providers/timer_provider.dart";

class BoardSection extends StatelessWidget {
  final int currentPlayer;
  final bool isGameStarted;
  final void Function(bool) timerPause;

  const BoardSection({
    super.key,
    required this.currentPlayer,
    required this.isGameStarted,
    required this.timerPause,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: Consumer<TimerProvider>(
        builder: (context, timerProvider, child) {
          return GameTable(
            currentPlayer: currentPlayer,
            isGameStarted: isGameStarted,
            timerPause: timerPause,
            pausedTime: timerProvider.formattedTime,
          );
        },
      ),
    );
  }
}
