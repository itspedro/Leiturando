import 'package:Leiturando/repositories/favorites_repository.dart';
import 'package:Leiturando/src/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();
  await settingsController.initHive();
  await settingsController.fetchBooks();
  runApp(
    ChangeNotifierProvider<FavoritesRepository>(
      create: (context) => FavoritesRepository(),
      child: MyApp(settingsController: settingsController),
    ),
  );
}
