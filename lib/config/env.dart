enum AppEnvironment { dev, qa, staging, prod }

class Env {
  const Env._();

  static const environment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  static const enableAds = bool.fromEnvironment(
    'ENABLE_ADS',
    defaultValue: false,
  );

  static AppEnvironment get appEnvironment => switch (environment) {
        'prod' => AppEnvironment.prod,
        'qa' => AppEnvironment.qa,
        'staging' => AppEnvironment.staging,
        _ => AppEnvironment.dev,
      };

  static const authEnabled = bool.fromEnvironment(
    'AUTH_ENABLED',
    defaultValue: false,
  );

  static const shivBotProvider = String.fromEnvironment(
    'SHIVBOT_PROVIDER',
    defaultValue: 'local',
  );

  static const openAiApiBaseUrl = String.fromEnvironment(
    'OPENAI_API_BASE_URL',
    defaultValue: 'https://api.openai.com/v1',
  );

  static const geminiApiBaseUrl = String.fromEnvironment(
    'GEMINI_API_BASE_URL',
    defaultValue: 'https://generativelanguage.googleapis.com/v1beta',
  );

  static const bedrockProxyBaseUrl = String.fromEnvironment(
    'BEDROCK_PROXY_BASE_URL',
    defaultValue: 'https://example-bedrock-proxy.cloudfunctions.net',
  );
}
