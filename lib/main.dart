import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "components/board_section.dart";
import "components/timer_section.dart";
import "components/timer_selection_dialog.dart";
import "components/coin_flip_modal.dart";
import "components/player_health_tracker.dart"; // New import
import "utils/toast_notification.dart";
import "game/game_state.dart";
import "providers/timer_provider.dart";

void main() {
  runApp(
    ChangeNotifierProvider<TimerProvider>(
      create: (context) => TimerProvider(),
      child: const MyApp(),
    ),
  );
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
      final bool gameEnded = _gameState.passRound();

      if (gameEnded && _gameState.gameResult != null) {
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
    TimerSelectionResult? result;
    bool continueFlow = true;

    while (continueFlow) {
      result = await showTimerDurationDialog(
        context: context,
        initialDuration: _gameState.timerDurationInSeconds,
      );

      if (!mounted) return;

      if (result == null) {
        continueFlow = false;
        continue;
      }

      // Update the timer duration in the provider
      if (result.duration != _gameState.timerDurationInSeconds) {
        final timerProvider =
            Provider.of<TimerProvider>(context, listen: false);
        timerProvider.setTimerDuration(result.duration);
      }

      if (result.useRandomSelection) {
        final startingPlayer = await showCoinFlipModal(context);

        if (!mounted) return;

        setState(() {
          _gameState.startGameWithPlayer(result!.duration, startingPlayer);
        });
        continueFlow = false;
      } else {
        final selectedPlayer = await showPlayerSelectionDialog(
          context,
          _gameState.timerDurationInSeconds,
        );

        if (!mounted) return;

        if (selectedPlayer != null) {
          setState(() {
            _gameState.startGameWithPlayer(result!.duration, selectedPlayer);
          });
          continueFlow = false;
        }
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

    // Also update the timer provider
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    timerProvider.setPaused(true);
  }

  // Pause/resume timer - MODIFIED TO BE SAFE FOR BUILD-TIME CALLS
  void _timerPause(bool isPaused) {
    // Safely update game state
    if (_gameState.isManualPaused != isPaused) {
      // Use post-frame callback to avoid setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _gameState.setTimerPause(isPaused);
          });
        }
      });
    }

    // Safely update timer provider - this is ok during build since we're not calling setState
    try {
      final timerProvider = Provider.of<TimerProvider>(context, listen: false);
      timerProvider.setPaused(isPaused);
    } catch (e) {
      debugPrint("Error updating timer provider: $e");
    }
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
            // Player 2 (top player) health tracker
            PlayerHealthTracker(
              playerNumber: 2,
              isGameStarted: _gameState.isGameStarted,
              lostRounds:
                  _gameState.roundWinners.where((winner) => winner == 1).length,
            ),
            const SizedBox(height: 8),

            BoardSection(
              currentPlayer: _gameState.currentPlayer,
              isGameStarted: _gameState.isGameStarted,
              timerPause: _timerPause,
            ),

            const SizedBox(height: 8),

            // Player 1 (bottom player) health tracker
            PlayerHealthTracker(
              playerNumber: 1,
              isGameStarted: _gameState.isGameStarted,
              lostRounds:
                  _gameState.roundWinners.where((winner) => winner == 2).length,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
