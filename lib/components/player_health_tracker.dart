import "package:flutter/material.dart";

class PlayerHealthTracker extends StatelessWidget {
  final int playerNumber;
  final bool isGameStarted;
  final int lostRounds;
  final int? firstPlayerToPassed;
  final int currentRound;
  final bool hasPassed; // New parameter

  const PlayerHealthTracker({
    super.key,
    required this.playerNumber,
    required this.isGameStarted,
    required this.lostRounds,
    this.firstPlayerToPassed,
    required this.currentRound,
    required this.hasPassed, // Add this parameter
  });

  @override
  Widget build(BuildContext context) {
    // Use consistent MaterialColors for player theming
    final MaterialColor playerColor =
        playerNumber == 1 ? Colors.blue : Colors.red;
    final Color playerTextColor =
        playerNumber == 1 ? Colors.blue.shade800 : Colors.red.shade800;

    // Only count officially completed rounds for health display
    // (don't reduce health immediately when a player passes first)
    final int totalHealthLost = lostRounds;

    // Player is still in the game if they haven't lost 2 rounds
    final bool isPlaying = isGameStarted && totalHealthLost < 2;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: isGameStarted && hasPassed
            ? playerColor.shade50 // Light background color when passed
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: isGameStarted && hasPassed
              ? playerColor.shade300 // Colored border when passed
              : Colors.grey.shade300,
          width: isGameStarted && hasPassed ? 2.0 : 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Player label and passed indicator
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
              // Show "PASSED" indicator when the player has passed
              if (isGameStarted && hasPassed)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: playerColor.shade100,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: playerColor.shade400),
                  ),
                  child: Text(
                    "PASSED",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: playerTextColor,
                    ),
                  ),
                ),
            ],
          ),

          // Health indicators (always shown)
          Row(
            children: [
              _buildHealthIndicator(
                  isGameStarted
                      ? totalHealthLost < 1
                      : false, // Only filled if game started and no rounds lost
                  playerColor,
                  playerTextColor),
              const SizedBox(width: 8),
              _buildHealthIndicator(
                  isGameStarted
                      ? totalHealthLost < 2
                      : false, // Only filled if game started and less than 2 rounds lost
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
