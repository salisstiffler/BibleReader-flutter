import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:ui'; // Import dart:ui for ImageFilter
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../theme.dart';
import '../services/version_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.settingsTitle),
            elevation: 0,
            backgroundColor:
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.85),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _SettingsPageHelper.buildAuthSection(
                    context, provider, l10n),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _SettingsPageHelper.buildSectionTitle(
                    context, LucideIcons.globe, l10n.settingsUiLanguage),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _SettingsPageHelper.buildGlassmorphismCard(
                  context,
                  child: _SettingsPageHelper.buildLanguageButtons(
                      context, provider, l10n),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _SettingsPageHelper.buildSectionTitle(
                    context, LucideIcons.sparkles, l10n.settingsVisualStyle),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _SettingsPageHelper.buildGlassmorphismCard(
                  context,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SettingsPageHelper.buildThemeButtons(
                            context, provider, l10n),
                        const SizedBox(height: 20),
                        _SettingsPageHelper.buildAccentColorControl(
                            context, provider, l10n),
                      ],
                    ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _SettingsPageHelper.buildSectionTitle(context,
                    LucideIcons.activity, '阅读'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _SettingsPageHelper.buildGlassmorphismCard(
                  context,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SettingsPageHelper.buildFontSizeControl(
                            context, provider, l10n),
                        const SizedBox(height: 24),
                        _SettingsPageHelper.buildLineHeightControl(
                            context, provider, l10n),
                        const SizedBox(height: 24),
                        _SettingsPageHelper.buildFontFamilyControl(
                            context, provider, l10n),
                        const SizedBox(height: 24),
                        _SettingsPageHelper.buildPageTurnEffectControl(
                            context, provider, l10n),
                      ],
                    ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _SettingsPageHelper.buildSectionTitle(context,
                    LucideIcons.book, 'TTS朗读'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _SettingsPageHelper.buildGlassmorphismCard(
                  context,
                  child: Column(
                    children: [
                      _SettingsPageHelper.buildPlaybackRateControl(
                          context, provider, l10n),
                      const SizedBox(height: 24),
                      _SettingsPageHelper.buildToggle(
                        context,
                        title: l10n.settingsContinuousReading,
                        subtitle: l10n.settingsContinuousReadingDesc,
                        value: provider.continuousReading,
                        onChanged: (value) => provider.continuousReading = value,
                      ),
                      const SizedBox(height: 20),
                      _SettingsPageHelper.buildToggle(
                        context,
                        title: l10n.settingsPauseOnSwitch,
                        subtitle: l10n.settingsPauseOnSwitchDesc,
                        value: provider.pauseOnManualSwitch,
                        onChanged: (value) =>
                            provider.pauseOnManualSwitch = value,
                      ),
                    ],
                  ),
                ),
              ),
              _SettingsPageHelper.buildFooter(context, l10n),
            ],
          ),
        );
      },
    );
  }
}

class _SettingsPageHelper {
  static Widget buildAuthSection(
      BuildContext context, AppProvider provider, AppLocalizations l10n) {
    return _SettingsPageHelper.buildGlassmorphismCard(
      context,
      child: provider.user == null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.authLoginTitle,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(l10n.authLoginDesc,
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _LoginRegisterDialog(
                              provider: provider, l10n: l10n);
                        },
                      );
                    },
                    child: Text(l10n.authLoginBtn),
                  ),
                ),
              ],
            )
          : _SettingsPageHelper.buildUserInfo(context, provider, l10n),
    );
  }

  static Widget buildUserInfo(
      BuildContext context, AppProvider provider, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.authLoggedIn,
                style: Theme.of(context).textTheme.titleLarge),
            Text(provider.user!.username,
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        ElevatedButton(
          onPressed: () => provider.logout(),
          child: Text(l10n.authLogout),
        ),
      ],
    );
  }

  static Widget buildGlassmorphismCard(
    BuildContext context, {
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  static Widget buildSectionTitle(
      BuildContext context, IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).primaryColor,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  static Widget buildLanguageButtons(
      BuildContext context, AppProvider provider, AppLocalizations l10n) {
    return Row(
      children: [
        _SettingsPageHelper.buildLanguageButton(
            context, provider, 'zh-Hans', l10n.simplifiedChinese,
            provider.currentLanguage == 'zh-Hans'),
        _SettingsPageHelper.buildLanguageButton(
            context, provider, 'zh-Hant', l10n.traditionalChinese,
            provider.currentLanguage == 'zh-Hant'),
        _SettingsPageHelper.buildLanguageButton(
            context, provider, 'en', l10n.english, provider.currentLanguage == 'en'),
      ],
    );
  }

  static Widget buildLanguageButton(
    BuildContext context,
    AppProvider provider,
    String langCode,
    String label,
    bool isActive,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: InkWell(
          onTap: () => provider.changeLanguage(langCode),
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: isActive
                  ? LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withAlpha(180)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isActive ? null : Theme.of(context).cardColor,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isActive
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget buildThemeButtons(
      BuildContext context, AppProvider provider, AppLocalizations l10n) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: _SettingsPageHelper.buildThemeButton(
              context, provider, AppTheme.light, l10n.settingsThemeLight, LucideIcons.sun),
        ),
        Expanded(
          child: _SettingsPageHelper.buildThemeButton(
              context, provider, AppTheme.dark, l10n.settingsThemeDark, LucideIcons.moon),
        ),
        Expanded(
          child: _SettingsPageHelper.buildThemeButton(
              context, provider, AppTheme.sepia, l10n.settingsThemeSepia, LucideIcons.eye),
        ),
      ],
    );
  }

  static Widget buildThemeButton(
    BuildContext context,
    AppProvider provider,
    AppTheme theme,
    String label,
    IconData icon,
  ) {
    final isActive = provider.theme == theme;
    // Use provider.accentColor as the highlight for selected state
    Color accentColor;
    try {
      accentColor = Color(int.parse('0xFF${provider.accentColor.substring(1)}'));
    } catch (_) {
      accentColor = Theme.of(context).primaryColor;
    }

    return GestureDetector(
      onTap: () => provider.theme = theme,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border.all(color: accentColor, width: 2)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive
                  ? accentColor
                  : Theme.of(context).textTheme.bodyLarge?.color,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isActive ? accentColor : null,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildAccentColorControl(
      BuildContext context, AppProvider provider, AppLocalizations l10n) {
    final colors = [
      '#6366f1',
      '#818cf8',
      '#3b82f6',
      '#06b6d4',
      '#10b981',
      '#f59e0b',
      '#ef4444',
      '#ec4899',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.settingsAccentColor,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: colors.map((color) {
            final isActive = provider.accentColor == color;
            final colorValue = Color(int.parse('0xFF${color.substring(1)}'));
            return InkWell(
              onTap: () => provider.accentColor = color,
              borderRadius: BorderRadius.circular(50),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? Colors.transparent : colorValue,
                  border: isActive
                      ? Border.all(
                          color: colorValue,
                          width: 2,
                        )
                      : null,
                ),
                child: isActive
                    ? Center(
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorValue,
                          ),
                        ),
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  static Widget buildFontSizeControl(
      BuildContext context, AppProvider provider, AppLocalizations l10n) {
    return _SettingsPageHelper.buildSliderControl(
      context: context,
      title: l10n.settingsFontSize,
      value: provider.fontSize,
      label: '${provider.fontSize.round()}px',
      min: 12,
      max: 32,
      divisions: 20,
      onChanged: (value) => provider.fontSize = value,
    );
  }

  static Widget buildLineHeightControl(
      BuildContext context, AppProvider provider, AppLocalizations l10n) {
    return _SettingsPageHelper.buildSliderControl(
      context: context,
      title: l10n.settingsLineHeight,
      value: provider.lineHeight,
      label: provider.lineHeight.toStringAsFixed(1),
      min: 1.0,
      max: 2.5,
      divisions: 15,
      onChanged: (value) => provider.lineHeight = value,
    );
  }

  static Widget buildPlaybackRateControl(
      BuildContext context, AppProvider provider, AppLocalizations l10n) {
    return _SettingsPageHelper.buildSliderControl(
      context: context,
      title: l10n.settingsSpeechRate,
      value: provider.playbackRate,
      label: '${provider.playbackRate.toStringAsFixed(1)}x',
      min: 0.5,
      max: 2.0,
      divisions: 15,
      onChanged: (value) => provider.playbackRate = value,
    );
  }

  static Widget buildSliderControl({
    required BuildContext context,
    required String title,
    required double value,
    required String label,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: label,
          onChanged: onChanged,
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
      ],
    );
  }

  static Widget buildFontFamilyControl(
      BuildContext context, AppProvider provider, AppLocalizations l10n) {
    final families = {
      'default': l10n.settingsFontsSans,
      'shoushu': '扶摇手书',
      'songkai': '宋刻楷体',
      'bai ge': '天行体',
      'heiti': '刚正黑',
    };
    return _SettingsPageHelper.buildSegmentedControl(
      context: context,
      title: l10n.settingsFontFamily,
      options: families,
      selectedValue: provider.fontFamily,
      onChanged: (value) => provider.fontFamily = value,
    );
  }

  static Widget buildPageTurnEffectControl(
      BuildContext context, AppProvider provider, AppLocalizations l10n) {
    final effects = {
      'none': l10n.settingsAnimationsNone,
      'fade': l10n.settingsAnimationsFade,
      'slide': l10n.settingsAnimationsSlide,
      'curl': l10n.settingsAnimationsCurl,
    };
    return _SettingsPageHelper.buildSegmentedControl(
      context: context,
      title: l10n.settingsAnimationEffect,
      options: effects,
      selectedValue: provider.pageTurnEffect,
      onChanged: (value) => provider.pageTurnEffect = value,
    );
  }

  static Widget buildSegmentedControl({
    required BuildContext context,
    required String title,
    required Map<String, String> options,
    required String selectedValue,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          children: options.entries.map((entry) {
            final key = entry.key;
            final label = entry.value;
            final isActive = selectedValue == key;
            return InkWell(
              onTap: () => onChanged(key),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isActive
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    width: 2,
                  ),
                  color: isActive
                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                      : Theme.of(context).cardColor,
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isActive
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  static Widget buildToggle(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildFooter(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.bookOpen,
                  size: 24, color: Theme.of(context).primaryColor),
              const SizedBox(width: 12),
              Text(
                l10n.appTitle,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _showCheckUpdateDialog(context, l10n),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Text(
                'v1.0.0 • Designed in Digital Sanctuary',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      decoration: TextDecoration.underline,
                      decorationColor: Theme.of(context).primaryColor,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '© 2024 ANTIGRAVITY. ALL RIGHTS RESERVED.',
            style:
                Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }

  static void _showCheckUpdateDialog(
      BuildContext context, AppLocalizations l10n) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .scaffoldBackgroundColor
                    .withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 24),
                    Text(
                      '正在检查更新...',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    try {
      final versionInfo = await VersionService.checkForUpdates();
      if (!context.mounted) return;

      Navigator.pop(context);

      if (versionInfo.hasUpdate) {
        _showUpdateAvailableDialog(context, versionInfo);
      } else {
        _showNoUpdateDialog(context, versionInfo.currentVersion);
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context);
      _showErrorDialog(context, '检查更新失败: $e');
    }
  }

  static void _showUpdateAvailableDialog(
      BuildContext context, VersionInfo versionInfo) {
    showDialog(
      context: context,
      barrierDismissible: !versionInfo.isForceUpdate, // Cannot dismiss if force update
      builder: (BuildContext context) {
        return PopScope(
          canPop: !versionInfo.isForceUpdate, // Prevent back button on force update
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(LucideIcons.download,
                              size: 28,
                              color: Theme.of(context).primaryColor),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '发现新版本',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                if (versionInfo.isForceUpdate)
                                  Text(
                                    '(强制更新)',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.red.withOpacity(0.7),
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).primaryColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${versionInfo.currentVersion} → ',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              versionInfo.versionName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '更新内容:',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          versionInfo.updateInfo,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (!versionInfo.isForceUpdate)
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  '稍后更新',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _launchUpdate(context, versionInfo.fileUrl);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  '立即更新',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _launchUpdate(context, versionInfo.fileUrl);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              '立即更新',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void _showNoUpdateDialog(BuildContext context, String currentVersion) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .scaffoldBackgroundColor
                    .withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.check,
                      size: 48,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '已是最新版本',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '当前版本: v$currentVersion',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('确定'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .scaffoldBackgroundColor
                    .withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.info,
                      size: 48,
                      color: Colors.red.withOpacity(0.7),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '检查更新失败',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('返回'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> _launchUpdate(
      BuildContext context, String downloadUrl) async {
    try {
      // Show progress dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return _DownloadProgressDialog(downloadUrl: downloadUrl);
        },
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close progress dialog
        _showErrorDialog(context, '启动更新失败: $e');
      }
    }
  }
}

class _DownloadProgressDialog extends StatefulWidget {
  final String downloadUrl;

  const _DownloadProgressDialog({
    super.key,
    required this.downloadUrl,
  });

  @override
  State<_DownloadProgressDialog> createState() => _DownloadProgressDialogState();
}

class _DownloadProgressDialogState extends State<_DownloadProgressDialog> {
  late Dio _dio;
  double _downloadProgress = 0.0;
  bool _isDownloading = true;
  String _statusMessage = '正在下载更新文件...';
  bool _downloadSuccess = false;

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    _startDownload();
  }

  Future<void> _startDownload() async {
    try {
      // Get download directory
      final directory = await getApplicationDocumentsDirectory();
      final downloadPath = '${directory.path}/app_update.apk';

      if (kDebugMode) {
        print('[UpdateDownload] Starting download from: ${widget.downloadUrl}');
        print('[UpdateDownload] Download path: $downloadPath');
      }

      // Download file
      await _dio.download(
        widget.downloadUrl,
        downloadPath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress = received / total;
              _statusMessage = '${((_downloadProgress * 100).toStringAsFixed(1))}%';
            });

            if (kDebugMode) {
              print('[UpdateDownload] Progress: ${_statusMessage}');
            }
          }
        },
      );

      if (!mounted) return;

      setState(() {
        _isDownloading = false;
        _downloadSuccess = true;
        _statusMessage = '下载完成，准备安装...';
      });

      // Wait a moment then open the file for installation
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      // Open the APK file to trigger installation
      final result = await OpenFile.open(downloadPath);
      
      if (kDebugMode) {
        print('[UpdateDownload] OpenFile result: ${result.type}');
      }

      if (result.type == ResultType.done) {
        // Installation dialog opened successfully
        if (mounted) {
          Navigator.pop(context); // Close the progress dialog
          _showInstallationSuccessDialog();
        }
      } else {
        // Failed to open file
        if (mounted) {
          Navigator.pop(context);
          _SettingsPageHelper._showErrorDialog(
            context,
            '无法打开安装文件，请尝试手动安装: $downloadPath',
          );
        }
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isDownloading = false;
        _statusMessage = '下载失败: $e';
      });

      if (kDebugMode) {
        print('[UpdateDownload] Error: $e');
      }

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.pop(context);
        _SettingsPageHelper._showErrorDialog(context, '下载更新失败: $e');
      }
    }
  }

  void _showInstallationSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .scaffoldBackgroundColor
                    .withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.check,
                      size: 48,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '安装已启动',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '请按照系统提示完成安装',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('好的'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context)
                .scaffoldBackgroundColor
                .withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isDownloading)
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LinearProgressIndicator(
                          minHeight: 8,
                          value: _downloadProgress,
                          backgroundColor: Colors.grey.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '正在下载...',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _statusMessage,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                else if (_downloadSuccess)
                  Column(
                    children: [
                      Icon(
                        LucideIcons.check,
                        size: 48,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '下载完成',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '正在准备安装...',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      Icon(
                        LucideIcons.info,
                        size: 48,
                        color: Colors.red.withOpacity(0.7),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '下载失败',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _statusMessage,
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginRegisterDialog extends StatefulWidget {
  final AppProvider provider;
  final AppLocalizations l10n;

  const _LoginRegisterDialog(
      {super.key, required this.provider, required this.l10n});

  @override
  State<_LoginRegisterDialog> createState() => _LoginRegisterDialogState();
}

class _LoginRegisterDialogState extends State<_LoginRegisterDialog> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Increased blur
        child: Container(
          padding: const EdgeInsets.all(30), // Increased padding
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(0.85), // Higher opacity
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.7), // Stronger border
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.1), // Stronger shadow
                blurRadius: 20, // Increased blur
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(LucideIcons.x,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Text(
                  _isLogin
                      ? widget.l10n.authLoginTitle
                      : widget.l10n.authRegisterTitle,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  _isLogin
                      ? widget.l10n.authLoginDesc
                      : widget.l10n.authRegisterDesc,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _usernameController,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    labelText: widget.l10n.authUsernamePlaceholder,
                    labelStyle: Theme.of(context).textTheme.bodyMedium,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none, // Remove default border
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2),
                    ),
                    fillColor: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.4), // More subtle fill
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    labelText: widget.l10n.authPasswordPlaceholder,
                    labelStyle: Theme.of(context).textTheme.bodyMedium,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2),
                    ),
                    fillColor: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.4), // More subtle fill
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      if (_isLogin) {
                        await widget.provider.login(
                            _usernameController.text, _passwordController.text);
                      } else {
                        await widget.provider.register(
                            _usernameController.text, _passwordController.text);
                      }
                      Navigator.of(context).pop();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Colors.transparent, // Make button transparent
                    shadowColor: Colors.transparent, // Remove shadow from default
                  ).copyWith(
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Theme.of(context).primaryColor.withOpacity(0.2);
                        }
                        return null; // Defer to the widget's default.
                      },
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.7)
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(minHeight: 50),
                      child: Text(
                        _isLogin
                            ? widget.l10n.authLoginBtn
                            : widget.l10n.authRegisterBtn,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    foregroundColor: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    _isLogin
                        ? widget.l10n.authNoAccount
                        : widget.l10n.authHasAccount,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}