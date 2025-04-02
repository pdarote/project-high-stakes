import "package:flutter/material.dart";
import "dart:async";

class ChessClock extends StatefulWidget {
  final int currentPlayer;
  final bool isPaused;
  final int timerDurationInSeconds;
  final VoidCallback onTimerReset;
  final void Function(int pausedTime)
      onTimerPause; // New callback for paused time

  const ChessClock({
    super.key,
    required this.currentPlayer,
    required this.isPaused,
    required this.timerDurationInSeconds,
    required this.onTimerReset,
    required this.onTimerPause, // Added parameter
  });

  @override
  State<ChessClock> createState() => _ChessClockState();
}

class _ChessClockState extends State<ChessClock> {
  Timer? _timer;
  late int _timeLeftInMillis;
  static const int _updateIntervalMs = 100;

  @override
  void initState() {
    super.initState();
    _resetTimer();
    _startTimerIfNeeded();
  }

  @override
  void didUpdateWidget(covariant ChessClock oldWidget) {
    super.didUpdateWidget(oldWidget);

    _cancelTimer();

    // Reset timer on player change
    if (oldWidget.currentPlayer != widget.currentPlayer) {
      _resetTimer();
    }

    // Save paused time when paused
    if (widget.isPaused && !oldWidget.isPaused) {
      widget.onTimerPause(
          _timeLeftInMillis ~/ 1000); // Save paused time in seconds
    }

    _startTimerIfNeeded();
  }

  void _resetTimer() {
    setState(() {
      _timeLeftInMillis = widget.timerDurationInSeconds * 1000;
    });
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
    _timer = Timer.periodic(
      const Duration(milliseconds: _updateIntervalMs),
      (Timer timer) {
        if (_timeLeftInMillis <= 0) {
          setState(() {
            timer.cancel();
            widget.onTimerReset();
          });
        } else {
          setState(() {
            _timeLeftInMillis -= _updateIntervalMs;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _cancelTimer(); // Ensure timer is canceled
    super.dispose();
  }

  String _formatTime(int milliseconds) {
    final minutes = (milliseconds ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((milliseconds % 60000) ~/ 1000).toString().padLeft(2, '0');
    final centiseconds = ((milliseconds % 1000) ~/ 100).toString();
    return "$minutes:$seconds.$centiseconds";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        "Time Left: ${_formatTime(_timeLeftInMillis)}",
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
