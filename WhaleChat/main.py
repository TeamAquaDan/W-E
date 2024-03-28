from transformers import AutoTokenizer, AutoModelForCausalLM
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel


app = FastAPI()

# model = AutoModelForCausalLM.from_pretrained('/home/ubuntu/we_model/we_model')
# tokenizer = AutoTokenizer.from_pretrained('/home/ubuntu/we_model/we_model')

class UserInput(BaseModel):
    user_input: str

@app.get("/fastapi/test")
def test():
    return "fastapi 성공"


# @app.post("/fastapi/chatbot")
# def chat(input_data: UserInput):
#     user_input = input_data.user_input
#     if not user_input:
#         raise HTTPException(status_code=400, detail="user_input은 비어 있을 수 없습니다.")

#     template = "당신은 w-e 서비스의 주요기능을 설명하고 금융용어를 쉽게 설명해주는 웨일뱅크의 청소년 선생이야. 주어진 질문에 이해하기 쉽게 설명해. "
#     question = user_input
#     question = template+question
#     # 질문을 토크나이저로 인코딩하여 모델에 입력 가능한 형태로 변환
#     input_ids = tokenizer.encode(question, return_tensors='pt')

#     # 답변 생성
#     output_ids = model.generate(
#         input_ids,
#         do_sample=False,
#         max_length=200,
#         num_beams=5,
#         pad_token_id=tokenizer.eos_token_id,
#         temperature=0.7,
#         # top_k=top_k,
#         top_p=0.9,
#         num_return_sequences=1,
#         no_repeat_ngram_size=2,
#     )

#     # 생성된 답변 디코딩
#     response = tokenizer.decode(output_ids[0], skip_special_tokens=True)
#     return {"response": response}