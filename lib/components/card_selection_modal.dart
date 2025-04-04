import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../providers/timer_provider.dart";

/// Shows a dialog for selecting cards to play on a specific row.
///
/// - [crossAxisCount] determines how many cards appear in each row
/// - [cardNames] is the list of card names to display
/// - [showScorch] determines whether to show a Scorch button below the cards
Future<void> showCardSelectionModal({
  required BuildContext context,
  required String rowType,
  required int player,
  required void Function(bool) timerPause,
  required VoidCallback? onCardPlayed,
  int crossAxisCount = 3,
  List<String> cardNames = const [
    "Morale",
    "Common",
    "Bond",
    "Morale Hero",
    "Hero",
    "Shield",
  ],
  bool showScorch = true,
}) {
  // Schedule the pause to happen after the current frame
  WidgetsBinding.instance.addPostFrameCallback((_) {
    try {
      timerPause(true);
    } catch (e) {
      debugPrint("Error pausing timer: $e");
    }
  });

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Consumer<TimerProvider>(
        builder: (context, timerProvider, child) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(16.0),
                  child: Text(
                    "Play on $rowType (Player $player)",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "Paused Time: ${timerProvider.formattedTime}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  // Using a ListView for scrollable content with Padding
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomScrollView(
                      slivers: [
                        // Card grid section
                        SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 65 / 100,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return _HoverDetector(
                                builder: (context, isHovering) =>
                                    GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    try {
                                      // Reset the timer when a card is played
                                      final timerProvider =
                                          Provider.of<TimerProvider>(context,
                                              listen: false);
                                      timerProvider.resetTimer();
                                      timerPause(false); // Also unpause

                                      // If a card was played and we have a callback, trigger it
                                      if (onCardPlayed != null) {
                                        onCardPlayed();
                                      }
                                    } catch (e) {
                                      debugPrint("Error resetting timer: $e");
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isHovering
                                          ? Colors.blue.shade300
                                          : Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                          color: Colors.blue.shade700),
                                    ),
                                    child: Center(
                                      child: Text(
                                        cardNames[index],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: cardNames.length,
                          ),
                        ),

                        // Spacer
                        const SliverToBoxAdapter(child: SizedBox(height: 16)),

                        // Scorch button section
                        if (showScorch)
                          SliverToBoxAdapter(
                            child: _HoverDetector(
                              builder: (context, isHovering) => GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  try {
                                    // Reset the timer when a card is played
                                    final timerProvider =
                                        Provider.of<TimerProvider>(context,
                                            listen: false);
                                    timerProvider.resetTimer();
                                    timerPause(false); // Also unpause

                                    // If a card was played and we have a callback, trigger it
                                    if (onCardPlayed != null) {
                                      onCardPlayed();
                                    }
                                  } catch (e) {
                                    debugPrint("Error resetting timer: $e");
                                  }
                                },
                                child: Container(
                                  height:
                                      80, // Fixed height for the scorch button
                                  decoration: BoxDecoration(
                                    color: isHovering
                                        ? Colors.red.shade500
                                        : Colors.red.shade400,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border:
                                        Border.all(color: Colors.red.shade800),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "SCORCH",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Bottom padding
                        const SliverToBoxAdapter(child: SizedBox(height: 16)),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(16.0),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      try {
                        timerPause(false);
                      } catch (e) {
                        debugPrint("Error resuming timer: $e");
                      }
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
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
