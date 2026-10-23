// 2026-10-23
import 'package:web/web.dart' as web;

const String _key = 'millitimer_settings';

Future<String?> readSettingsJson() async {
  return web.window.localStorage.getItem(_key);
}

Future<void> writeSettingsJson(String json) async {
  web.window.localStorage.setItem(_key, json);
}
