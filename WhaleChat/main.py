from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse
from pydantic import BaseModel
import httpx, asyncio

app = FastAPI()


class UserInput(BaseModel):
    user_input: str

@app.get("/fastapi/test")
async def test():
    async with httpx.AsyncClient(timeout=180.0) as client:
        response = await client.post("http://222.107.238.75:8000/gpu/test")
        return response
    return "fastapi 성공"


@app.post("/fastapi/chatbot")
async def chat(input_data: UserInput):
    user_input = input_data.user_input
    gpu_server_url = "http://222.107.238.75:8000/gpu/chatbot"
    
    if not user_input:
        raise HTTPException(status_code=400, detail="질문은 비어 있을 수 없습니다.")

    data = {"user_input": user_input}
    
    # gpu서버로 요청 전송
    async with httpx.AsyncClient(timeout=180.0) as client:
        response = await client.post(gpu_server_url, json=data)
        return JSONResponse(status_code=200, content=response.json())
