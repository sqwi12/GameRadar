import 'package:flutter/cupertino.dart';

/// Выбор темы пользователем. Хранится на устройстве под этими именами.
enum ThemePreference {
  system,
  light,
  dark;

  /// null — как в системе (CupertinoApp сам следит за системной темой).
  Brightness? get brightness => switch (this) {
    ThemePreference.system => null,
    ThemePreference.light => Brightness.light,
    ThemePreference.dark => Brightness.dark,
  };
}

/// Палитра GameRadar. Стекло (панели, кнопки) рисует liquid_glass_widgets,
/// здесь — фон под стеклом, акценты и цвета текста.
abstract final class AppColors {
  /// Фирменный «радарный» бирюзовый.
  static const accent = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF0E9FB0),
    darkColor: Color(0xFF3FD8E6),
  );

  /// Скидки и снижение цены.
  static const discount = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF1FA84F),
    darkColor: Color(0xFF4CE08A),
  );

  /// Онлайн игроков.
  static const online = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF5B4CF0),
    darkColor: Color(0xFFA79BFF),
  );

  static const textPrimary = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF0B1424),
    darkColor: Color(0xFFF4F7FB),
  );

  static const textSecondary = CupertinoDynamicColor.withBrightness(
    color: Color(0x990B1424),
    darkColor: Color(0x99F4F7FB),
  );

  /// Подложка карточек контента. По правилам Liquid Glass контент не стеклянный:
  /// плотная полупрозрачная поверхность читается на любом фоне.
  static const card = CupertinoDynamicColor.withBrightness(
    color: Color(0xD9FFFFFF),
    darkColor: Color(0xCC111A2E),
  );
  static const cardBorder = CupertinoDynamicColor.withBrightness(
    color: Color(0x14000000),
    darkColor: Color(0x1FFFFFFF),
  );
  static const imagePlaceholder = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFDCE6EC),
    darkColor: Color(0xFF1B2640),
  );

  // Фон: глубокий градиент и мягкие световые пятна.
  static const backgroundTop = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFE6F3F7),
    darkColor: Color(0xFF070B18),
  );
  static const backgroundBottom = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFF2EEFF),
    darkColor: Color(0xFF0C1A2E),
  );
  static const glowA = CupertinoDynamicColor.withBrightness(
    color: Color(0x6633C6D6),
    darkColor: Color(0x5513A3B4),
  );
  static const glowB = CupertinoDynamicColor.withBrightness(
    color: Color(0x557B6CFF),
    darkColor: Color(0x554C3BD9),
  );
  static const glowC = CupertinoDynamicColor.withBrightness(
    color: Color(0x44FF9EC4),
    darkColor: Color(0x33B13A8B),
  );
  static const radarRing = CupertinoDynamicColor.withBrightness(
    color: Color(0x140B1424),
    darkColor: Color(0x12FFFFFF),
  );
}

abstract final class AppTheme {
  static CupertinoThemeData of(
    ThemePreference preference,
  ) => CupertinoThemeData(
    brightness: preference.brightness,
    primaryColor: AppColors.accent,
    // Под стеклом всегда лежит AppBackground, поэтому фон страниц прозрачный.
    scaffoldBackgroundColor: const Color(0x00000000),
    barBackgroundColor: const Color(0x00000000),
    textTheme: const CupertinoTextThemeData(
      primaryColor: AppColors.accent,
      textStyle: TextStyle(
        inherit: false,
        fontSize: 17,
        letterSpacing: -0.41,
        color: AppColors.textPrimary,
      ),
      navLargeTitleTextStyle: TextStyle(
        inherit: false,
        fontSize: 34,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.37,
        color: AppColors.textPrimary,
      ),
    ),
  );
}

/// Типографика экранов в стиле iOS.
abstract final class AppText {
  static TextStyle largeTitle(BuildContext context) => TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
    color: AppColors.textPrimary.resolveFrom(context),
  );

  static TextStyle title(BuildContext context) => TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.4,
    color: AppColors.textPrimary.resolveFrom(context),
  );

  static TextStyle body(BuildContext context) => TextStyle(
    fontSize: 16,
    letterSpacing: -0.3,
    color: AppColors.textPrimary.resolveFrom(context),
  );

  static TextStyle secondary(BuildContext context) => TextStyle(
    fontSize: 14,
    letterSpacing: -0.15,
    color: AppColors.textSecondary.resolveFrom(context),
  );

  static TextStyle sectionHeader(BuildContext context) => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    color: AppColors.textSecondary.resolveFrom(context),
  );
}
