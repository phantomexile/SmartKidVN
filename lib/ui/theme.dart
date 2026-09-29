import 'package:flutter/material.dart';

/// Bảng màu dùng chung: cam cho hành động, vàng/xanh cho hai loại xu riêng biệt.
abstract final class KidColors {
  static const cream = Color(0xFFFFFBF3);
  static const ink = Color(0xFF173C3B);
  static const muted = Color(0xFF78837B);
  static const orange = Color(0xFFFF702A);
  static const green = Color(0xFF769953);
  static const sage = Color(0xFFEBF1DD);
  static const blue = Color(0xFF278FDF);
  static const sky = Color(0xFFE9F4FF);
  static const line = Color(0xFFECE6D9);
  static const peach = Color(0xFFFFEDDC);
}

ThemeData kidTheme() => ThemeData(
  useMaterial3: true,
  fontFamily: 'Nunito',
  scaffoldBackgroundColor: KidColors.cream,
  colorScheme: ColorScheme.fromSeed(
    seedColor: KidColors.orange,
    primary: KidColors.orange,
    secondary: KidColors.green,
    surface: KidColors.cream,
    onSurface: KidColors.ink,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 36,
      height: 1.08,
      fontWeight: FontWeight.w900,
      color: KidColors.ink,
    ),
    headlineMedium: TextStyle(
      fontSize: 29,
      height: 1.17,
      fontWeight: FontWeight.w900,
      color: KidColors.ink,
    ),
    titleLarge: TextStyle(
      fontSize: 21,
      fontWeight: FontWeight.w900,
      color: KidColors.ink,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w800,
      color: KidColors.ink,
    ),
    bodyLarge: TextStyle(fontSize: 15, height: 1.45, color: KidColors.ink),
    bodyMedium: TextStyle(fontSize: 13, height: 1.4, color: KidColors.ink),
    bodySmall: TextStyle(fontSize: 11, height: 1.35, color: KidColors.muted),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white.withValues(alpha: .75),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: KidColors.line),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: KidColors.line),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: KidColors.orange),
    ),
  ),
  dividerColor: KidColors.line,
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: KidColors.ink,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
);
