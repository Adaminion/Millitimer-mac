import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/timer_settings.dart';

class SettingsService {
  static const String _fileName = 'millitimer_settings.json';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_fileName');
  }

  Future<TimerSettings> loadSettings() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
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
      final file = await _localFile;
      final json = jsonEncode(settings.toJson());
      await file.writeAsString(json);
    } catch (e) {
      // Error saving settings, fail silently
    }
  }
}