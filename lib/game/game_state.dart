/// Manages the game's state and provides methods to manipulate it.
class GameState {
  int currentPlayer = 1;
  int nextPlayer = 2;
  bool isGameStarted = false;
  bool isTimeout = false;
  bool isManualPaused = false;
  int timerDurationInSeconds = 60;
  String? gameResult;
  int? winningPlayer;

  // Round tracking
  int currentRound = 1;
  List<int?> roundWinners = [
    null,
    null,
    null
  ]; // null means round not decided yet
  bool player1Passed = false;
  bool player2Passed = false;
  int? firstPlayerToPassed; // Track the first player to pass in a round

  // Round stats
  int roundsWonByPlayer1 = 0;
  int roundsWonByPlayer2 = 0;

  // Reset the game state but keep timer duration
  void resetGame() {
    isGameStarted = false;
    currentPlayer = 1;
    nextPlayer = 2;
    isTimeout = false;
    isManualPaused = false;
    gameResult = null;
    winningPlayer = null;

    // Reset round tracking
    currentRound = 1;
    roundWinners = [null, null, null];
    player1Passed = false;
    player2Passed = false;
    firstPlayerToPassed = null;
    roundsWonByPlayer1 = 0;
    roundsWonByPlayer2 = 0;
  }

  // Set the game as started
  void startGame(int duration) {
    timerDurationInSeconds = duration;
    isGameStarted = true;
    gameResult = null;
    winningPlayer = null;

    // Reset round state
    currentRound = 1;
    roundWinners = [null, null, null];
    player1Passed = false;
    player2Passed = false;
    firstPlayerToPassed = null;
    roundsWonByPlayer1 = 0;
    roundsWonByPlayer2 = 0;
  }

  // Set the game as started with specific starting player
  void startGameWithPlayer(int duration, int startingPlayer) {
    timerDurationInSeconds = duration;
    isGameStarted = true;
    gameResult = null;
    winningPlayer = null;

    // Set the starting player
    currentPlayer = startingPlayer;
    nextPlayer = startingPlayer == 1 ? 2 : 1;

    // Reset round state
    currentRound = 1;
    roundWinners = [null, null, null];
    player1Passed = false;
    player2Passed = false;
    firstPlayerToPassed = null;
    roundsWonByPlayer1 = 0;
    roundsWonByPlayer2 = 0;
  }

  // Player passes their turn for the current round
  bool passRound() {
    // Mark the current player as passed
    if (currentPlayer == 1) {
      player1Passed = true;
    } else {
      player2Passed = true;
    }

    // If this is the first player to pass in this round, record it
    if (firstPlayerToPassed == null) {
      firstPlayerToPassed = currentPlayer;
    }

    // Reset the timeout flag to prevent the modal from reappearing
    isTimeout = false;

    // If both players have passed, end the round
    if (player1Passed && player2Passed) {
      // The first player to pass loses the round
      return _endRound(firstPlayerToPassed == 1 ? 2 : 1);
    }

    // If only one player has passed, switch to the other player
    switchTurn();
    return false; // Game not over yet, continue playing
  }

  // End the current round with the given winner
  bool _endRound(int winner) {
    // Record the winner of this round
    roundWinners[currentRound - 1] = winner;

    // Update wins count
    if (winner == 1) {
      roundsWonByPlayer1++;
    } else {
      roundsWonByPlayer2++;
    }

    // Check if the game is over after the last round
    if (currentRound == 3) {
      _determineGameResult();
      return true; // Game over
    }

    // Move to the next round
    currentRound++;
    player1Passed = false;
    player2Passed = false;
    firstPlayerToPassed = null; // Reset for the new round
    currentPlayer = winner; // Winner of the round starts the next round
    nextPlayer = winner == 1 ? 2 : 1;

    return false; // Game not over yet
  }

  // Determine the game result after the last round
  void _determineGameResult() {
    if (roundsWonByPlayer1 > roundsWonByPlayer2) {
      _endGame(1);
    } else if (roundsWonByPlayer2 > roundsWonByPlayer1) {
      _endGame(2);
    } else {
      gameResult = "Game ended in a tie!";
      isGameStarted = false;
    }
  }

  // End the game with a winner
  void _endGame(int winner) {
    winningPlayer = winner;
    gameResult = "Player $winner wins the game!";
    isGameStarted = false;
  }

  // Switch player turns
  void switchTurn() {
    int temp = currentPlayer;
    currentPlayer = nextPlayer;
    nextPlayer = temp;
    isTimeout = false;
    isManualPaused = false;
  }

  // Handle timer timeout
  void timerTimeout() {
    isTimeout = true;
  }

  // Pause or resume the timer
  void setTimerPause(bool isPaused) {
    isManualPaused = isPaused;
  }
}
