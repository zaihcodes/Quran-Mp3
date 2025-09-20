import 'package:flutter/material.dart';
import 'package:quran_mp3/core/services/routes/app_routes.dart';

class PageEntity {
  final String route;
  final Widget page;
  final dynamic bloc; // Function to create bloc

  const PageEntity({required this.route, required this.page, this.bloc});
}

class AppRouter {
  static List<PageEntity> routes() => [
        PageEntity(
            route: AppRoutes.quranMp3, page: Container()), // Bloc instance
      ];

  // App Routes
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (settings.name != null) {
      final result = routes().where((route) => route.route == settings.name);
      if (result.isNotEmpty) {
        final pageEntity = result.first;
        return MaterialPageRoute(builder: (context) => pageEntity.page);
      }
      return MaterialPageRoute(
          builder: (context) => Container(), settings: settings);
    } else {
      return MaterialPageRoute(
          builder: (context) => Container(), settings: settings);
    }
  }

  // All Blocs
  static List<dynamic> createBlocs(BuildContext context) {
    final blocs = <dynamic>[];
    for (final pageEntity in routes()) {
      blocs.add(pageEntity.bloc(context));
    }
    return blocs;
  }
}
