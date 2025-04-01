import "package:flutter/material.dart";
import "game_table.dart";

class BoardSection extends StatelessWidget {
  final int currentPlayer; // Changed from bool isPlayerOneTurn
  final bool isGameStarted;

  const BoardSection({
    super.key,
    required this.currentPlayer,
    required this.isGameStarted,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: GameTable(
        currentPlayer: currentPlayer,
        isGameStarted: isGameStarted,
      ),
    );
  }
}
