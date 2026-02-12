class AppStrings {
  AppStrings._();
  static const String onboardingComplete = "isOnBoardingCompleted";
}

class SharedPrefKeys {
  static const String userToken = 'userToken';
}

class AppLocale {
  AppLocale._();
  static const String english = "en";
  static const String arabic = "ar";
  static const String german = "de";
  static const String french = "fr";
  static const String spanish = "es";
  static const String italian = "it";
  static const String japanese = "ja";
  static const String korean = "ko";
  static const String chinese = "zh";
}

class LanguageNames {
  static const String english = "English";
  static const String arabic = "العربية";
  static const String german = "Deutsch";
  static const String french = "Français";
  static const String spanish = "Español";
  static const String italian = "Italiano";
  static const String japanese = "日本語";
  static const String korean = "한국어";
  static const String chinese = "中文";

  final List<String> supportedLocales = [
    english,
    arabic,
    german,
    french,
    spanish,
    italian,
    japanese,
    korean,
    chinese,
  ];
  static String get defaultLocale => english;
  static List<String> get supported => LanguageNames().supportedLocales;
}

Map<String, String> localeNamesMap = {
  AppLocale.english: LanguageNames.english,
  AppLocale.arabic: LanguageNames.arabic,
  AppLocale.german: LanguageNames.german,
  AppLocale.french: LanguageNames.french,
  AppLocale.spanish: LanguageNames.spanish,
  AppLocale.italian: LanguageNames.italian,
  AppLocale.japanese: LanguageNames.japanese,
  AppLocale.korean: LanguageNames.korean,
  AppLocale.chinese: LanguageNames.chinese,
};

Map<String, String> languageNamesMap = {
  LanguageNames.english: AppLocale.english,
  LanguageNames.arabic: AppLocale.arabic,
  LanguageNames.german: AppLocale.german,
  LanguageNames.french: AppLocale.french,
  LanguageNames.spanish: AppLocale.spanish,
  LanguageNames.italian: AppLocale.italian,
  LanguageNames.japanese: AppLocale.japanese,
  LanguageNames.korean: AppLocale.korean,
  LanguageNames.chinese: AppLocale.chinese,
};

class LanguageFlags {
  static const String english = "us";
  static const String arabic = "eg";
  static const String german = "de";
  static const String french = "fr";
  static const String spanish = "es";
  static const String italian = "it";
  static const String japanese = "jp";
  static const String korean = "kr";
  static const String chinese = "cn";

  final List<String> supportedLocales = [
    english,
    arabic,
    german,
    french,
    spanish,
    italian,
    japanese,
    korean,
    chinese,
  ];
  static String get defaultLocale => english;
  static List<String> get supported => LanguageFlags().supportedLocales;
}
