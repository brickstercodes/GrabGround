from supabase import create_client
import os
from dotenv import load_dotenv

load_dotenv()

supabase = create_client(
    os.getenv("SUPABASE_URL"),
    os.getenv("SUPABASE_KEY")
)

async def match_turfs(embedding: List[float], limit: int = 5):
    response = await supabase.rpc(
        'match_turfs',
        {
            'query_embedding': embedding,
            'match_threshold': 0.7,
            'match_count': limit
        }
    ).execute()
    
    return response.data