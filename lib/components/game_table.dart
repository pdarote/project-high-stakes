import "package:flutter/material.dart";

class GameTable extends StatelessWidget {
  final int currentPlayer;
  final bool isGameStarted;

  const GameTable(
      {super.key, required this.currentPlayer, required this.isGameStarted});

  @override
  Widget build(BuildContext context) {
    return _GameTableLayout(
      currentPlayer: currentPlayer,
      isGameStarted: isGameStarted,
    );
  }
}

class _GameTableLayout extends StatelessWidget {
  final int currentPlayer;
  final bool isGameStarted;

  const _GameTableLayout({
    required this.currentPlayer,
    required this.isGameStarted,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Define dimensions based on available space
        const dividerHeight = 2.0;
        final tableWidth = constraints.maxWidth;
        final tableHeight = constraints.maxHeight;
        final cellWidth = tableWidth * 0.15;
        final unitSectionWidth = tableWidth - (cellWidth * 4);
        final halfHeight = (tableHeight - dividerHeight) / 2;
        final rowHeight = halfHeight / 3;

        return Stack(
          children: [
            // Player 2 section (top)
            _PlayerSection(
              player: 2,
              isCurrentPlayer: currentPlayer == 2,
              isGameStarted: isGameStarted,
              top: 0,
              unitSectionTop: 0,
              rowHeight: rowHeight,
              cellWidth: cellWidth,
              unitSectionWidth: unitSectionWidth,
              sectionHeight: halfHeight,
              isTopSection: true,
            ),

            // Center divider
            Positioned(
              top: halfHeight,
              left: 0,
              right: 0,
              child: Container(
                height: dividerHeight,
                color: Colors.black,
              ),
            ),

            // Player 1 section (bottom)
            _PlayerSection(
              player: 1,
              isCurrentPlayer: currentPlayer == 1,
              isGameStarted: isGameStarted,
              top: halfHeight + dividerHeight,
              unitSectionTop: halfHeight + dividerHeight,
              rowHeight: rowHeight,
              cellWidth: cellWidth,
              unitSectionWidth: unitSectionWidth,
              sectionHeight: halfHeight,
              isTopSection: false,
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
  final double top;
  final double unitSectionTop;
  final double rowHeight;
  final double cellWidth;
  final double unitSectionWidth;
  final double sectionHeight;
  final bool isTopSection;

  const _PlayerSection({
    required this.player,
    required this.isCurrentPlayer,
    required this.isGameStarted,
    required this.top,
    required this.unitSectionTop,
    required this.rowHeight,
    required this.cellWidth,
    required this.unitSectionWidth,
    required this.sectionHeight,
    required this.isTopSection,
  });

  @override
  Widget build(BuildContext context) {
    final rowTypes = isTopSection
        ? ["Siege", "Ranged", "Close Combat"]
        : ["Close Combat", "Ranged", "Siege"];

    return Stack(
      children: [
        // Unit section (spans all rows)
        Positioned(
          left: cellWidth * 2,
          top: unitSectionTop,
          width: unitSectionWidth,
          height: sectionHeight,
          child: _UnitSection(
            player: player,
            isHighlighted: isGameStarted && isCurrentPlayer,
            rowTypes: rowTypes,
          ),
        ),

        // Total Power section
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

        // Individual cells for each row
        ...List.generate(3, (rowIndex) {
          final rowTop = top + (rowIndex * rowHeight);
          final position = _determinePosition(rowIndex, rowTypes.length);

          return [
            // Weather cell
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

            // Boost cell
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

            // Power cell
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
  final bool isHighlighted;
  final List<String> rowTypes;

  const _UnitSection({
    required this.player,
    required this.isHighlighted,
    required this.rowTypes,
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
            if (i > 0)
              const Divider(color: Colors.black, height: 1, thickness: 1.0),
            const Expanded(
              // Keep the Expanded and Center widgets for consistent layout,
              // but use an empty SizedBox instead of Text
              child: Center(child: SizedBox()),
            ),
          ],
        ],
      ),
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
