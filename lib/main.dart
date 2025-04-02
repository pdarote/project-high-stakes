import "package:flutter/material.dart";
import "components/board_section.dart";
import "components/timer_section.dart";
import "components/timer_selection_dialog.dart";
import "components/coin_flip_modal.dart";
import "components/round_tracker.dart";
import "utils/toast_notification.dart";
import "game/game_state.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "High Stakes - Gwent Board Tracker",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GameBoard(),
    );
  }
}

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard>
    with SingleTickerProviderStateMixin {
  // Game state
  final GameState _gameState = GameState();

  // Toast notification
  late ToastNotification _toastNotification;
  late AnimationController _toastAnimationController;

  @override
  void initState() {
    super.initState();
    _toastAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _toastNotification = ToastNotification(
      context: context,
      controller: _toastAnimationController,
    );
  }

  @override
  void dispose() {
    _toastAnimationController.dispose();
    _toastNotification.dispose();
    super.dispose();
  }

  // Start or end game
  void _startOrEndGame() {
    if (!_gameState.isGameStarted) {
      _showTimerDurationDialog();
    } else {
      setState(() {
        _gameState.resetGame();
      });
    }
  }

  // Handle player passing a round
  void _playerPassedRound() {
    setState(() {
      // GameState updated in passRound method
      final bool gameEnded = _gameState.passRound();

      if (gameEnded && _gameState.gameResult != null) {
        // Game ended due to a player winning or a tie
        final Color toastColor = _gameState.winningPlayer == 1
            ? Colors.blue.shade800
            : Colors.red.shade800;

        if (mounted) {
          _toastNotification.show(
            _gameState.gameResult!,
            backgroundColor: toastColor,
          );
        }
      }
    });
  }

  // Show dialog to select timer duration then start game
  void _showTimerDurationDialog() async {
    // Wrap this in a loop to handle going back from player selection
    TimerSelectionResult? result;
    bool continueFlow = true;

    while (continueFlow) {
      // Show timer selection dialog
      result = await showTimerDurationDialog(
        context: context,
        initialDuration: _gameState.timerDurationInSeconds,
      );

      if (!mounted) return; // Check if still mounted after async gap

      if (result == null) {
        // User cancelled the dialog
        continueFlow = false;
        continue;
      }

      if (result.useRandomSelection) {
        // Use coin flip for random player selection
        final startingPlayer = await showCoinFlipModal(context);

        if (!mounted) return; // Check if still mounted after async gap

        setState(() {
          _gameState.startGameWithPlayer(result!.duration, startingPlayer);
        });
        continueFlow = false;
      } else {
        // Use manual player selection
        final selectedPlayer = await showPlayerSelectionDialog(
          context,
          _gameState.timerDurationInSeconds,
        );

        if (!mounted) return; // Check if still mounted after async gap

        if (selectedPlayer != null) {
          // Player was selected, start the game
          setState(() {
            _gameState.startGameWithPlayer(result!.duration, selectedPlayer);
          });
          continueFlow = false;
        }
        // If selectedPlayer is null, we want to show the timer dialog again
        // The loop will continue
      }
    }
  }

  // Switch player turn
  void _switchTurn() {
    setState(() {
      _gameState.switchTurn();
    });
  }

  // Handle timer timeout
  void _setTimeout() {
    setState(() {
      _gameState.timerTimeout();
    });
  }

  // Pause/resume timer
  void _timerPause(bool isPaused) {
    setState(() {
      _gameState.setTimerPause(isPaused);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("High Stakes - Gwent Board Tracker"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Round tracker added here
            if (_gameState.isGameStarted)
              RoundTracker(
                currentRound: _gameState.currentRound,
                roundWinners: _gameState.roundWinners,
              ),
            const SizedBox(height: 8),

            BoardSection(
              currentPlayer: _gameState.currentPlayer,
              isGameStarted: _gameState.isGameStarted,
              timerPause: _timerPause,
              pausedTime: _gameState.pausedTime, // Pass paused time
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TimerSection(
                currentPlayer: _gameState.currentPlayer,
                nextPlayer: _gameState.nextPlayer,
                isGameStarted: _gameState.isGameStarted,
                isTimeout: _gameState.isTimeout,
                isManualPaused: _gameState.isManualPaused,
                timerDurationInSeconds: _gameState.timerDurationInSeconds,
                onStartOrEndGame: _startOrEndGame,
                onSwitchTurn: _switchTurn,
                onTimerTimeout: _setTimeout,
                timerPause: _timerPause,
                onPass: _playerPassedRound,
                onTimerPause: (pausedTime) {
                  _gameState.savePausedTime(pausedTime); // Save paused time
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
