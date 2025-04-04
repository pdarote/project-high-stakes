import "package:flutter/material.dart";

class RoundIndicator extends StatelessWidget {
  final int currentRound;
  final List<int?> roundWinners;
  final bool isGameStarted;

  const RoundIndicator({
    super.key,
    required this.currentRound,
    required this.roundWinners,
    required this.isGameStarted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "CURRENT ROUND",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRoundIndicator(1, currentRound == 1, roundWinners[0]),
              const SizedBox(width: 16),
              _buildRoundIndicator(2, currentRound == 2, roundWinners[1]),
              const SizedBox(width: 16),
              _buildRoundIndicator(3, currentRound == 3, roundWinners[2]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoundIndicator(int roundNumber, bool isActive, int? winner) {
    // Use placeholders when game is not started
    if (!isGameStarted) {
      return _buildPlaceholderIndicator();
    }

    Color backgroundColor = Colors.grey.shade300;
    Color textColor = Colors.grey.shade700;

    if (isActive) {
      backgroundColor = Colors.amber.shade200;
      textColor = Colors.brown.shade800;
    } else if (winner != null) {
      // Round already has a winner
      backgroundColor =
          winner == 1 ? Colors.blue.shade100 : Colors.red.shade100;
      textColor = winner == 1 ? Colors.blue.shade800 : Colors.red.shade800;
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? Colors.amber.shade600 : Colors.grey.shade400,
          width: isActive ? 2.0 : 1.0,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
      child: Center(
        child: Text(
          roundNumber.toString(),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderIndicator() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey.shade400,
          width: 1.0,
        ),
      ),
      child: Center(
        child: Text(
          "-",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade500,
          ),
        ),
      ),
    );
  }
}
