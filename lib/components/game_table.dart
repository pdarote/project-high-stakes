import "package:flutter/material.dart";

// Removed unnecessary GameState import

class GameTable extends StatelessWidget {
  final int currentPlayer;
  final bool isGameStarted;
  final void Function(bool) timerPause;
  final int? pausedTime; // Paused time is passed as an argument

  const GameTable({
    super.key,
    required this.currentPlayer,
    required this.isGameStarted,
    required this.timerPause,
    required this.pausedTime, // Already passed here
  });

  @override
  Widget build(BuildContext context) {
    return _GameTableLayout(
      currentPlayer: currentPlayer,
      isGameStarted: isGameStarted,
      timerPause: timerPause,
      pausedTime: pausedTime, // Pass pausedTime to layout
    );
  }
}

class _GameTableLayout extends StatelessWidget {
  final int currentPlayer;
  final bool isGameStarted;
  final void Function(bool) timerPause;
  final int? pausedTime; // Paused time is passed as an argument

  const _GameTableLayout({
    required this.currentPlayer,
    required this.isGameStarted,
    required this.timerPause,
    required this.pausedTime, // Already passed here
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dividerHeight = 2.0;
        final tableWidth = constraints.maxWidth;
        final tableHeight = constraints.maxHeight;
        final cellWidth = tableWidth * 0.15;
        final unitSectionWidth = tableWidth - (cellWidth * 4);
        final halfHeight = (tableHeight - dividerHeight) / 2;
        final rowHeight = halfHeight / 3;

        return Stack(
          children: [
            _PlayerSection(
              player: 2,
              isCurrentPlayer: currentPlayer == 2,
              isGameStarted: isGameStarted,
              timerPause: timerPause,
              top: 0,
              unitSectionTop: 0,
              rowHeight: rowHeight,
              cellWidth: cellWidth,
              unitSectionWidth: unitSectionWidth,
              sectionHeight: halfHeight,
              isTopSection: true,
              pausedTime: pausedTime, // Pass pausedTime to player section
            ),
            Positioned(
              top: halfHeight,
              left: 0,
              right: 0,
              child: Container(
                height: dividerHeight,
                color: Colors.black,
              ),
            ),
            _PlayerSection(
              player: 1,
              isCurrentPlayer: currentPlayer == 1,
              isGameStarted: isGameStarted,
              timerPause: timerPause,
              top: halfHeight + dividerHeight,
              unitSectionTop: halfHeight + dividerHeight,
              rowHeight: rowHeight,
              cellWidth: cellWidth,
              unitSectionWidth: unitSectionWidth,
              sectionHeight: halfHeight,
              isTopSection: false,
              pausedTime: pausedTime, // Pass pausedTime to player section
            ),
          ],
        );
      },
    );
  }

  void _showCardSelectionModal(
      BuildContext context, String rowType, int player) {
    try {
      timerPause(true); // Pause the timer when the modal is displayed
    } catch (e) {
      debugPrint("Error pausing timer: $e");
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
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
              if (pausedTime != null)
                Text(
                  "Paused Time: ${_formatTime(pausedTime!)}", // Use local formatTime method
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 65 / 100,
                  ),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    final cardNames = [
                      "Weather",
                      "Horn",
                      "Common",
                      "Bond",
                      "Shield",
                      "Clear",
                      "Morale",
                      "Hero",
                      "Bond.H",
                      "Morale.H"
                    ];
                    return _HoverDetector(
                      builder: (context, isHovering) => GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          try {
                            timerPause(false);
                          } catch (e) {
                            debugPrint("Error resuming timer: $e");
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
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    final millis = ((seconds % 1) * 1000).toInt().toString().padLeft(1, '0');
    return "$minutes:$secs.$millis";
  }
}

class _PlayerSection extends StatelessWidget {
  final int player;
  final bool isCurrentPlayer;
  final bool isGameStarted;
  final void Function(bool) timerPause;
  final double top;
  final double unitSectionTop;
  final double rowHeight;
  final double cellWidth;
  final double unitSectionWidth;
  final double sectionHeight;
  final bool isTopSection;
  final int? pausedTime; // Added pausedTime parameter

  const _PlayerSection({
    required this.player,
    required this.isCurrentPlayer,
    required this.isGameStarted,
    required this.timerPause,
    required this.top,
    required this.unitSectionTop,
    required this.rowHeight,
    required this.cellWidth,
    required this.unitSectionWidth,
    required this.sectionHeight,
    required this.isTopSection,
    required this.pausedTime, // Added parameter
  });

  @override
  Widget build(BuildContext context) {
    final rowTypes = isTopSection
        ? ["Siege", "Ranged", "Close Combat"]
        : ["Close Combat", "Ranged", "Siege"];

    return Stack(
      children: [
        Positioned(
          left: cellWidth * 2,
          top: unitSectionTop,
          width: unitSectionWidth,
          height: sectionHeight,
          child: _UnitSection(
            player: player,
            rowHeight: rowHeight - 1,
            isHighlighted: isGameStarted && isCurrentPlayer,
            rowTypes: rowTypes,
            timerPause: timerPause,
            pausedTime: pausedTime, // Pass pausedTime to unit section
          ),
        ),
        Positioned(
          left: cellWidth * 3 + unitSectionWidth,
          top: unitSectionTop,
          width: cellWidth,
          height: sectionHeight,
          child: _TotalPowerSection(
            value: "0",
            isPlayer1: player == 1,
          ),
        ),
        ...List.generate(3, (rowIndex) {
          final rowTop = top + (rowIndex * rowHeight);
          final position = _determinePosition(rowIndex, rowTypes.length);

          return [
            Positioned(
              left: 0,
              top: rowTop,
              width: cellWidth,
              height: rowHeight,
              child: _TableCell(
                isHeader: true,
                position: position,
                isPlayer1: player == 1,
              ),
            ),
            Positioned(
              left: cellWidth,
              top: rowTop,
              width: cellWidth,
              height: rowHeight,
              child: _TableCell(
                isHeader: true,
                position: position,
                isPlayer1: player == 1,
              ),
            ),
            Positioned(
              left: cellWidth * 2 + unitSectionWidth,
              top: rowTop,
              width: cellWidth,
              height: rowHeight,
              child: _TableCell(
                isValue: true,
                text: "0",
                position: position,
                isPlayer1: player == 1,
              ),
            ),
          ];
        }).expand((items) => items).toList(),
      ],
    );
  }

  BorderPosition _determinePosition(int index, int total) {
    if (index == 0) return BorderPosition.top;
    if (index == total - 1) return BorderPosition.bottom;
    return BorderPosition.middle;
  }
}

class _UnitSection extends StatelessWidget {
  final int player;
  final double rowHeight;
  final bool isHighlighted;
  final List<String> rowTypes;
  final void Function(bool) timerPause;
  final int? pausedTime; // Added pausedTime parameter

  const _UnitSection({
    required this.player,
    required this.rowHeight,
    required this.isHighlighted,
    required this.rowTypes,
    required this.timerPause,
    required this.pausedTime, // Added parameter
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.yellow[100] : Colors.grey[300],
        border: player == 1
            ? const Border(
                right: BorderSide(color: Colors.black, width: 0),
                left: BorderSide(color: Colors.black, width: 0.5),
                bottom: BorderSide(color: Colors.black, width: 1.0),
              )
            : const Border(
                top: BorderSide(color: Colors.black, width: 1.0),
                right: BorderSide(color: Colors.black, width: 0),
                left: BorderSide(color: Colors.black, width: 0.5),
              ),
      ),
      child: Column(
        children: [
          for (int i = 0; i < rowTypes.length; i++) ...[
            _HoverDetector(
              builder: (context, isHovering) => GestureDetector(
                onTap: isHighlighted
                    ? () => _showCardSelectionModal(
                          context,
                          rowTypes[i],
                          player,
                        )
                    : null,
                child: Container(
                  height: rowHeight,
                  color: isHovering && isHighlighted
                      ? Colors.green.shade200
                      : Colors.transparent,
                  child: Center(
                    child: Text(
                      rowTypes[i],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isHighlighted ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (i < rowTypes.length - 1)
              const Divider(color: Colors.black, height: 1, thickness: 1.0),
          ],
        ],
      ),
    );
  }

  void _showCardSelectionModal(
      BuildContext context, String rowType, int player) {
    try {
      timerPause(true); // Pause the timer when the modal is displayed
    } catch (e) {
      debugPrint("Error pausing timer: $e");
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
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
              if (pausedTime != null)
                Text(
                  "Paused Time: ${_formatTime(pausedTime!)}", // Use local formatTime method
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 65 / 100,
                  ),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    final cardNames = [
                      "Weather",
                      "Horn",
                      "Common",
                      "Bond",
                      "Shield",
                      "Clear",
                      "Morale",
                      "Hero",
                      "Bond.H",
                      "Morale.H"
                    ];
                    return _HoverDetector(
                      builder: (context, isHovering) => GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          try {
                            timerPause(false);
                          } catch (e) {
                            debugPrint("Error resuming timer: $e");
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
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    final millis = ((seconds % 1) * 1000).toInt().toString().padLeft(1, '0');
    return "$minutes:$secs.$millis";
  }
}

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

class _TotalPowerSection extends StatelessWidget {
  final String value;
  final bool isPlayer1;

  const _TotalPowerSection({
    required this.value,
    required this.isPlayer1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: isPlayer1
            ? const Border(
                right: BorderSide(color: Colors.black, width: 1.0),
                left: BorderSide(color: Colors.black, width: 0.5),
                bottom: BorderSide(color: Colors.black, width: 1.0),
              )
            : const Border(
                top: BorderSide(color: Colors.black, width: 1.0),
                right: BorderSide(color: Colors.black, width: 1.0),
                left: BorderSide(color: Colors.black, width: 0.5),
              ),
      ),
      child: Center(
        child: Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final bool isHeader;
  final bool isValue;
  final String text;
  final BorderPosition position;
  final bool isPlayer1;

  const _TableCell({
    this.isHeader = false,
    this.isValue = false,
    this.text = "",
    this.position = BorderPosition.middle,
    this.isPlayer1 = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isHeader ? Colors.grey[200] : Colors.transparent,
        border: isPlayer1
            ? const Border(
                right: BorderSide(color: Colors.black, width: 0),
                left: BorderSide(color: Colors.black, width: 0.5),
                bottom: BorderSide(color: Colors.black, width: 1.0),
              )
            : const Border(
                top: BorderSide(color: Colors.black, width: 1.0),
                right: BorderSide(color: Colors.black, width: 0),
                left: BorderSide(color: Colors.black, width: 0.5),
              ),
      ),
      child: isValue
          ? Center(child: Text(text, style: const TextStyle(fontSize: 16)))
          : const SizedBox(),
    );
  }
}

enum BorderPosition { top, middle, bottom }
