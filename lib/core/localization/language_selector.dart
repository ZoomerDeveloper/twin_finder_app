import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'language_cubit.dart';
import 'app_localizations.dart';
import '../utils/app_colors.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        final currentLanguage = state is LanguageLoadedState
            ? state.currentLanguage
            : 'en';

        return GestureDetector(
          onTap: () => _showLanguageDialog(context, currentLanguage),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.language, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.languageNames[currentLanguage] ?? 'English',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Bricolage Grotesque',
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context, String currentLanguage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LanguageSelectionDialog(currentLanguage: currentLanguage);
      },
    );
  }
}

class LanguageSelectionDialog extends StatelessWidget {
  final String currentLanguage;

  const LanguageSelectionDialog({super.key, required this.currentLanguage});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context).getString('select_language'),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Bricolage Grotesque',
              ),
            ),
            const SizedBox(height: 24),
            ...AppLocalizations.supportedLocales.map((locale) {
              final languageCode = locale.languageCode;
              final isSelected = languageCode == currentLanguage;

              return GestureDetector(
                onTap: () {
                  context.read<LanguageCubit>().changeLanguage(languageCode);
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.backgroundBottom.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.backgroundBottom
                          : Colors.grey.withOpacity(0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: AppColors.backgroundBottom,
                          size: 20,
                        )
                      else
                        const SizedBox(width: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.languageNames[languageCode] ??
                                  'Unknown',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? AppColors.backgroundBottom
                                    : Colors.black87,
                                fontFamily: 'Bricolage Grotesque',
                              ),
                            ),
                            Text(
                              AppLocalizations
                                      .languageNamesEnglish[languageCode] ??
                                  'Unknown',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontFamily: 'Bricolage Grotesque',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                AppLocalizations.of(context).getString('cancel') ?? 'Cancel',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontFamily: 'Bricolage Grotesque',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
