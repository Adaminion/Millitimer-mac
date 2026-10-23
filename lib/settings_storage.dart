// 2026-10-23
// Picks the file-based backend on native platforms and localStorage on web.
export 'settings_storage_io.dart'
    if (dart.library.js_interop) 'settings_storage_web.dart';
