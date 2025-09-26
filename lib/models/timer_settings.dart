import 'package:flutter/material.dart';

enum LabelPosition { top, bottom, left, right }

class TimerSettings {
  double digitFontSize;
  Color digitColor;
  Color digitBackgroundColor;
  String labelText;
  double labelFontSize;
  Color labelFontColor;
  LabelPosition labelPosition;
  Color globalBackgroundColor;
  int startDelaySeconds;
  List<String> laps;
  List<String> recentCustomTexts;

  TimerSettings({
    this.digitFontSize = 72,
    this.digitColor = Colors.white,
    this.digitBackgroundColor = Colors.black,
    this.labelText = '',
    this.labelFontSize = 24,
    this.labelFontColor = Colors.white,
    this.labelPosition = LabelPosition.top,
    this.globalBackgroundColor = const Color(0xFF202020),
    this.startDelaySeconds = 0,
    List<String>? laps,
    List<String>? recentCustomTexts,
  }) : laps = laps ?? [],
       recentCustomTexts = recentCustomTexts ?? [];

  Map<String, dynamic> toJson() {
    return {
      'timerStyle': {
        'digitFontSize': digitFontSize,
        'digitColor': '#${(((digitColor.a * 255.0).round() & 0xff) << 24 | ((digitColor.r * 255.0).round() & 0xff) << 16 | ((digitColor.g * 255.0).round() & 0xff) << 8 | ((digitColor.b * 255.0).round() & 0xff)).toRadixString(16).padLeft(8, '0')}',
        'digitBackgroundColor': '#${(((digitBackgroundColor.a * 255.0).round() & 0xff) << 24 | ((digitBackgroundColor.r * 255.0).round() & 0xff) << 16 | ((digitBackgroundColor.g * 255.0).round() & 0xff) << 8 | ((digitBackgroundColor.b * 255.0).round() & 0xff)).toRadixString(16).padLeft(8, '0')}',
      },
      'labelStyle': {
        'text': labelText,
        'fontSize': labelFontSize,
        'fontColor': '#${(((labelFontColor.a * 255.0).round() & 0xff) << 24 | ((labelFontColor.r * 255.0).round() & 0xff) << 16 | ((labelFontColor.g * 255.0).round() & 0xff) << 8 | ((labelFontColor.b * 255.0).round() & 0xff)).toRadixString(16).padLeft(8, '0')}',
        'position': labelPosition.toString().split('.').last,
      },
      'globalBackground': '#${(((globalBackgroundColor.a * 255.0).round() & 0xff) << 24 | ((globalBackgroundColor.r * 255.0).round() & 0xff) << 16 | ((globalBackgroundColor.g * 255.0).round() & 0xff) << 8 | ((globalBackgroundColor.b * 255.0).round() & 0xff)).toRadixString(16).padLeft(8, '0')}',
      'startDelaySeconds': startDelaySeconds,
      'laps': laps,
      'recentCustomTexts': recentCustomTexts,
    };
  }

  factory TimerSettings.fromJson(Map<String, dynamic> json) {
    return TimerSettings(
      digitFontSize: (json['timerStyle']?['digitFontSize'] ?? 72).toDouble(),
      digitColor: _colorFromHex(json['timerStyle']?['digitColor'] ?? '#FFFFFF'),
      digitBackgroundColor: _colorFromHex(json['timerStyle']?['digitBackgroundColor'] ?? '#000000'),
      labelText: json['labelStyle']?['text'] ?? '',
      labelFontSize: (json['labelStyle']?['fontSize'] ?? 24).toDouble(),
      labelFontColor: _colorFromHex(json['labelStyle']?['fontColor'] ?? '#FFFFFF'),
      labelPosition: _positionFromString(json['labelStyle']?['position'] ?? 'top'),
      globalBackgroundColor: _colorFromHex(json['globalBackground'] ?? '#202020'),
      startDelaySeconds: json['startDelaySeconds'] ?? 0,
      laps: List<String>.from(json['laps'] ?? []),
      recentCustomTexts: List<String>.from(json['recentCustomTexts'] ?? []),
    );
  }

  static Color _colorFromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static LabelPosition _positionFromString(String position) {
    switch (position.toLowerCase()) {
      case 'top':
        return LabelPosition.top;
      case 'bottom':
        return LabelPosition.bottom;
      case 'left':
        return LabelPosition.left;
      case 'right':
        return LabelPosition.right;
      default:
        return LabelPosition.top;
    }
  }

  TimerSettings copyWith({
    double? digitFontSize,
    Color? digitColor,
    Color? digitBackgroundColor,
    String? labelText,
    double? labelFontSize,
    Color? labelFontColor,
    LabelPosition? labelPosition,
    Color? globalBackgroundColor,
    int? startDelaySeconds,
    List<String>? laps,
    List<String>? recentCustomTexts,
  }) {
    return TimerSettings(
      digitFontSize: digitFontSize ?? this.digitFontSize,
      digitColor: digitColor ?? this.digitColor,
      digitBackgroundColor: digitBackgroundColor ?? this.digitBackgroundColor,
      labelText: labelText ?? this.labelText,
      labelFontSize: labelFontSize ?? this.labelFontSize,
      labelFontColor: labelFontColor ?? this.labelFontColor,
      labelPosition: labelPosition ?? this.labelPosition,
      globalBackgroundColor: globalBackgroundColor ?? this.globalBackgroundColor,
      startDelaySeconds: startDelaySeconds ?? this.startDelaySeconds,
      laps: laps ?? List<String>.from(this.laps),
      recentCustomTexts: recentCustomTexts ?? List<String>.from(this.recentCustomTexts),
    );
  }

  void addRecentCustomText(String text) {
    if (text.isEmpty) return;

    // Remove if already exists
    recentCustomTexts.remove(text);

    // Add to the beginning
    recentCustomTexts.insert(0, text);

    // Keep only last 20
    if (recentCustomTexts.length > 20) {
      recentCustomTexts = recentCustomTexts.take(20).toList();
    }
  }
}