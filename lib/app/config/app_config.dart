class AppConfig {

  static const String appVersion = String.fromEnvironment(
    'VERSION',
    defaultValue: 'x.x.x',
  );

  static const String shaHash = String.fromEnvironment(
    'SHA_HASH',
    defaultValue: 'abcdef',
  );


  static const bool debugMode = bool.fromEnvironment(
    'DEBUG_MODE',
    defaultValue: false,
  );

}