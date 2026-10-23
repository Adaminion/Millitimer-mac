// 2026-10-23
import 'dart:convert';
import 'settings_storage.dart';
import 'timer_settings.dart';

class SettingsService {
  Future<TimerSettings> loadSettings() async {
    try {
      final contents = await readSettingsJson();
      if (contents != null) {
        final json = jsonDecode(contents);
        return TimerSettings.fromJson(json);
      }
    } catch (e) {
      // Error loading settings, return default
    }
    return TimerSettings();
  }

  Future<void> saveSettings(TimerSettings settings) async {
    try {
      final json = jsonEncode(settings.toJson());
      await writeSettingsJson(json);
    } catch (e) {
      // Error saving settings, fail silently
    }
  }
}
