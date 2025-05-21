import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Show only short articles'),
              value: settingsProvider.showShortOnly,
              onChanged: settingsProvider.toggleShortOnly,
            ),
            SwitchListTile(
              title: Text('Show only trending articles'),
              value: settingsProvider.showTrendingOnly,
              onChanged: settingsProvider.toggleTrendingOnly,
            ),
          ],
        ),
      ),
    );
  }
}
