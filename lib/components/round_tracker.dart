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
    // Calculate how many rounds each player has lost
    int player1LostRounds = roundWinners.where((winner) => winner == 2).length;
    int player2LostRounds = roundWinners.where((winner) => winner == 1).length;

    // Use MaterialColors instead of regular Colors
    final player1Color = Colors.blue;
    final player2Color = Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "PLAYER HEALTH",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),

          // Player 2 health row (top)
          _buildPlayerHealthRow(
            playerNumber: 2,
            lostRounds: player2LostRounds,
            isPlaying: currentRound <= 3 && player2LostRounds < 2,
            baseColor: player2Color,
            textColor: player2Color.shade800,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0),
            child: Divider(height: 1, thickness: 1, color: Colors.grey),
          ),

          // Player 1 health row (bottom)
          _buildPlayerHealthRow(
            playerNumber: 1,
            lostRounds: player1LostRounds,
            isPlaying: currentRound <= 3 && player1LostRounds < 2,
            baseColor: player1Color,
            textColor: player1Color.shade800,
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerHealthRow({
    required int playerNumber,
    required int lostRounds,
    required bool isPlaying,
    required MaterialColor baseColor,
    required Color textColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Player label
        Row(
          children: [
            Icon(
              Icons.person,
              size: 16,
              color: isPlaying ? baseColor : Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              "PLAYER $playerNumber",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isPlaying ? textColor : Colors.grey,
              ),
            ),
          ],
        ),

        // Health indicators
        Row(
          children: [
            _buildHealthIndicator(lostRounds < 1, baseColor, textColor),
            const SizedBox(width: 8),
            _buildHealthIndicator(lostRounds < 2, baseColor, textColor),
          ],
        ),
      ],
    );
  }

  Widget _buildHealthIndicator(
      bool isFilled, MaterialColor baseColor, Color borderColor) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFilled ? baseColor : Colors.transparent,
        border: Border.all(
          color: isFilled ? borderColor : Colors.grey,
          width: 2,
        ),
      ),
    );
  }
}
