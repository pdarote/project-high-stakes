import "package:flutter/material.dart";
import "dart:async";
import "package:provider/provider.dart";
import "../providers/timer_provider.dart";

class ChessClock extends StatefulWidget {
  final int currentPlayer;
  final bool isPaused;
  final int timerDurationInSeconds;
  final VoidCallback onTimerReset;
  final void Function(bool) onTimerPause;

  const ChessClock({
    super.key,
    required this.currentPlayer,
    required this.isPaused,
    required this.timerDurationInSeconds,
    required this.onTimerReset,
    required this.onTimerPause,
  });

  @override
  State<ChessClock> createState() => _ChessClockState();

  /// Public method to format time in MM:SS.ms format
  static String formatTime(int milliseconds) {
    final minutes = (milliseconds ~/ 60000).toString().padLeft(2, "0");
    final seconds = ((milliseconds % 60000) ~/ 1000).toString().padLeft(2, "0");
    final centiseconds = ((milliseconds % 1000) ~/ 100).toString();
    return "$minutes:$seconds.$centiseconds";
  }
}

class _ChessClockState extends State<ChessClock> {
  Timer? _timer;
  late int _timeLeftInMillis;
  static const int _updateIntervalMs = 100;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _timeLeftInMillis = widget.timerDurationInSeconds * 1000;

    // Defer provider updates until after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _safelyUpdateProvider();
        _startTimerIfNeeded();
        _isInitialized = true;
      }
    });
  }

  void _safelyUpdateProvider() {
    // Schedule provider updates for after the current build cycle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        try {
          final timerProvider =
              Provider.of<TimerProvider>(context, listen: false);
          timerProvider.updateTimeLeft(_timeLeftInMillis);
        } catch (e) {
          debugPrint("Error updating timer provider: $e");
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant ChessClock oldWidget) {
    super.didUpdateWidget(oldWidget);

    _cancelTimer();

    // Reset timer on player change
    if (oldWidget.currentPlayer != widget.currentPlayer) {
      _timeLeftInMillis = widget.timerDurationInSeconds * 1000;

      // All provider updates are now safely deferred
      if (_isInitialized) {
        _safelyUpdateProvider();
      }
    }

    // Pause the timer
    if (widget.isPaused && !oldWidget.isPaused) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onTimerPause(true);

          if (_isInitialized) {
            try {
              final timerProvider =
                  Provider.of<TimerProvider>(context, listen: false);
              timerProvider.setPaused(true);
            } catch (e) {
              debugPrint("Error updating pause state: $e");
            }
          }
        }
      });
    }

    _startTimerIfNeeded();
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _startTimerIfNeeded() {
    if (!widget.isPaused) {
      _startTimer();
    }
  }

  void _startTimer() {
    // Only try to access the provider if we're initialized and after the build
    if (_isInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          try {
            final timerProvider =
                Provider.of<TimerProvider>(context, listen: false);
            timerProvider.setPaused(false);
          } catch (e) {
            debugPrint("Error setting timer state: $e");
          }
        }
      });
    }

    _timer = Timer.periodic(
      const Duration(milliseconds: _updateIntervalMs),
      (Timer timer) {
        if (_timeLeftInMillis <= 0) {
          setState(() {
            timer.cancel();
            widget.onTimerReset();
          });

          if (_isInitialized) {
            try {
              final timerProvider =
                  Provider.of<TimerProvider>(context, listen: false);
              timerProvider.setPaused(true);
              timerProvider.updateTimeLeft(0);
            } catch (e) {
              debugPrint("Error updating provider on timer completion: $e");
            }
          }
        } else {
          setState(() {
            _timeLeftInMillis -= _updateIntervalMs;
          });

          if (_isInitialized) {
            try {
              final timerProvider =
                  Provider.of<TimerProvider>(context, listen: false);
              timerProvider.updateTimeLeft(_timeLeftInMillis);
            } catch (e) {
              debugPrint("Error updating time: $e");
            }
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _cancelTimer(); // Ensure timer is canceled
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<TimerProvider>(
        builder: (context, timerProvider, child) {
          return Text(
            "Time Left: ${timerProvider.formattedTime}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          );
        },
      ),
    );
  }
}
