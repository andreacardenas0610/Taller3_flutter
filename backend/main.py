from fastapi import FastAPI, HTTPException, status, Query
from fastapi.middleware.cors import CORSMiddleware
from motor.motor_asyncio import AsyncIOMotorClient
from bson import ObjectId
from dotenv import load_dotenv
import os
from datetime import datetime
from typing import Optional

from models import UserRegister, UserLogin, TaskCreate

load_dotenv()

app = FastAPI(title="Gestor de Agenda API")

# Permitir conexiones desde Flutter
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

MONGO_URI = os.getenv("MONGO_URI")
DB_NAME = os.getenv("DB_NAME", "agenda_db")

client = AsyncIOMotorClient(MONGO_URI)
db = client[DB_NAME]

@app.get("/test-db")
async def test_db():
    try:
        collections = await db.list_collection_names()
        return {"status": "ok", "message": "Conexión a MongoDB exitosa 🚀", "collections": collections}
    except Exception as e:
        return {"status": "error", "message": str(e)}

# ==========================================
# 👤 ENDPOINTS DE AUTENTICACIÓN (APRENDIZ A)
# ==========================================

@app.post("/register", status_code=status.HTTP_201_CREATED)
async def register_user(user: UserRegister):
    existing_user = await db["users"].find_one({"email": user.email})
    if existing_user:
        raise HTTPException(status_code=400, detail="El correo ya está registrado")
    
    user_dict = user.model_dump()
    user_dict["created_at"] = datetime.utcnow()
    
    result = await db["users"].insert_one(user_dict)
    return {"message": "Usuario registrado con éxito", "id": str(result.inserted_id)}

@app.post("/login")
async def login_user(credentials: UserLogin):
    user = await db["users"].find_one({"email": credentials.email})
    
    if not user or user["password"] != credentials.password:
        raise HTTPException(status_code=401, detail="Credenciales incorrectas")
    
    return {
        "message": "Inicio de sesión exitoso",
        "user": {
            "id": str(user["_id"]),
            "name": user["name"],
            "email": user["email"]
        }
    }

# OBTENER DATOS DE UN USUARIO POR ID (Requerido para ProfilePage)
@app.get("/users/{user_id}")
async def get_user_profile(user_id: str):
    if not ObjectId.is_valid(user_id):
        raise HTTPException(status_code=400, detail="ID de usuario no válido")
        
    user = await db["users"].find_one({"_id": ObjectId(user_id)})
    if not user:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")
        
    return {
        "id": str(user["_id"]),
        "name": user.get("name", "Usuario"),
        "email": user.get("email", "")
    }

# ==========================================
# 📝 ENDPOINTS DE TAREAS / CRUD (APRENDIZ B)
# ==========================================

@app.get("/tasks")
async def get_tasks(user_id: Optional[str] = Query(None)):
    """
    Obtiene las tareas. Si se pasa user_id por query parameter,
    filtra únicamente las tareas pertenecientes a ese usuario.
    """
    query = {}
    if user_id:
        query["user_id"] = user_id

    tasks = []
    cursor = db["tasks"].find(query)
    async for doc in cursor:
        tasks.append({
            "id": str(doc["_id"]),
            "title": doc.get("title", ""),
            "description": doc.get("description", ""),
            "completed": doc.get("completed", False),
            "user_id": doc.get("user_id", ""),
            "created_at": doc.get("created_at")
        })
    return tasks

@app.get("/tasks/user/{user_id}")
async def get_tasks_by_user(user_id: str):
    tasks = []
    cursor = db["tasks"].find({"user_id": user_id})
    async for doc in cursor:
        tasks.append({
            "id": str(doc["_id"]),
            "title": doc.get("title", ""),
            "description": doc.get("description", ""),
            "completed": doc.get("completed", False),
            "user_id": doc.get("user_id", ""),
            "created_at": doc.get("created_at")
        })
    return tasks

@app.post("/tasks", status_code=status.HTTP_201_CREATED)
async def create_task(task: TaskCreate):
    task_dict = task.model_dump()
    task_dict["created_at"] = datetime.utcnow()
    
    if "completed" not in task_dict:
        task_dict["completed"] = False
        
    result = await db["tasks"].insert_one(task_dict)
    return {"message": "Tarea creada con éxito", "id": str(result.inserted_id)}

@app.put("/tasks/{task_id}")
async def update_task(task_id: str, task: TaskCreate):
    if not ObjectId.is_valid(task_id):
        raise HTTPException(status_code=400, detail="ID no válido")
        
    result = await db["tasks"].update_one(
        {"_id": ObjectId(task_id)},
        {"$set": task.model_dump()}
    )
    
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Tarea no encontrada")
        
    return {"message": "Tarea actualizada correctamente"}

@app.patch("/tasks/{task_id}/toggle")
async def toggle_task_status(task_id: str):
    if not ObjectId.is_valid(task_id):
        raise HTTPException(status_code=400, detail="ID no válido")

    task = await db["tasks"].find_one({"_id": ObjectId(task_id)})
    if not task:
        raise HTTPException(status_code=404, detail="Tarea no encontrada")

    new_status = not task.get("completed", False)
    await db["tasks"].update_one(
        {"_id": ObjectId(task_id)},
        {"$set": {"completed": new_status}}
    )

    return {"message": "Estado actualizado", "completed": new_status}

@app.delete("/tasks/{task_id}")
async def delete_task(task_id: str):
    if not ObjectId.is_valid(task_id):
        raise HTTPException(status_code=400, detail="ID no válido")
        
    result = await db["tasks"].delete_one({"_id": ObjectId(task_id)})
    
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Tarea no encontrada")
        
    return {"message": "Tarea eliminada correctamente"}