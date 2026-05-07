import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'features/auth/login_page.dart';
import 'core/main_scaffold.dart';

void main() {
  runApp(const AutoMarkApp());
}

class AutoMarkApp extends StatelessWidget {
  const AutoMarkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoMark AI',
      debugShowCheckedModeBanner: false,
      theme: AskualaTheme.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/dashboard': (context) => const MainScaffold(),
      },
    );
  }
}
