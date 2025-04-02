import "package:flutter/material.dart";
import "game_table.dart";

class BoardSection extends StatelessWidget {
  final int currentPlayer; // Changed from bool isPlayerOneTurn
  final bool isGameStarted;
  final void Function(bool) timerPause;
  final int? pausedTime; // Added pausedTime parameter

  const BoardSection({
    super.key,
    required this.currentPlayer,
    required this.isGameStarted,
    required this.timerPause,
    required this.pausedTime, // Added parameter
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: GameTable(
        currentPlayer: currentPlayer,
        isGameStarted: isGameStarted,
        timerPause: timerPause,
        pausedTime: pausedTime, // Pass pausedTime to GameTable
      ),
    );
  }
}
