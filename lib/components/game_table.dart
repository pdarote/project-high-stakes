import "package:flutter/material.dart";
import "card_selection_modal.dart";

class GameTable extends StatelessWidget {
  final int currentPlayer;
  final bool isGameStarted;
  final void Function(bool) timerPause;
  final String? pausedTime;
  final bool opponentPassed;
  final VoidCallback? onCardPlayed;

  const GameTable({
    super.key,
    required this.currentPlayer,
    required this.isGameStarted,
    required this.timerPause,
    this.pausedTime,
    this.opponentPassed = false,
    this.onCardPlayed,
  });

  @override
  Widget build(BuildContext context) {
    return _GameTableLayout(
      currentPlayer: currentPlayer,
      isGameStarted: isGameStarted,
      timerPause: timerPause,
      pausedTime: pausedTime,
      opponentPassed: opponentPassed,
      onCardPlayed: onCardPlayed,
    );
  }
}

class _GameTableLayout extends StatelessWidget {
  final int currentPlayer;
  final bool isGameStarted;
  final void Function(bool) timerPause;
  final String? pausedTime;
  final bool opponentPassed;
  final VoidCallback? onCardPlayed;

  const _GameTableLayout({
    required this.currentPlayer,
    required this.isGameStarted,
    required this.timerPause,
    required this.pausedTime,
    this.opponentPassed = false,
    this.onCardPlayed,
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
              pausedTime: pausedTime,
              opponentPassed: currentPlayer == 2 && opponentPassed,
              onCardPlayed: onCardPlayed,
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
              pausedTime: pausedTime,
              opponentPassed: currentPlayer == 1 && opponentPassed,
              onCardPlayed: onCardPlayed,
            ),
          ],
        );
      },
    );
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
  final String? pausedTime;
  final bool opponentPassed;
  final VoidCallback? onCardPlayed;

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
    required this.pausedTime,
    this.opponentPassed = false,
    this.onCardPlayed,
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
            pausedTime: pausedTime,
            opponentPassed: opponentPassed,
            onCardPlayed: onCardPlayed,
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
  final String? pausedTime;
  final bool opponentPassed;
  final VoidCallback? onCardPlayed;

  const _UnitSection({
    required this.player,
    required this.rowHeight,
    required this.isHighlighted,
    required this.rowTypes,
    required this.timerPause,
    required this.pausedTime,
    this.opponentPassed = false,
    this.onCardPlayed,
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
                    ? () => showCardSelectionModal(
                          context: context,
                          rowType: rowTypes[i],
                          player: player,
                          timerPause: timerPause,
                          onCardPlayed: onCardPlayed,
                          crossAxisCount: 4,
                          cardNames: const [
                            "Common",
                            "Morale",
                            "Bond",
                            "Berserker",
                            "Hero",
                            "Morale Hero",
                            "Shield",
                            "Spy",
                          ],
                          showScorch: true, // Using the default value
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
    final int powerValue = int.tryParse(value) ?? 0;

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
        child: powerValue > 0
            ? Text(
                value,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            : const SizedBox(),
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
    final int powerValue = isValue ? (int.tryParse(text) ?? 0) : 0;

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
          ? Center(
              child: powerValue > 0
                  ? Text(text, style: const TextStyle(fontSize: 16))
                  : null,
            )
          : const SizedBox(),
    );
  }
}

enum BorderPosition { top, middle, bottom }
