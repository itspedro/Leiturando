import 'package:flutter/material.dart';

import 'settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Tema'),
          const SizedBox(height: 8),
          DropdownButton<ThemeMode>(
            value: controller.themeMode,
            onChanged: controller.updateThemeMode,
            items: const [
              DropdownMenuItem(
                value: ThemeMode.system,
                child: Text('Sistema'),
              ),
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text('Claro'),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text('Escuro'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
