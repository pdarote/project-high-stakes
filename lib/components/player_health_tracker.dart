import "package:flutter/material.dart";

class PlayerHealthTracker extends StatelessWidget {
  final int playerNumber;
  final bool isGameStarted;
  final int lostRounds;

  const PlayerHealthTracker({
    super.key,
    required this.playerNumber,
    required this.isGameStarted,
    required this.lostRounds,
  });

  @override
  Widget build(BuildContext context) {
    // Use consistent MaterialColors for player theming
    final MaterialColor playerColor =
        playerNumber == 1 ? Colors.blue : Colors.red;
    final Color playerTextColor =
        playerNumber == 1 ? Colors.blue.shade800 : Colors.red.shade800;

    // Player is still in the game if they haven't lost 2 rounds
    final bool isPlaying = isGameStarted && lostRounds < 2;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Player label
          Row(
            children: [
              Icon(
                Icons.person,
                size: 16,
                color: isGameStarted
                    ? (isPlaying ? playerColor : Colors.grey)
                    : Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                "PLAYER $playerNumber",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isGameStarted
                      ? (isPlaying ? playerTextColor : Colors.grey)
                      : Colors.grey,
                ),
              ),
            ],
          ),

          // Health indicators (always shown)
          Row(
            children: [
              _buildHealthIndicator(
                  isGameStarted
                      ? lostRounds < 1
                      : false, // Only filled if game started and round not lost
                  playerColor,
                  playerTextColor),
              const SizedBox(width: 8),
              _buildHealthIndicator(
                  isGameStarted
                      ? lostRounds < 2
                      : false, // Only filled if game started and round not lost
                  playerColor,
                  playerTextColor),
            ],
          ),
        ],
      ),
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
