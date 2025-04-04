import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../providers/timer_provider.dart";

/// Shows a dialog for selecting cards to play on a specific row.
Future<void> showCardSelectionModal({
  required BuildContext context,
  required String rowType,
  required int player,
  required void Function(bool) timerPause,
  required VoidCallback? onCardPlayed,
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
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 65 / 100,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      final cardNames = [
                        "Common",
                        "Morale",
                        "Bond",
                        "Hero",
                        "Morale Hero",
                        "Shield",
                      ];
                      return _HoverDetector(
                        builder: (context, isHovering) => GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            try {
                              // Reset the timer when a card is played
                              final timerProvider = Provider.of<TimerProvider>(
                                  context,
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
                              border: Border.all(color: Colors.blue.shade700),
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
