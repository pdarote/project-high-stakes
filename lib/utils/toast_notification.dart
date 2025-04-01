import "dart:async";

import "package:flutter/material.dart";

/// A utility class to show custom toast notifications with fade animations.
class ToastNotification {
  final BuildContext context;
  final AnimationController controller;
  OverlayEntry? _overlayEntry;
  Timer? _dismissTimer;

  ToastNotification({
    required this.context,
    required this.controller,
  });

  /// Show a toast notification with the given message.
  /// The toast will automatically dismiss after [duration] seconds.
  void show(String message, {Duration? duration, Color? backgroundColor}) {
    // Cancel any existing toast
    hide();

    try {
      // Create and insert the overlay
      _overlayEntry =
          _createToastOverlay(message, backgroundColor: backgroundColor);
      final overlay = Overlay.of(context);
      overlay.insert(_overlayEntry!);

      // Start show animation
      controller.forward();

      // Auto dismiss after duration
      final autoDismissDuration = duration ?? const Duration(seconds: 5);
      _dismissTimer = Timer(autoDismissDuration, hide);
    } catch (e) {
      debugPrint("Error showing toast: $e");
    }
  }

  /// Hide the currently showing toast with a fade animation.
  void hide() {
    _dismissTimer?.cancel();
    _dismissTimer = null;

    if (_overlayEntry != null) {
      controller.reverse().then((_) {
        _removeEntry();
      });
    }
  }

  void _removeEntry() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Create the overlay entry for the toast notification.
  OverlayEntry _createToastOverlay(String message, {Color? backgroundColor}) {
    // Apply 75% opacity to the background color
    final bgColor = (backgroundColor ?? Colors.blue.shade800).withOpacity(0.5);

    return OverlayEntry(
      builder: (context) => Positioned(
        bottom: 16.0,
        left: 16.0,
        right: 16.0,
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: controller,
            curve: Curves.easeIn,
            reverseCurve: Curves.easeOut,
          ),
          child: Material(
            borderRadius: BorderRadius.circular(8),
            color: bgColor,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Center(
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: hide,
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Clean up resources.
  void dispose() {
    _dismissTimer?.cancel();
    _removeEntry();
  }
}
