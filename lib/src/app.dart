import 'package:flutter/material.dart';

import 'pages/Book/book_details_view.dart';
import 'pages/Home/home_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';


class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {

    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case BookDetailsView.routeName:
                    return BookDetailsView();
                  case HomeView.routeName:
                  default:
                    return HomeView();
                }
              },
            );
          },
        );
      },
    );
  }
}
