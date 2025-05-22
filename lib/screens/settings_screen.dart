import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth < 600 ? 16.0 : 32.0, vertical: 20.0),
        child: ListView(
          children: [
            SwitchListTile(
              title: const Text('Show only short articles'),
              value: settingsProvider.showShortOnly,
              onChanged: (val) => settingsProvider.toggleShortOnly(val),
            ),
            SwitchListTile(
              title: const Text('Show only trending articles'),
              value: settingsProvider.showTrendingOnly,
              onChanged: (val) => settingsProvider.toggleTrendingOnly(val),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: settingsProvider.isDarkMode,
              onChanged: (val) => settingsProvider.toggleDarkMode(val),
              secondary: Icon(
                settingsProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
            ),
            // Add more settings here as needed...
          ],
        ),
      ),
    );
  }
}