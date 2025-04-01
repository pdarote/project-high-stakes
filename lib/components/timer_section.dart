import "package:flutter/material.dart";
import "chess_clock.dart";

class TimerSection extends StatelessWidget {
  final int currentPlayer;
  final int nextPlayer;
  final bool isGameStarted;
  final bool isTimeout;
  final bool isManualPaused;
  final int timerDurationInSeconds;
  final VoidCallback onStartOrEndGame;
  final VoidCallback onSwitchTurn;
  final VoidCallback onTimerTimeout;
  final void Function(bool) timerPause;
  final VoidCallback onPass; // New callback for PASS button

  const TimerSection({
    super.key,
    required this.currentPlayer,
    required this.nextPlayer,
    required this.isGameStarted,
    required this.isTimeout,
    required this.isManualPaused,
    required this.timerDurationInSeconds,
    required this.onStartOrEndGame,
    required this.onSwitchTurn,
    required this.onTimerTimeout,
    required this.timerPause,
    required this.onPass, // Added parameter
  });

  void _showPauseGameModal(BuildContext context) {
    if (!isTimeout) {
      timerPause(true); // Pause the timer before showing the dialog
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Game Paused"),
          content: const Text("Do you want to continue or end the game?"),
          actions: [
            TextButton(
              onPressed: () {
                onStartOrEndGame(); // End the game
                Navigator.of(context).pop();
              },
              child: const Text(
                "End Game",
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (!isTimeout) {
                  timerPause(false); // Continue the timer if paused
                }
                Navigator.of(context).pop();
              },
              child: const Text("Resume"), // Fixed button label
            ),
          ],
        );
      },
    );
  }

  void _showTimeoutOptions(BuildContext context) {
    // Automatically show the dialog when in timeout state
    if (isTimeout) {
      // Use a post-frame callback to avoid showing dialog during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return Dialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Main container with rounded corners
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Player $currentPlayer Timeout",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Pass button changed to TextButton
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                onPass(); // Trigger the pass logic
                              },
                              child: const Text(
                                "Pass",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            // Continue button
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                onSwitchTurn();
                              },
                              child: Text("Continue Player $nextPlayer"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show timeout dialog when in timeout state
    _showTimeoutOptions(context);

    // Define a consistent button style to use for all buttons
    final buttonStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isGameStarted)
          Row(
            children: [
              Expanded(
                child: ChessClock(
                  currentPlayer: currentPlayer,
                  isPaused: isTimeout || isManualPaused,
                  timerDurationInSeconds: timerDurationInSeconds,
                  onTimerReset: onTimerTimeout,
                ),
              ),
              IconButton(
                onPressed: () => _showPauseGameModal(context),
                icon: const Icon(Icons.pause, color: Colors.grey),
                tooltip: "Pause",
              ),
            ],
          ),
        const SizedBox(height: 16),

        // Button section
        if (!isGameStarted)
          SizedBox(
            height: 60,
            child: ElevatedButton(
              onPressed: onStartOrEndGame,
              style: buttonStyle, // Using consistent style
              child: const Text("START GAME"),
            ),
          )
        else if (!isTimeout)
          Column(
            children: [
              SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: onSwitchTurn,
                  style: buttonStyle, // Using consistent style
                  child: const Text("END TURN"),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 60, // Changed from 50 to 60 for consistency
                child: ElevatedButton(
                  onPressed: onPass,
                  style: buttonStyle, // Using consistent style
                  child:
                      const Text("PASS"), // Changed from "PASS ROUND" to "PASS"
                ),
              ),
            ],
          )
        else
          const SizedBox(), // Empty widget when in timeout
      ],
    );
  }
}

/// Helper widget to detect hover state
class _HoverDetector extends StatefulWidget {
  final Widget Function(BuildContext context, bool isHovering) builder;

  const _HoverDetector({required this.builder});

  @override
  State<_HoverDetector> createState() => _HoverDetectorState();
}

class _HoverDetectorState extends State<_HoverDetector> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: widget.builder(context, isHovering),
    );
  }
}
