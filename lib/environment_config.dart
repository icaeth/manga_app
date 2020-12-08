import 'package:flutter_riverpod/all.dart';

//maneja la Api Key del servicio de manga

class EnvironmentConfig {
  final mangaApiKey = const String.fromEnvironment("mangaApikey");
}

final environmentConfigProvider = Provider<EnvironmentConfig>((ref) {
  return EnvironmentConfig();
});
