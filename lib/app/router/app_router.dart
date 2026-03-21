// app_router.dart

import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const HomeScreen(), // Use const constructors
        );
      // Additional cases for other routes
      default:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const UnknownScreen(), // Use const constructors
        );
    }
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')), // Use const constructors
      body: const Center(child: Text('Welcome to Home Screen!')), // Use const constructors
    );
  }
}

class UnknownScreen extends StatelessWidget {
  const UnknownScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('404 Not Found')), // Use const constructors
      body: const Center(child: Text('Page not found!')), // Use const constructors
    );
  }
}