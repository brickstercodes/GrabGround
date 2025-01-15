from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from .models import Message, ChatResponse
from .database import match_turfs
import google.generativeai as genai
import os
from dotenv import load_dotenv
import json
from datetime import datetime
import logging
import asyncio

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

load_dotenv()

app = FastAPI(
    title="GrabGround API",
    description="API for turf booking platform",
    version="1.0.0"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

model = genai.GenerativeModel('gemini-pro')
embedding_model = genai.GenerativeModel('embedding-001')

SYSTEM_PROMPT = """
You are TurfAdvisor, a specialized AI assistant for HomeServicesPro's turf selection system.
You must ONLY recommend turfs from the provided database information.
For each query:
1. Consider the user's location, requirements, and preferences
2. Match them with available turfs in the database
3. Always mention specific turf names, prices, and locations from the database
4. Be concise and specific in recommendations

Available Turfs:
{turf_data}
"""

async def get_turf_data():
    try:
        turfs = await match_turfs(limit=10)  # Get available turfs
        turf_info = []
        for turf in turfs:
            info = (f"Name: {turf['name']}\n"
                   f"Location: {turf['location']}\n"
                   f"Price: ₹{turf['price']}\n"
                   f"Description: {turf['description']}\n")
            turf_info.append(info)
        return "\n".join(turf_info)
    except Exception as e:
        logger.error(f"Error fetching turf data: {e}")
        return "No turf data available"

async def generate_ai_response(message: str, turf_data: str) -> str:
    try:
        # Include available turf data in the prompt
        prompt = f"{SYSTEM_PROMPT.format(turf_data=turf_data)}\n\nUser: {message}\nAssistant:"
        loop = asyncio.get_event_loop()
        response = await loop.run_in_executor(
            None,
            lambda: model.generate_content(prompt)
        )
        return response.text if hasattr(response, 'text') else "I couldn't generate a response."
    except Exception as e:
        logger.error(f"Error generating AI response: {e}")
        return "Sorry, I'm having trouble processing your request right now."

@app.get("/")
async def root():
    return {"message": "Welcome to GrabGround API"}

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

@app.get("/api/turfs/match")
async def get_matching_turfs(embedding: list[float], limit: int = 5):
    matches = await match_turfs(embedding, limit)
    return {"matches": matches}

@app.websocket("/ws/{user_id}")
async def websocket_endpoint(websocket: WebSocket, user_id: str):
    logger.info(f"New WebSocket connection request from user: {user_id}")
    try:
        await websocket.accept()
        logger.info(f"WebSocket connection accepted for user: {user_id}")
        
        # Send immediate connection confirmation
        await websocket.send_json({
            "message": "Connected to chat server",
            "similar_turfs": [],
            "timestamp": datetime.now().isoformat()
        })
        
        # Fetch turf data once when connection starts
        turf_data = await get_turf_data()
        
        while True:
            try:
                data = await websocket.receive_json()
                logger.info(f"Received message from {user_id}: {data}")
                
                if data.get('message') == 'ping':
                    await websocket.send_json({
                        "message": "pong",
                        "similar_turfs": [],
                        "timestamp": datetime.now().isoformat()
                    })
                    continue

                user_message = data.get('message', '')
                logger.info(f"Generating AI response for: {user_message}")
                
                # Generate AI response with turf data
                ai_response = await generate_ai_response(user_message, turf_data)
                logger.info(f"AI response generated: {ai_response}")

                # Find similar turfs based on the message
                similar_turfs = await match_turfs(limit=3)

                # Send response back to client with proper type checking
                response_data = {
                    "message": str(ai_response) if ai_response else "No response generated",
                    "similar_turfs": [
                        {
                            "id": turf.get("id", 0),
                            "name": str(turf.get("name", "")),
                            "description": str(turf.get("description", "")),
                            "price": float(turf.get("price", 0.0)),
                            "location": str(turf.get("location", "")),
                            "amenities": [str(a) for a in turf.get("amenities", [])]
                        }
                        for turf in (similar_turfs or [])
                    ],
                    "timestamp": datetime.now().isoformat()
                }
                await websocket.send_json(response_data)
                
            except WebSocketDisconnect:
                logger.info(f"WebSocket disconnected for user: {user_id}")
                break
            except Exception as e:
                logger.error(f"Error processing message: {e}")
                await websocket.send_json({
                    "message": f"Error: {str(e)}",
                    "similar_turfs": [],
                    "timestamp": datetime.now().isoformat()
                })
    except Exception as e:
        logger.error(f"WebSocket error for user {user_id}: {e}")
    finally:
        logger.info(f"Closing WebSocket connection for user: {user_id}")
        try:
            await websocket.close()
        except:
            pass