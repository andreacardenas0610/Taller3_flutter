import 'package:flutter/material.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/pages/forgot_pass_page.dart';
import 'features/agenda/presentation/pages/agenda_list_page.dart';
import 'features/agenda/presentation/pages/profile_page.dart';
import 'features/agenda/presentation/pages/task_form_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Agenda',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => const LoginPage(),
            );

          case '/register':
            return MaterialPageRoute(
              builder: (context) => const RegisterPage(),
            );

          case '/forgot-password':
            return MaterialPageRoute(
              builder: (context) => const ForgotPassPage(),
            );

          case '/agenda':
            return MaterialPageRoute(
              builder: (context) => const AgendaListPage(),
            );

          case '/profile':
            // Extrae los argumentos pasados mediante Navigator.pushNamed
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            return MaterialPageRoute(
              builder: (context) => ProfilePage(
                userId: args['userId'] ?? '',
                name: args['name'] ?? '',
                email: args['email'] ?? '',
              ),
            );

          case '/new-task':
            return MaterialPageRoute(
              builder: (context) => const TaskFormPage(),
            );

          default:
            return MaterialPageRoute(
              builder: (context) => const LoginPage(),
            );
        }
      },
    );
  }
}