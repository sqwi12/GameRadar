import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:flutter/widgets.dart';

import '../../l10n/gen/app_localizations.dart';
import '../network/app_exception.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Понятный пользователю текст ошибки.
String describeError(AppLocalizations l10n, Object error) =>
    switch (AppException.from(error)) {
      NetworkException() => l10n.errorNetwork,
      ApiFailure(statusCode: 404) => l10n.errorNotFound,
      ApiFailure(statusCode: 401) => l10n.errorUnauthorized,
      ApiFailure(code: ApiErrorCode.validation) => l10n.errorValidation,
      ApiFailure(statusCode: >= 500) => l10n.errorServer,
      ApiFailure() || UnknownException() => l10n.errorUnknown,
    };
