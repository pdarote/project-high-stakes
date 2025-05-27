import "package:flutter/material.dart";
import "game_table.dart";
import "package:provider/provider.dart";
import "../providers/timer_provider.dart";

class BoardSection extends StatelessWidget {
  final int currentPlayer;
  final bool isGameStarted;
  final void Function(bool) timerPause;
  final bool player1Passed;
  final bool player2Passed;
  final VoidCallback onCardPlayed;

  const BoardSection({
    super.key,
    required this.currentPlayer,
    required this.isGameStarted,
    required this.timerPause,
    required this.player1Passed,
    required this.player2Passed,
    required this.onCardPlayed,
  });

  @override
  Widget build(BuildContext context) {
    final bool opponentPassed =
        currentPlayer == 1 ? player2Passed : player1Passed;

    return SizedBox(
      height: 360,
      child: Consumer<TimerProvider>(
        builder: (context, timerProvider, child) {
          return GameTable(
            currentPlayer: currentPlayer,
            isGameStarted: isGameStarted,
            timerPause: timerPause,
            pausedTime: timerProvider.formattedTime,
            opponentPassed: opponentPassed,
            onCardPlayed: onCardPlayed,
          );
        },
      ),
    );
  }
}
