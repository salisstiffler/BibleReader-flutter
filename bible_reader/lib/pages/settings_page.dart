import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.85),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              // Header
              _buildHeader(context, provider.currentLanguage),
              const SizedBox(height: 40),

              // Language Selection
              _buildGlassmorphismCard(
                context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(
                        context, LucideIcons.globe,
                        provider.currentLanguage == 'en' ? 'Localization' : '语言预设'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildLanguageButton(context, provider, 'zh', '简体',
                            provider.currentLanguage == 'zh' || provider.currentLanguage == 'zh-Hans'),
                        _buildLanguageButton(context, provider, 'zh-hant', '繁體',
                            provider.currentLanguage == 'zh-hant'),
                        _buildLanguageButton(context, provider, 'en', 'English',
                            provider.currentLanguage == 'en'),
                      ],
                    ),
                  ],
                ),
              ),

              // Appearance Section
              _buildGlassmorphismCard(
                context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(
                        context, LucideIcons.sparkles,
                        provider.currentLanguage == 'en' ? 'Visual Style' : '视觉风格'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildThemeButton(context, provider, AppTheme.light,
                            provider.currentLanguage == 'en' ? 'Light' : '明亮', LucideIcons.sun),
                        _buildThemeButton(context, provider, AppTheme.dark,
                            provider.currentLanguage == 'en' ? 'Dark' : '深色', LucideIcons.moon),
                        _buildThemeButton(context, provider, AppTheme.sepia,
                            provider.currentLanguage == 'en' ? 'Sepia' : '舒耳', LucideIcons.treePine),
                      ],
                    ),
                  ],
                ),
              ),

              // Typography & Performance
              _buildGlassmorphismCard(
                context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(
                        context, LucideIcons.activity,
                        provider.currentLanguage == 'en' ? 'Reading Controls' : '阅读及朗读'),
                    const SizedBox(height: 16),

                    // Font Size Selector
                    _buildFontSizeControl(context, provider),
                    const SizedBox(height: 24),

                    // Playback Rate Slider
                    _buildPlaybackRateControl(context, provider),
                  ],
                ),
              ),

              // Toggles
              _buildGlassmorphismCard(
                context,
                child: Column(
                  children: [
                    _buildToggle(
                      context,
                      title: provider.currentLanguage == 'en' ? 'Continuous Reading' : '沉浸式连续播放',
                      subtitle: provider.currentLanguage == 'en'
                          ? 'Auto-play subsequent verses for hands-free study.'
                          : '朗读完当前经文后自动进入下一节，适合闭目灵修。',
                      value: provider.continuousReading,
                      onChanged: (value) => provider.continuousReading = value,
                    ),
                    const SizedBox(height: 20),
                    _buildToggle(
                      context,
                      title: provider.currentLanguage == 'en' ? 'Pause on Chapter Switch' : '切换章节时暂停',
                      subtitle: provider.currentLanguage == 'en'
                          ? 'Automatically pause playback when manually switching chapters.'
                          : '手动切换章节时自动暂停播放，包括点击上/下一章按钮。',
                      value: provider.pauseOnManualSwitch,
                      onChanged: (value) => provider.pauseOnManualSwitch = value,
                    ),
                  ],
                ),
              ),

              // Footer
              _buildFooter(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, String currentLanguage) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.indigo, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(LucideIcons.settings, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 16),
        Text(
          currentLanguage == 'en' ? 'Preferences' : '个性化设置',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          currentLanguage == 'en' ? 'Configure your perfect reading environment' : '打造最适合您的灵修阅读环境',
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGlassmorphismCard(BuildContext context, {required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.5)),
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

  Widget _buildSectionTitle(BuildContext context, IconData icon, String title) {
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

  Widget _buildLanguageButton(BuildContext context, AppProvider provider,
      String langCode, String label, bool isActive) {
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
                  ? const LinearGradient(
                      colors: [Colors.indigo, Colors.blueAccent],
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
                color: isActive ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeButton(BuildContext context, AppProvider provider,
      AppTheme theme, String label, IconData icon) {
    final bool isActive = provider.theme == theme;
    return Expanded(
      child: InkWell(
        onTap: () => provider.theme = theme,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isActive ? Theme.of(context).primaryColor : Theme.of(context).dividerColor,
              width: 2,
            ),
            color: isActive ? Theme.of(context).primaryColor.withOpacity(0.1) : Theme.of(context).cardColor,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isActive ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodySmall?.color,
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFontSizeControl(BuildContext context, AppProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              provider.currentLanguage == 'en' ? 'Typography Size' : '字体缩放',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${provider.fontSize.round()}px',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildIconButton(
                context, LucideIcons.minus, () => provider.fontSize = (provider.fontSize - 1).clamp(12, 32)),
            Expanded(
              child: Slider(
                value: provider.fontSize,
                min: 12,
                max: 32,
                divisions: 20,
                label: provider.fontSize.round().toString(),
                onChanged: (value) => provider.fontSize = value,
                activeColor: Theme.of(context).primaryColor,
                inactiveColor: Theme.of(context).primaryColor.withOpacity(0.3),
              ),
            ),
            _buildIconButton(
                context, LucideIcons.plus, () => provider.fontSize = (provider.fontSize + 1).clamp(12, 32)),
          ],
        ),
      ],
    );
  }

  Widget _buildPlaybackRateControl(BuildContext context, AppProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              provider.currentLanguage == 'en' ? 'Speech Rate' : '朗读速率',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${provider.playbackRate.toStringAsFixed(1)}x',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Slider(
          value: provider.playbackRate,
          min: 0.5,
          max: 2.0,
          divisions: 15,
          label: provider.playbackRate.toStringAsFixed(1),
          onChanged: (value) => provider.playbackRate = value,
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0.5x', style: Theme.of(context).textTheme.bodySmall),
              Text('1.0x (Normal)', style: Theme.of(context).textTheme.bodySmall),
              Text('2.0x', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton(
      BuildContext context, IconData icon, VoidCallback onPressed) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).dividerColor),
        color: Theme.of(context).cardColor,
      ),
      child: IconButton(
        icon: Icon(icon, size: 18),
        onPressed: onPressed,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
    );
  }

  Widget _buildToggle(BuildContext context,
      {required String title,
      required String subtitle,
      required bool value,
      required ValueChanged<bool> onChanged}) {
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
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
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

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.bookOpen, size: 24, color: Theme.of(context).primaryColor),
              const SizedBox(width: 12),
              Text(
                'Holy Read',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                ' Pro',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Text(
              'v 1.2.5 • Designed in Digital Sanctuary',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '© 2024 ANTIGRAVITY. ALL RIGHTS RESERVED.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }
}