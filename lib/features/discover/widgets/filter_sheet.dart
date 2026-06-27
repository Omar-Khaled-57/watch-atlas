import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/dimensions.dart';
import '../../../l10n/l10n.dart';
import '../providers/discover_providers.dart';

class FilterSheet extends ConsumerStatefulWidget {
  const FilterSheet({super.key});

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  late RangeValues _yearRange;
  late RangeValues _ratingRange;
  late String? _selectedCountry;

  Map<String, String> get _countries => Localizations.localeOf(context).languageCode == 'ar'
      ? {
          'US': 'الولايات المتحدة',
          'GB': 'المملكة المتحدة',
          'KR': 'كوريا الجنوبية',
          'JP': 'اليابان',
          'IN': 'الهند',
          'FR': 'فرنسا',
          'DE': 'ألمانيا',
          'ES': 'إسبانيا',
          'BR': 'البرازيل',
          'CA': 'كندا',
          'AU': 'أستراليا',
          'CN': 'الصين',
          'TW': 'تايوان',
          'HK': 'هونغ كونغ',
          'TH': 'تايلاند',
          'EG': 'مصر',
          'SA': 'السعودية',
          'AE': 'الإمارات',
        }
      : {
          'US': 'United States',
          'GB': 'United Kingdom',
          'KR': 'South Korea',
          'JP': 'Japan',
          'IN': 'India',
          'FR': 'France',
          'DE': 'Germany',
          'ES': 'Spain',
          'BR': 'Brazil',
          'CA': 'Canada',
          'AU': 'Australia',
          'CN': 'China',
          'TW': 'Taiwan',
          'HK': 'Hong Kong',
          'TH': 'Thailand',
          'EG': 'Egypt',
          'SA': 'Saudi Arabia',
          'AE': 'UAE',
        };

  @override
  void initState() {
    super.initState();
    final filters = ref.read(discoverFilterProvider);
    _yearRange = RangeValues(
      (filters.yearFrom ?? 1970).toDouble(),
      (filters.yearTo ?? 2026).toDouble(),
    );
    _ratingRange = RangeValues(
      filters.ratingFrom ?? 0,
      filters.ratingTo ?? 10,
    );
    _selectedCountry = filters.country;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsetsDirectional.all(Spacing.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(20),
          topEnd: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: EdgeInsetsDirectional.only(bottom: 20),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            context.l10n.advancedFilters,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: Spacing.xl),
          Text(
            context.l10n.country,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: Spacing.sm),
          DropdownButtonFormField<String>(
            value: _selectedCountry,
            decoration: InputDecoration(
              contentPadding: EdgeInsetsDirectional.symmetric(
                horizontal: Spacing.lg,
                vertical: Spacing.md,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: context.l10n.allCountries,
            ),
            items: [
              DropdownMenuItem(value: null, child: Text(context.l10n.allCountries)),
              ..._countries.entries.map(
                (e) => DropdownMenuItem(
                  value: e.key,
                  child: Text(context.l10n.countryWithCode(e.value, e.key)),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() => _selectedCountry = value);
            },
          ),
          SizedBox(height: 20),
          Text(
            context.l10n.yearRange,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: Spacing.sm),
          RangeSlider(
            values: _yearRange,
            min: 1970,
            max: 2026,
            divisions: 56,
            labels: RangeLabels(
              _yearRange.start.toInt().toString(),
              _yearRange.end.toInt().toString(),
            ),
            onChanged: (values) {
              setState(() => _yearRange = values);
            },
          ),
          SizedBox(height: Spacing.xs),
          Text(
            context.l10n.ratingRange,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: Spacing.sm),
          RangeSlider(
            values: _ratingRange,
            min: 0,
            max: 10,
            divisions: 20,
            labels: RangeLabels(
              _ratingRange.start.toStringAsFixed(1),
              _ratingRange.end.toStringAsFixed(1),
            ),
            onChanged: (values) {
              setState(() => _ratingRange = values);
            },
          ),
          SizedBox(height: Spacing.xl),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _yearRange = RangeValues(1970, 2026);
                      _ratingRange = RangeValues(0, 10);
                      _selectedCountry = null;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsetsDirectional.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(context.l10n.reset),
                ),
              ),
              SizedBox(width: Spacing.lg),
              Expanded(
                child: FilledButton(
                  onPressed: _applyFilters,
                  style: FilledButton.styleFrom(
                    padding: EdgeInsetsDirectional.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(context.l10n.applyFilters),
                ),
              ),
            ],
          ),
          SizedBox(height: Spacing.lg),
        ],
      ),
    );
  }

  void _applyFilters() {
    ref.read(discoverFilterProvider.notifier).setCountry(_selectedCountry);
    ref
        .read(discoverFilterProvider.notifier)
        .setYearRange(_yearRange.start.toInt(), _yearRange.end.toInt());
    ref
        .read(discoverFilterProvider.notifier)
        .setRatingRange(_ratingRange.start, _ratingRange.end);
    Navigator.of(context).pop();
  }
}
