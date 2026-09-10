from pydantic import BaseModel, EmailStr, Field
from typing import Optional
from datetime import datetime

# --- MODELOS DE USUARIO ---
class UserRegister(BaseModel):
    name: str
    email: EmailStr
    password: str

class UserLogin(BaseModel):
    email: EmailStr
    password: str

# --- MODELOS DE TAREAS (AGENDA) ---
class TaskCreate(BaseModel):
    title: str
    description: Optional[str] = ""
    user_id: str  # ID del usuario creador
    completed: Optional[bool] = False

class TaskResponse(TaskCreate):
    id: str
    created_at: datetime