import 'package:flutter/material.dart';
import '../../data/api_service.dart';
import 'package:gestor_agenda/features/auth/presentation/pages/login_page.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  final String name;
  final String email;

  const ProfilePage({
    super.key,
    required this.userId,
    this.name = '',
    this.email = '',
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // ==========================================
  // 🟢 ESTADO LOCAL
  // ==========================================

  late String _name;
  late String _email;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _name = widget.name;
    _email = widget.email;
    _loadUserProfile();
  }

  // ==========================================
  // 🔄 OPERACIONES DE DATOS (API)
  // ==========================================

  /// Carga los datos del perfil desde la API usando el userId
  Future<void> _loadUserProfile() async {
    final userData = await ApiService.getUserProfile(widget.userId);

    if (!mounted) return;

    if (userData != null) {
      setState(() {
        _name = userData['name'] ?? userData['username'] ?? _name;
        _email = userData['email'] ?? _email;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  // ==========================================
  // 💬 MODALES Y NAVEGACIÓN
  // ==========================================

  /// Diálogo para confirmar el cierre de sesión
  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Estás seguro de que deseas salir?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);

                // Redirigir al Login limpiando la pila de navegación
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
              child: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================
  // 🎨 INTERFAZ GRÁFICA
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Avatar de Perfil
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.indigo.shade100,
                          child: Text(
                            _name.isNotEmpty ? _name[0].toUpperCase() : 'U',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                        ),
                        const CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.indigo,
                          child: Icon(
                            Icons.person,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nombre y Correo Principal
                  Text(
                    _name.isNotEmpty ? _name : 'Usuario',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _email.isNotEmpty ? _email : 'Sin correo',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  const SizedBox(height: 32),

                  // Tarjeta de Detalles del Perfil
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.badge_outlined,
                            color: Colors.indigo,
                          ),
                          title: const Text('ID de Usuario'),
                          subtitle: Text(
                            widget.userId,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(
                            Icons.email_outlined,
                            color: Colors.indigo,
                          ),
                          title: const Text('Correo electrónico'),
                          subtitle: Text(
                            _email.isNotEmpty ? _email : 'Sin correo',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Botón de Cerrar Sesión
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade50,
                        foregroundColor: Colors.red,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.red.shade200),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _logout(context),
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        'Cerrar Sesión',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}