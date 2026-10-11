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
  /// Фирменный «радарный» бирюзовый. Единственный яркий цвет интерфейса:
  /// кроме него цветом выделяются только скидки.
  static const accent = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF0A8F9E),
    darkColor: Color(0xFF4FD6E3),
  );

  /// Скидки и снижение цены.
  static const discount = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF138A43),
    darkColor: Color(0xFF5BE39A),
  );

  /// Подложка бейджа скидки: тот же зелёный, приглушённый.
  static const discountTint = CupertinoDynamicColor.withBrightness(
    color: Color(0x1F138A43),
    darkColor: Color(0x295BE39A),
  );

  /// Онлайн игроков: спокойный нейтральный, чтобы не спорить с ценой.
  static const online = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF4F5B70),
    darkColor: Color(0xFFAAB6CC),
  );

  static const textPrimary = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF0C1322),
    darkColor: Color(0xFFF2F5FA),
  );

  static const textSecondary = CupertinoDynamicColor.withBrightness(
    color: Color(0x8C0C1322),
    darkColor: Color(0x8CF2F5FA),
  );

  /// Подложка карточек контента. По правилам Liquid Glass контент не стеклянный:
  /// плотная полупрозрачная поверхность читается на любом фоне.
  static const card = CupertinoDynamicColor.withBrightness(
    color: Color(0xEBFFFFFF),
    darkColor: Color(0xB8141C2C),
  );

  /// Тонкая кромка карточки: в тёмной теме — светлый блик, в светлой — тень.
  static const cardBorder = CupertinoDynamicColor.withBrightness(
    color: Color(0x0F0C1322),
    darkColor: Color(0x12FFFFFF),
  );

  /// Кромка кнопок, переключателей и разделители строк.
  static const controlBorder = CupertinoDynamicColor.withBrightness(
    color: Color(0x140C1322),
    darkColor: Color(0x1AFFFFFF),
  );
  static const imagePlaceholder = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFE3E8EF),
    darkColor: Color(0xFF1A2336),
  );

  /// Нижняя панель вкладок. Почти непрозрачная: живое размытие под ней
  /// стоило слишком дорого при прокрутке.
  static const tabBar = CupertinoDynamicColor.withBrightness(
    color: Color(0xF5F7F9FC),
    darkColor: Color(0xF51B2436),
  );

  /// Плашка поверх обложки (место в топе).
  static const overlayChip = Color(0xB3070B14);

  // Фон: почти чёрный синий с одним мягким бирюзовым свечением сверху.
  static const backgroundTop = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFF3F6F9),
    darkColor: Color(0xFF0A101C),
  );
  static const backgroundBottom = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFE9EDF3),
    darkColor: Color(0xFF05070D),
  );
  static const glowA = CupertinoDynamicColor.withBrightness(
    color: Color(0x3326B5C4),
    darkColor: Color(0x3313A3B4),
  );
  static const glowB = CupertinoDynamicColor.withBrightness(
    color: Color(0x1F6C7BFF),
    darkColor: Color(0x1F3B4BD9),
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
    fontSize: 30,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
    height: 1.15,
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
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    color: AppColors.textSecondary.resolveFrom(context),
  );

  /// Цифры (цены, онлайн): одинаковой ширины, чтобы колонки не «прыгали».
  static const tabular = [FontFeature.tabularFigures()];
}
