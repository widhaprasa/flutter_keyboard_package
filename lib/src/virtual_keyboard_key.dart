import 'package:flutter/widgets.dart';

/// Defines the action a specific key performs.
enum VirtualKeyboardKeyAction {
  /// Inserts the [text] into the input.
  actionText,

  /// Removes a character or acts as a backspace.
  actionBackspace,

  /// Acts as a space character.
  actionSpace,

  /// Acts as a return/enter key.
  actionEnter,

  /// Triggers a shift toggle (caps lock, etc.).
  actionShift,

  /// Toggles special characters or numeric layouts.
  actionSpecialCharacters,

  /// Toggles secondary special characters (#+=).
  actionSpecialCharactersSecondary,

  /// A completely custom action defined by the user.
  actionCustom,
}

/// Represents an individual key on the virtual keyboard.
class VirtualKeyboardKey {
  const VirtualKeyboardKey({
    this.text,
    this.action = VirtualKeyboardKeyAction.actionText,
    this.child,
    this.flex = 1,
    this.alwaysLowercase = false,
  });

  /// The text to display and insert when the key is pressed.
  /// Mandatory if [action] is [VirtualKeyboardKeyAction.actionText].
  final String? text;

  /// The predefined action of the key.
  final VirtualKeyboardKeyAction action;

  /// A custom widget to display on the key instead of the text.
  /// Useful for icons like backspace or custom branding.
  final Widget? child;

  /// The flex factor for this key's width in the row.
  /// Defaults to 1. Larger values mean a wider key.
  final int flex;

  /// If true, the key will not be capitalized even when shift is enabled.
  /// Useful for extensions like '.com'.
  final bool alwaysLowercase;
}

/// Represents the shift states of the keyboard.
enum VirtualKeyboardShiftState {
  lowercase,
  shift, // One letter capitalized
  capsLock, // Locked capitalization
}

/// Represents which layout type is currently active.
enum VirtualKeyboardLayoutType { primary, special, specialSecondary }
