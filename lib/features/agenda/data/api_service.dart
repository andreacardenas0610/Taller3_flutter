import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // ==========================================
  // ⚙️ CONFIGURACIÓN DE RED
  // ==========================================

  /// Base URL adaptable según la plataforma de ejecución
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000';
    } else {
      return 'http://127.0.0.1:8000';
    }
  }

  /// Encabezados HTTP reutilizables
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  // ==========================================
  // 👤 AUTENTICACIÓN
  // ==========================================

  /// Inicia sesión con correo electrónico y contraseña
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      return {
        'statusCode': response.statusCode,
        'data': jsonDecode(response.body),
      };
    } catch (e) {
      return {
        'statusCode': 500,
        'data': {'detail': 'Error de conexión: $e'},
      };
    }
  }

  /// Registra un nuevo usuario en la plataforma
  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: _headers,
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      return {
        'statusCode': response.statusCode,
        'data': jsonDecode(response.body),
      };
    } catch (e) {
      return {
        'statusCode': 500,
        'data': {'detail': 'Error de conexión: $e'},
      };
    }
  }

  // ==========================================
  // 🧔 PERFIL DE USUARIO
  // ==========================================

  /// Obtiene la información del perfil del usuario según su ID
  static Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ==========================================
  // 📝 CRUD DE TAREAS
  // ==========================================

  /// Obtiene la lista de tareas pertenecientes a un usuario específico
  static Future<List<dynamic>> getTasks(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tasks?user_id=$userId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Crea una nueva tarea asociada a un usuario
  static Future<bool> createTask(
    String title,
    String description,
    String userId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tasks'),
        headers: _headers,
        body: jsonEncode({
          'title': title,
          'description': description,
          'user_id': userId,
          'completed': false,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  /// Alterna el estado (completado / pendiente) de una tarea
  static Future<bool> toggleTaskStatus(String taskId) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/tasks/$taskId/toggle'),
        headers: _headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Elimina una tarea por su ID
  static Future<bool> deleteTask(String taskId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/tasks/$taskId'),
        headers: _headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}