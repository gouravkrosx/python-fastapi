import os
import aioredis
import datetime

from app.config.redis_config import get_redis_pool
from fastapi import FastAPI
from fastapi.responses import JSONResponse
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request

MAX_REQUESTS = 10
TIME_WINDOW = 60


class RateLimitMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        client_ip = request.client.host
        now = datetime.datetime.now()

        redis = await get_redis_pool()
        try:
            request_count = await redis.get(client_ip)
            request_count = int(request_count) if request_count else 0

            if request_count >= MAX_REQUESTS:
                ttl = await redis.ttl(client_ip)
                detail = {"error": "Too Many Requests", "message": f"Rate limit exceeded. Try again in {ttl} seconds."}
                return JSONResponse(status_code=429, content=detail)

            pipe = redis.pipeline()
            pipe.incr(client_ip)
            pipe.expire(client_ip, TIME_WINDOW)
            await pipe.execute()
        finally:
            pass

        response = await call_next(request)
        return response
