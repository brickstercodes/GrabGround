from fastapi import FastAPI, WebSocket
from .models import Message, ChatResponse
from .database import match_turfs
import google.generativeai as genai
import os
from dotenv import load_dotenv
import json

load_dotenv()

app = FastAPI()
genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

model = genai.GenerativeModel('gemini-pro')
embedding_model = genai.GenerativeModel('embedding-001')

SYSTEM_PROMPT = """
You are TurfAdvisor, a specialized AI assistant for HomeServicesPro's turf selection system.
Use the provided turf information to make specific recommendations.
Focus on:
1. Location compatibility
2. Price range
3. Usage requirements
4. Maintenance needs
Be concise and specific in recommendations.
"""

async def generate_embedding(text: str) -> list:
    response = await embedding_model.embed_content(
        content=text,
        task_type="retrieval_document"
    )
    return response['embedding']

@app.websocket("/chat")
async def chat_endpoint(websocket: WebSocket):
    await websocket.accept()
    
    while True:
        try:
            # Receive message
            data = await websocket.receive_text()
            message = Message.parse_raw(data)
            
            # Generate embedding
            embedding = await generate_embedding(message.content)
            
            # Find similar turfs
            similar_turfs = await match_turfs(embedding)
            
            # Create context from similar turfs
            turf_context = "\n".join([
                f"Turf Option {i+1}:"
                f"Name: {turf['name']}"
                f"Description: {turf['description']}"
                f"Price: ${turf['price']}"
                f"Location: {turf['location']}"
                for i, turf in enumerate(similar_turfs)
            ])
            
            # Generate response
            prompt = f"{SYSTEM_PROMPT}\n\nContext:\n{turf_context}\n\nUser Question: {message.content}"
            response = await model.generate_content(prompt)
            
            # Send response
            await websocket.send_json(
                ChatResponse(
                    message=response.text,
                    similar_turfs=similar_turfs
                ).dict()
            )
            
        except Exception as e:
            print(f"Error: {e}")
            await websocket.send_json({"error": str(e)})