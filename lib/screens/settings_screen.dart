import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const _SectionHeader(title: 'Account'),
          _SettingsTile(
            title: 'Notifications',
            subtitle: 'Manage notification preferences',
            icon: Icons.notifications_outlined,
            onTap: () {
              // Handle notifications settings
            },
          ),
          _SettingsTile(
            title: 'Privacy',
            subtitle: 'Control your privacy settings',
            icon: Icons.privacy_tip_outlined,
            onTap: () {
              // Handle privacy settings
            },
          ),
          const _SectionHeader(title: 'App Settings'),
          _SettingsTile(
            title: 'Language',
            subtitle: 'English',
            icon: Icons.language,
            onTap: () {
              // Handle language selection
            },
          ),
          _ThemeSettingsTile(
            currentTheme: themeProvider.themeMode,
            onThemeChanged: (ThemeMode mode) {
              themeProvider.setThemeMode(mode);
            },
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _ThemeSettingsTile extends StatelessWidget {
  final ThemeMode currentTheme;
  final Function(ThemeMode) onThemeChanged;

  const _ThemeSettingsTile({
    required this.currentTheme,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.dark_mode_outlined),
      title: const Text('Theme'),
      trailing: DropdownButton<ThemeMode>(
        value: currentTheme,
        onChanged: (ThemeMode? newMode) {
          if (newMode != null) {
            onThemeChanged(newMode);
          }
        },
        items: const [
          DropdownMenuItem(
            value: ThemeMode.system,
            child: Text('System'),
          ),
          DropdownMenuItem(
            value: ThemeMode.light,
            child: Text('Light'),
          ),
          DropdownMenuItem(
            value: ThemeMode.dark,
            child: Text('Dark'),
          ),
        ],
      ),
    );
  }
}
