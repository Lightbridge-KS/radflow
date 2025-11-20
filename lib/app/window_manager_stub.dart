// Stub implementations for web platform
// This file provides empty implementations of window manager functionality
// when running on web where window management is not available

import 'package:flutter/material.dart';

// Stub class for WindowOptions
class WindowOptions {
  const WindowOptions({
    Size? size,
    bool? center,
    Color? backgroundColor,
    bool? skipTaskbar,
    TitleBarStyle? titleBarStyle,
  });
}

// Stub enum for TitleBarStyle
enum TitleBarStyle {
  normal,
}

// Stub class for WindowManager
class WindowManager {
  Future<void> ensureInitialized() async {
    // No-op for web
  }

  void setMinimumSize(Size size) {
    // No-op for web
  }

  void waitUntilReadyToShow(WindowOptions options, Function() callback) {
    // No-op for web
  }

  Future<void> show() async {
    // No-op for web
  }

  Future<void> focus() async {
    // No-op for web
  }
}

// Create a singleton instance
final WindowManager windowManager = WindowManager();