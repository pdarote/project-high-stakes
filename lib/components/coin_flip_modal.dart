import "package:flutter/material.dart";
import "dart:math" as math;

/// Shows a modal dialog with a coin flip animation to determine the first player.
Future<int> showCoinFlipModal(BuildContext context) async {
  // Create a separate Random instance for better randomness
  final random = math.Random(DateTime.now().millisecondsSinceEpoch);

  // Explicitly generate 0 or 1, then add 1 to get player number
  final int result = random.nextBool() ? 1 : 2;

  // Enhanced debug logging
  debugPrint(
      "Coin flip randomly chose Player $result (${result == 1 ? 'Heads' : 'Tails'})");

  // Show the dialog and wait for it to be dismissed
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => _CoinFlipDialog(result: result),
  );

  return result;
}

class _CoinFlipDialog extends StatefulWidget {
  final int result; // 1 or 2 for Player 1 or Player 2

  const _CoinFlipDialog({required this.result});

  @override
  _CoinFlipDialogState createState() => _CoinFlipDialogState();
}

class _CoinFlipDialogState extends State<_CoinFlipDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();

    // Create animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Calculate number of flips - add some randomness but ensure proper ending
    const baseFlips = 5; // Minimum number of flips
    final randomExtra = math.Random().nextInt(3); // 0-2 extra flips
    final totalFlips = baseFlips + randomExtra;

    // Each flip is a full rotation (2π)
    final endAngle = widget.result == 1
        ? totalFlips *
            2 *
            math.pi // End with Player 1 face up (even number of π)
        : (totalFlips * 2 + 1) *
            math.pi; // End with Player 2 face up (odd number of π)

    // Define animation - multiple full rotations with proper easing
    _animation = TweenSequence<double>([
      // Initial quick rotation
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: endAngle * 0.3)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 20,
      ),
      // Middle fast rotations
      TweenSequenceItem(
        tween: Tween<double>(begin: endAngle * 0.3, end: endAngle * 0.8)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 50,
      ),
      // Final slowing down
      TweenSequenceItem(
        tween: Tween<double>(begin: endAngle * 0.8, end: endAngle)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(_controller);

    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _controller.forward();
    });

    // Show result after animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _showResult = true;
            });

            // Auto-dismiss after showing result
            Future.delayed(const Duration(milliseconds: 2000), () {
              if (mounted) {
                Navigator.of(context).pop();
              }
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Flipping coin to decide who plays first...",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return SizedBox(
                height: 160,
                width: 160,
                child: _buildCoin(),
              );
            },
          ),
          const SizedBox(height: 30),
          if (_showResult)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    "Player ${widget.result} plays first!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: widget.result == 1
                          ? Colors.blue.shade700
                          : Colors.red.shade700,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCoin() {
    // More reliable side determination
    final double normalizedAngle = _animation.value.remainder(2 * math.pi);
    final bool showFrontSide;

    if (_controller.isCompleted) {
      // When animation completes, explicitly show correct side based on result
      showFrontSide = widget.result == 1;
    } else {
      // During animation, determine side based on current angle
      showFrontSide =
          normalizedAngle < math.pi / 2 || normalizedAngle > 3 * math.pi / 2;
    }

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.002) // perspective
        ..rotateY(_animation.value),
      child: showFrontSide
          ? _buildCoinSide(
              color: Colors.blue.shade400,
              player: 1,
              borderColor: Colors.blue.shade100,
              isBackSide: false,
            )
          : _buildCoinSide(
              color: Colors.red.shade400,
              player: 2,
              borderColor: Colors.red.shade100,
              isBackSide: true,
            ),
    );
  }

  Widget _buildCoinSide({
    required Color color,
    required int player,
    required Color borderColor,
    required bool isBackSide,
  }) {
    Widget content = Center(
      child: Text(
        "P$player",
        style: TextStyle(
          fontSize: 56,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              offset: const Offset(2, 2),
              blurRadius: 4,
              color: Colors.black.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );

    // Apply an additional rotation to fix mirroring on back side
    if (isBackSide) {
      content = Transform(
        alignment: Alignment.center,
        transform:
            Matrix4.rotationY(math.pi), // Rotate 180 degrees to fix mirroring
        child: content,
      );
    }

    return Container(
      height: 160,
      width: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withOpacity(0.8)],
          stops: const [0.6, 1.0],
          center: const Alignment(-0.3, -0.5),
        ),
        border: Border.all(color: borderColor, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: content,
    );
  }
}
