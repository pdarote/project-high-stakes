import "package:flutter/material.dart";
import "chess_clock.dart";

class TimerSection extends StatefulWidget {
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
  final VoidCallback onPass;
  final bool player1Passed; // Add this parameter
  final bool player2Passed; // Add this parameter

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
    required this.onPass,
    required this.player1Passed, // Add this param
    required this.player2Passed, // Add this param
  });

  @override
  State<TimerSection> createState() => _TimerSectionState();
}

class _TimerSectionState extends State<TimerSection> {
  bool _timeoutDialogShown = false;

  @override
  void didUpdateWidget(TimerSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if timeout status changed
    if (widget.isTimeout && !oldWidget.isTimeout) {
      _handleTimeout();
    } else if (!widget.isTimeout && oldWidget.isTimeout) {
      _timeoutDialogShown = false;
    }
  }

  void _handleTimeout() {
    if (!_timeoutDialogShown) {
      _timeoutDialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showTimeoutOptions();
        }
      });
    }
  }

  void _showPauseGameModal() {
    if (!widget.isTimeout) {
      // Use post-frame callback for safer state changes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.timerPause(true);
        }
      });
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
                Navigator.of(context).pop();
                widget.onStartOrEndGame();
              },
              child: const Text(
                "End Game",
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (!widget.isTimeout) {
                  widget.timerPause(false);
                }
              },
              child: const Text("Resume"),
            ),
          ],
        );
      },
    );
  }

  void _showTimeoutOptions() {
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
                      "Player ${widget.currentPlayer} Timeout",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            widget.onPass();
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
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            widget.onSwitchTurn();
                          },
                          child: Text("Continue Player ${widget.nextPlayer}"),
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
    ).then((_) {
      // Reset the dialog shown flag when dialog is dismissed
      if (mounted) {
        _timeoutDialogShown = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
        if (widget.isGameStarted)
          Row(
            children: [
              Expanded(
                child: ChessClock(
                  currentPlayer: widget.currentPlayer,
                  isPaused: widget.isTimeout || widget.isManualPaused,
                  timerDurationInSeconds: widget.timerDurationInSeconds,
                  onTimerReset: widget.onTimerTimeout,
                  onTimerPause: widget.timerPause,
                ),
              ),
              IconButton(
                onPressed: () => _showPauseGameModal(),
                icon: const Icon(Icons.pause, color: Colors.grey),
                tooltip: "Pause",
              ),
            ],
          ),
        const SizedBox(height: 16),

        // Button section
        if (!widget.isGameStarted)
          SizedBox(
            height: 60,
            child: ElevatedButton(
              onPressed: widget.onStartOrEndGame,
              style: buttonStyle,
              child: const Text("START GAME"),
            ),
          )
        else if (!widget.isTimeout)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // SizedBox(
              //   height: 60,
              //   child: ElevatedButton(
              //     onPressed: opponentHasPassed
              //         ? null
              //         : widget.onSwitchTurn, // Disable if opponent passed
              //     style: buttonStyle,
              //     child: Text(
              //       opponentHasPassed ? "OPPONENT PASSED" : "END TURN",
              //     ),
              //   ),
              // ),
              const SizedBox(height: 10),
              SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: widget.onPass,
                  style: buttonStyle,
                  child: const Text("PASS"),
                ),
              ),
            ],
          )
        else
          const SizedBox(),
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
