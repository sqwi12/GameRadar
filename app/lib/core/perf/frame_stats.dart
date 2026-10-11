import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

/// Замер плавности: раз в 3 секунды пишет в журнал время кадров.
///
/// Включается только в сборке с флагом, в обычной не делает ничего:
/// `flutter run --profile --dart-define=PERF_LOG=true`,
/// журнал: `adb logcat -s flutter`.
abstract final class FrameStats {
  static const enabled = bool.fromEnvironment('PERF_LOG');

  /// Кадр дольше этого — рывок при 60 Гц.
  static const _budget = Duration(microseconds: 16667);

  static final _build = <int>[];
  static final _raster = <int>[];

  static void start() {
    if (!enabled) return;
    SchedulerBinding.instance.addTimingsCallback(_onTimings);
    Timer.periodic(const Duration(seconds: 3), (_) => _report());
  }

  static void _onTimings(List<FrameTiming> timings) {
    for (final t in timings) {
      _build.add(t.buildDuration.inMicroseconds);
      _raster.add(t.rasterDuration.inMicroseconds);
    }
  }

  static void _report() {
    if (_build.isEmpty) return;
    String stats(List<int> v) {
      final sorted = [...v]..sort();
      final avg = v.reduce((a, b) => a + b) / v.length / 1000;
      final p90 =
          sorted[(sorted.length * 0.9).floor().clamp(0, sorted.length - 1)] /
          1000;
      final slow = v.where((us) => us > _budget.inMicroseconds).length;
      return 'ср ${avg.toStringAsFixed(1)} мс, p90 ${p90.toStringAsFixed(1)} мс, >16 мс: $slow';
    }

    debugPrint(
      'PERF кадров ${_build.length} | build: ${stats(_build)} | raster: ${stats(_raster)}',
    );
    _build.clear();
    _raster.clear();
  }
}
