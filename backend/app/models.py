from pydantic import BaseModel
from typing import List, Optional

class Message(BaseModel):
    content: str
    user_id: str
    
class TurfMatch(BaseModel):
    id: int
    name: str
    description: str
    price: float
    location: str
    similarity: float

class ChatResponse(BaseModel):
    message: str
    similar_turfs: List[TurfMatch]