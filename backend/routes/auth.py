from fastapi import APIRouter

# Instancia explícita con el nombre 'router'
router = APIRouter(
    prefix="/auth",
    tags=["Auth"]
)

@router.get("/status")
async def auth_status():
    return {"message": "Módulo de autenticación activo"}