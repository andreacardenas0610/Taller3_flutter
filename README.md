# 📅 Gestor de Agenda API & App

Aplicación móvil y backend para la gestión de tareas personales y agendas, desarrollada como proyecto integrador para el programa de desarrollo móvil.

---

## 🛠️ Tecnologías Utilizadas

* **Backend:** FastAPI (Python), Motor (Async Driver para MongoDB), Pydantic.
* **Base de Datos:** MongoDB / MongoDB Atlas.
* **Frontend:** Flutter (Dart).
* **Control de Versiones:** Git & GitHub.

---

## 👥 División de Trabajo y Roles

El proyecto está estructurado en módulos para facilitar el trabajo colaborativo:

### 👤 Aprendiz A-Dayana Andrea Cárdenas Gómez (Módulo de Autenticación y Usuarios)
* **Rama Git:** `feature/auth-module`
* **Backend:**
  * Endpoint `POST /register`: Registro de nuevos usuarios.
  * Endpoint `POST /login`: Validación de credenciales y retorno de sesión.
  * Endpoint `GET /users/{user_id}`: Consulta de datos del perfil de usuario.
* **Frontend:**
  * `LoginPage`: Formulario de inicio de sesión.
  * `RegisterPage`: Formulario de registro.
  * `ProfilePage`: Vista del perfil con consumo dinámico de datos desde el backend.

### 📝 Aprendiz B-Michael Esteban Rubio Pareja (Módulo de Agenda y CRUD de Tareas)
* **Rama Git:** `feature/agenda-module`
* **Backend:**
  * Endpoint `GET /tasks/user/{user_id}`: Obtención de tareas filtradas por usuario.
  * Endpoint `POST /tasks`: Creación de nuevas tareas.
  * Endpoint `PUT /tasks/{task_id}`: Modificación completa de tareas.
  * Endpoint `PATCH /tasks/{task_id}/toggle`: Cambio de estado (completado/pendiente).
  * Endpoint `DELETE /tasks/{task_id}`: Eliminación de tareas.
* **Frontend:**
  * `AgendaPage`: Vista principal de la agenda.
  * `TaskTile`: Componente visual para cada ítem de tarea.
  * `AddTaskModal`: Formulario modal para registrar o editar tareas.

---

## 🚀 Instrucciones de Configuración e Instalación

### 1. Configuración del Backend (FastAPI)

1. Ve a la carpeta del backend:
   ```bash
   cd backend
