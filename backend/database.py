import os
from motor.motor_asyncio import AsyncIOMotorClient
from dotenv import load_dotenv

load_dotenv()

MONGO_URI = os.getenv("MONGO_URI", "mongodb://localhost:27017")
DB_NAME = os.getenv("DB_NAME", "agenda_db")

client = AsyncIOMotorClient(MONGO_URI)

# Se crea la instancia de la base de datos
db = client[DB_NAME]

# Colecciones para el proyecto
users_collection = db["users"]
tasks_collection = db["tasks"]