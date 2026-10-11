import 'package:flutter/cupertino.dart';
import 'package:gameradar_shared/gameradar_shared.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../l10n/gen/app_localizations.dart';
import '../theme/app_theme.dart';
import 'app_controls.dart';
import 'l10n.dart';

/// Чип «Жанр ▾»: открывает список жанров, выбранный жанр — в подписи.
class GenreChip extends StatelessWidget {
  const GenreChip({required this.genre, required this.onSelected, super.key});

  final String? genre;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppChip(
      label: genre == null ? l10n.genreAny : genreName(l10n, genre!),
      icon: CupertinoIcons.square_grid_2x2,
      selected: genre != null,
      onTap: () => GlassModalSheet.show<void>(
        context: context,
        halfSize: 0.7,
        builder: (_) => _GenreSheet(selected: genre, onSelected: onSelected),
      ),
    );
  }
}

class _GenreSheet extends StatelessWidget {
  const _GenreSheet({required this.selected, required this.onSelected});

  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    void pick(String? genre) {
      Navigator.of(context).pop();
      onSelected(genre);
    }

    Widget tile(String? genre) => AppListTile(
      title: Text(genre == null ? l10n.genreAny : genreName(l10n, genre)),
      trailing: genre == selected
          ? Icon(
              CupertinoIcons.checkmark_alt,
              color: AppColors.accent.resolveFrom(context),
            )
          : null,
      onTap: () => pick(genre),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.genreTitle,
            style: AppText.largeTitle(context).copyWith(fontSize: 24),
          ),
          const SizedBox(height: 14),
          AppGroupedSection(
            children: [tile(null), for (final g in SteamGenres.common) tile(g)],
          ),
        ],
      ),
    );
  }
}

/// Жанр Steam на языке приложения.
String genreName(AppLocalizations l10n, String genre) => switch (genre) {
  'Action' => l10n.genreAction,
  'Adventure' => l10n.genreAdventure,
  'RPG' => l10n.genreRpg,
  'Strategy' => l10n.genreStrategy,
  'Simulation' => l10n.genreSimulation,
  'Indie' => l10n.genreIndie,
  'Casual' => l10n.genreCasual,
  'Sports' => l10n.genreSports,
  'Racing' => l10n.genreRacing,
  'Massively Multiplayer' => l10n.genreMmo,
  'Early Access' => l10n.genreEarlyAccess,
  _ => genre,
};
