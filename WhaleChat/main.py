from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse
from pydantic import BaseModel
import httpx, asyncio

app = FastAPI()


class UserInput(BaseModel):
    user_input: str

@app.get("/fastapi/test")
def test():
    return "fastapi 성공"


@app.post("/fastapi/chatbot")
async def chat(input_data: UserInput):
    user_input = input_data.user_input
    gpu_server_url = "http://70.12.130.131:8001/gpu/chatbot"

    template = "이 시스템은 금융과 관련된 용어를 설명하는 시스템입니다. 금용용어을 어려워하는 어린이들을 위해 금융 용어들을 쉽게 설명해야합니다.그리고 we가 제공하는 서비스에 대해 명확하게 설명해야합니다. "
    
    if not user_input:
        raise HTTPException(status_code=400, detail="질문은 비어 있을 수 없습니다.")

    data = {"user_input": template + user_input}
    
    # gpu서버로 요청 전송
    async with httpx.AsyncClient(timeout=60.0) as client:
        response = await client.post(gpu_server_url, data=data)
    return JSONResponse(status_code=200, content=response.json())
