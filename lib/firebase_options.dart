import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/services.dart' show rootBundle;

/// Firebase client options loaded from the local .env configuration.
class DefaultFirebaseOptions {
  static final Map<String, String> _values = {};

  static Future<void> load() async {
    final contents = await rootBundle.loadString('.env');
    final normalizedContents = contents.replaceFirst('\uFEFF', '');
    _values.clear();

    for (final line in normalizedContents.split('\n')) {
      final entry = line.trim();
      if (entry.isEmpty || entry.startsWith('#')) continue;

      final separator = entry.indexOf('=');
      if (separator <= 0) continue;

      final name = entry.substring(0, separator).trim();
      final value = entry.substring(separator + 1).trim();
      _values[name] = value;
    }
  }

  static String _required(String name) {
    final value = _values[name];
    if (value == null || value.isEmpty) {
      throw StateError('Missing $name in the local .env configuration.');
    }
    return value;
  }

  static FirebaseOptions get currentPlatform {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      throw UnsupportedError(
        'Firebase options are only configured for Android.',
      );
    }
    return android;
  }

  static FirebaseOptions get android => FirebaseOptions(
        apiKey: _required('FIREBASE_API_KEY'),
        appId: _required('FIREBASE_APP_ID'),
        messagingSenderId: _required('FIREBASE_MESSAGING_SENDER_ID'),
        projectId: _required('FIREBASE_PROJECT_ID'),
        storageBucket: _required('FIREBASE_STORAGE_BUCKET'),
      );
}
