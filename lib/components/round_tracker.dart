import "package:flutter/material.dart";

class RoundTracker extends StatelessWidget {
  final int currentRound;
  final List<int?> roundWinners;

  const RoundTracker({
    super.key,
    required this.currentRound,
    required this.roundWinners,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRoundIndicator(1, roundWinners[0]),
              const SizedBox(width: 12),
              _buildRoundIndicator(2, roundWinners[1]),
              const SizedBox(width: 12),
              _buildRoundIndicator(3, roundWinners[2]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoundIndicator(int roundNumber, int? winner) {
    Color backgroundColor;
    Color borderColor;

    if (winner == null) {
      // Not decided yet
      backgroundColor = roundNumber == currentRound
          ? Colors.yellow.shade100 // Current round
          : Colors.grey.shade200; // Future round
      borderColor = roundNumber == currentRound
          ? Colors.yellow.shade700
          : Colors.grey.shade400;
    } else if (winner == 1) {
      // Player 1 won
      backgroundColor = Colors.blue.shade100;
      borderColor = Colors.blue.shade700;
    } else {
      // Player 2 won
      backgroundColor = Colors.red.shade100;
      borderColor = Colors.red.shade700;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Center(
        child: winner != null
            ? Text(
                winner.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:
                      winner == 1 ? Colors.blue.shade800 : Colors.red.shade800,
                ),
              )
            : Text(
                roundNumber.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: roundNumber == currentRound
                      ? Colors.orange.shade800
                      : Colors.grey.shade600,
                ),
              ),
      ),
    );
  }
}
