from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse
from pydantic import BaseModel
import httpx, asyncio
import pandas as pd
from apscheduler.schedulers.asyncio import AsyncIOScheduler
from apscheduler.triggers.cron import CronTrigger
import datetime

app = FastAPI()
scheduler = AsyncIOScheduler()

file_path = 'words_file.xls'
words = pd.read_excel(file_path)
words_random = words.sample(frac=1).reset_index(drop=True)
word_num = 0

class UserInput(BaseModel):
    user_input: str

def next_word():
    # 여기에 원하는 작업을 구현합니다. 예를 들어:
    if word_num + 1 >= len(word_num):
        word_num = 0
    else:
        word_num += 1
    print(f"{datetime.datetime.now()} : 단어 인덱스 f{word_num}")

@app.on_event("startup")
def schedule_jobs():
    # 매일 오전 8시에 'morning_job' 함수를 실행합니다.
    scheduler.add_job(next_word, CronTrigger(hour=8, minute=0))
    scheduler.start()

@app.get("/fastapi/num")
def check_word_num():
    return {"오늘의 단어 숫자" : word_num}

@app.get("/fastapi/dailyword")
def daily_word():
    word = words_random.iloc[word_num]['inputs']
    response = words_random.iloc[word_num]['response']
    data = {word: response}
    return JSONResponse(status_code=200, content=data)

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
        return JSONResponse(status_code=response.status_code, content=response.json())
