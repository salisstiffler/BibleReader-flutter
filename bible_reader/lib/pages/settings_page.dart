import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:ui'; // Import dart:ui for ImageFilter
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../theme.dart';

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
                    LucideIcons.activity, l10n.settingsReadingControls),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _SettingsPageHelper.buildGlassmorphismCard(
                  context,
                  child: Column(
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
                    LucideIcons.audioLines, l10n.settingsReadingControls),
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
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Row(
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
      ),
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
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _SettingsPageHelper.buildThemeButton(context, provider, AppTheme.light,
            l10n.settingsThemeLight, LucideIcons.sun),
        _SettingsPageHelper.buildThemeButton(context, provider, AppTheme.dark,
            l10n.settingsThemeDark, LucideIcons.moon),
        _SettingsPageHelper.buildThemeButton(context, provider, AppTheme.sepia,
            l10n.settingsThemeSepia, LucideIcons.book),
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
    return GestureDetector(
      onTap: () => provider.theme = theme,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: theme
                  .getThemeData(
                    accentColor: provider.accentColor,
                  )
                  .scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isActive
                    ? Theme.of(context).primaryColor
                    : theme
                        .getThemeData(
                          accentColor: provider.accentColor,
                        )
                        .dividerColor,
                width: 3,
              ),
            ),
            child: Icon(icon,
                color: theme
                    .getThemeData(
                      accentColor: provider.accentColor,
                    )
                    .textTheme
                    .bodyLarge
                    ?.color),
          ),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.bodySmall)
        ],
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
          spacing: 10,
          runSpacing: 10,
          children: colors.map((color) {
            final isActive = provider.accentColor == color;
            return InkWell(
              onTap: () => provider.accentColor = color,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Color(int.parse('0xFF${color.substring(1)}')),
                  border: Border.all(
                    color: isActive
                        ? (provider.theme == AppTheme.dark
                            ? Colors.white
                            : Colors.black)
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
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
      'sans': l10n.settingsFontsSans,
      'serif': l10n.settingsFontsSerif,
      'kai': l10n.settingsFontsKai,
      'rounded': l10n.settingsFontsRounded,
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
          Text(
            'v1.0.0 • Designed in Digital Sanctuary',
            style: Theme.of(context).textTheme.bodySmall,
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