import 'package:flutter/material.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/agenda/presentation/pages/agenda_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Agenda',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/agenda': (context) => const AgendaListPage(),
      },
    );
  }
}