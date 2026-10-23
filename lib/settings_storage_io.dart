// 2026-10-23
import 'dart:io';
import 'package:path_provider/path_provider.dart';

const String _fileName = 'millitimer_settings.json';

Future<File> _localFile() async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/$_fileName');
}

Future<String?> readSettingsJson() async {
  final file = await _localFile();
  if (await file.exists()) {
    return file.readAsString();
  }
  return null;
}

Future<void> writeSettingsJson(String json) async {
  final file = await _localFile();
  await file.writeAsString(json);
}
