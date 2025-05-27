import "package:flutter/material.dart";

class TimerSelectionResult {
  final int duration;
  final bool useRandomSelection;

  TimerSelectionResult(
      {required this.duration, required this.useRandomSelection});
}

/// Shows a dialog to select timer duration.
Future<TimerSelectionResult?> showTimerDurationDialog({
  required BuildContext context,
  required int initialDuration,
}) {
  return showDialog<TimerSelectionResult>(
    context: context,
    barrierDismissible: false, // Prevent clicking outside to dismiss
    builder: (BuildContext context) {
      int selectedDuration = initialDuration;
      bool useRandomSelection = false; // Default to manual selection

      return Dialog(
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(16.0),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Set Timer Duration",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("Select the duration for each player's turn:"),
                  const SizedBox(height: 16),
                  // Duration options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildDurationChip(30, selectedDuration, (value) {
                        setState(() => selectedDuration = value);
                      }),
                      _buildDurationChip(60, selectedDuration, (value) {
                        setState(() => selectedDuration = value);
                      }),
                      _buildDurationChip(120, selectedDuration, (value) {
                        setState(() => selectedDuration = value);
                      }),
                      _buildDurationChip(180, selectedDuration, (value) {
                        setState(() => selectedDuration = value);
                      }),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Add player selection toggle
                  SwitchListTile(
                    title: const Text("Random first player"),
                    subtitle:
                        const Text("Use coin flip to decide who goes first"),
                    value: useRandomSelection,
                    onChanged: (value) {
                      setState(() => useRandomSelection = value);
                    },
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Cancel"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (Navigator.of(context).mounted) {
                            Navigator.of(context).pop(
                              TimerSelectionResult(
                                duration: selectedDuration,
                                useRandomSelection: useRandomSelection,
                              ),
                            );
                          }
                        },
                        child: const Text("Start Game"),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}

/// Helper method to build duration selection chips.
Widget _buildDurationChip(int seconds, int selected, Function(int) onSelected) {
  final String label = seconds >= 60 ? "${seconds ~/ 60} min" : "$seconds sec";

  return ChoiceChip(
    label: Text(label),
    selected: selected == seconds,
    onSelected: (isSelected) {
      if (isSelected) {
        onSelected(seconds);
      }
    },
  );
}

/// Shows a dialog to manually select which player goes first.
Future<int?> showPlayerSelectionDialog(
    BuildContext context, int initialDuration) {
  return showDialog<int>(
    context: context,
    barrierDismissible: false, // Prevent clicking outside to dismiss
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Player selection area with full rounded corners
            Container(
              width: 300,
              height: 380,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Column(
                  children: [
                    // Player 2 button (top half)
                    Expanded(
                      child: _HoverDetector(
                        builder: (context, isHovering) => InkWell(
                          onTap: () => Navigator.of(context).pop(2),
                          child: Container(
                            width: double.infinity,
                            color: isHovering
                                ? Colors.red.shade200
                                : Colors.red.shade100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person,
                                    size: 48, // Fixed size
                                    color: isHovering
                                        ? Colors.red
                                            .shade800 // Darker color on hover
                                        : Colors.red.shade700),
                                const SizedBox(height: 8),
                                Text(
                                  "Player 2 First",
                                  style: TextStyle(
                                    fontSize: 24, // Fixed size
                                    fontWeight: FontWeight.bold,
                                    color: isHovering
                                        ? Colors.red
                                            .shade800 // Darker color on hover
                                        : Colors.red.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Divider
                    Container(
                      height: 2,
                      color: Colors.grey.shade300,
                    ),

                    // Player 1 button (bottom half)
                    Expanded(
                      child: _HoverDetector(
                        builder: (context, isHovering) => InkWell(
                          onTap: () => Navigator.of(context).pop(1),
                          child: Container(
                            width: double.infinity,
                            color: isHovering
                                ? Colors.blue.shade200
                                : Colors.blue.shade100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person,
                                    size: 48, // Fixed size
                                    color: isHovering
                                        ? Colors.blue
                                            .shade800 // Darker color on hover
                                        : Colors.blue.shade700),
                                const SizedBox(height: 8),
                                Text(
                                  "Player 1 First",
                                  style: TextStyle(
                                    fontSize: 24, // Fixed size
                                    fontWeight: FontWeight.bold,
                                    color: isHovering
                                        ? Colors.blue
                                            .shade800 // Darker color on hover
                                        : Colors.blue.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Add spacing between the containers
            const SizedBox(height: 12),

            // Back button with hover effect - only colors change
            _HoverDetector(
              builder: (context, isHovering) => Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop(null);
                  },
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    width: 300,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                      color: isHovering
                          ? Colors.grey.shade300
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withOpacity(isHovering ? 0.15 : 0.1),
                          blurRadius: 4, // Fixed blur
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          size: 16, // Fixed size
                          color: isHovering
                              ? Colors.black // Darker color on hover
                              : Colors.black87,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "BACK TO SETTINGS",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14, // Fixed size
                            color: isHovering
                                ? Colors.black // Darker color on hover
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
