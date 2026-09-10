import 'package:flutter/material.dart';
import '../../data/api_service.dart';
import 'profile_page.dart';

class AgendaPage extends StatefulWidget {
  final String userId;
  final String name;
  final String email;

  const AgendaPage({
    super.key,
    required this.userId,
    this.name = 'Usuario',
    this.email = 'correo@ejemplo.com',
  });

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  // ==========================================
  // 🟢 ESTADO LOCAL
  // ==========================================

  List<dynamic> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // ==========================================
  // 🔄 OPERACIONES DE TAREAS (API)
  // ==========================================

  /// Carga la lista de tareas del usuario desde el backend
  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    final tasks = await ApiService.getTasks(widget.userId);

    if (!mounted) return;

    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
  }

  /// Alterna el estado (completado/pendiente) de una tarea
  Future<void> _toggleTaskStatus(String taskId) async {
    final success = await ApiService.toggleTaskStatus(taskId);
    if (success) {
      _loadTasks();
    }
  }

  /// Elimina una tarea mediante su ID
  Future<void> _deleteTask(String taskId) async {
    final success = await ApiService.deleteTask(taskId);
    if (success) {
      _loadTasks();
    }
  }

  // ==========================================
  // 💬 MODALES Y NAVEGACIÓN
  // ==========================================

  /// Muestra el modal desplegable para registrar una nueva tarea
  void _showAddTaskModal() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nueva Tarea'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final description = descriptionController.text.trim();

              if (title.isNotEmpty) {
                final success = await ApiService.createTask(
                  title,
                  description,
                  widget.userId,
                );

                if (!mounted) return;
                Navigator.pop(dialogContext);

                if (success) {
                  _loadTasks();
                }
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  /// Navega hacia la vista del perfil de usuario
  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          userId: widget.userId,
          name: widget.name,
          email: widget.email,
        ),
      ),
    );
  }

  // ==========================================
  // 🎨 INTERFAZ GRÁFICA
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Agenda'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 28),
            tooltip: 'Perfil',
            onPressed: _navigateToProfile,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Recargar',
            onPressed: _loadTasks,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? const Center(child: Text('No hay tareas registradas.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    final taskId = task['id'] ?? task['_id'] ?? '';
                    final isCompleted = task['completed'] == true;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      child: ListTile(
                        leading: IconButton(
                          icon: Icon(
                            isCompleted
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: isCompleted ? Colors.green : Colors.grey,
                          ),
                          onPressed: () => _toggleTaskStatus(taskId),
                        ),
                        title: Text(
                          task['title'] ?? '',
                          style: TextStyle(
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        subtitle: Text(task['description'] ?? ''),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () => _deleteTask(taskId),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskModal,
        icon: const Icon(Icons.add),
        label: const Text('Nueva Tarea'),
      ),
    );
  }
}