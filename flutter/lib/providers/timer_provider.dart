import 'package:flutter/material.dart';
import '../components/chess_clock.dart';

/// Provides global state management for the timer functionality
class TimerProvider extends ChangeNotifier {
  int _timerDurationInSeconds = 60;
  int _timeLeftInMillis = 60000;
  bool _isPaused = true;
  String _formattedTime = "01:00.0";
  bool _notificationsEnabled = true;

  // Getters for the timer state
  int get timerDurationInSeconds => _timerDurationInSeconds;
  int get timeLeftInMillis => _timeLeftInMillis;
  bool get isPaused => _isPaused;
  String get formattedTime => _formattedTime;

  /// Temporarily disable notifications to prevent build-time updates
  void suspendNotifications() {
    _notificationsEnabled = false;
  }

  /// Re-enable notifications
  void resumeNotifications() {
    _notificationsEnabled = true;
  }

  /// Sets the timer duration and resets the time left
  void setTimerDuration(int seconds) {
    if (_timerDurationInSeconds == seconds) return;

    _timerDurationInSeconds = seconds;
    resetTimer();
    _safeNotifyListeners();
  }

  /// Updates the time left in milliseconds
  void updateTimeLeft(int milliseconds) {
    if (_timeLeftInMillis == milliseconds) return;

    _timeLeftInMillis = milliseconds;
    _formattedTime = ChessClock.formatTime(_timeLeftInMillis);
    _safeNotifyListeners();
  }

  /// Resets the timer to the initial duration
  void resetTimer() {
    _timeLeftInMillis = _timerDurationInSeconds * 1000;
    _formattedTime = ChessClock.formatTime(_timeLeftInMillis);
    _safeNotifyListeners();
  }

  /// Sets the paused state
  void setPaused(bool paused) {
    if (_isPaused == paused) return;

    _isPaused = paused;
    _safeNotifyListeners();
  }

  /// Only notify listeners if it's safe to do so
  void _safeNotifyListeners() {
    if (_notificationsEnabled) {
      notifyListeners();
    }
  }
}
