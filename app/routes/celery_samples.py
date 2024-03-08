from fastapi import APIRouter
from app.celery_tasks.tasks import add
from fastapi.security import HTTPBearer
from app.middlewares.request_id_injection import request_id_contextvar

celery_sample = APIRouter()
httpBearerScheme = HTTPBearer()

@celery_sample.post("/create-task", tags=["Celery-Sample"])
def create_task():
    print('Request ID:', request_id_contextvar.get())
    response = add.delay(10, 20)
    return {"task_id": response.id}
