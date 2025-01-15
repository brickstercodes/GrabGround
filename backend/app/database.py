from supabase import create_client, Client
import os
from dotenv import load_dotenv
from typing import List
import logging

load_dotenv()

url = os.getenv("SUPABASE_URL")
key = os.getenv("SUPABASE_ANON_KEY")

if not url or not key:
    raise ValueError("Supabase credentials not found in environment")

# Simple client initialization
supabase = create_client(url, key)

logger = logging.getLogger(__name__)

async def match_turfs(limit: int = 5):
    try:
        # Query turfs table with basic filters
        response = supabase.table('turfs').select(
            'id', 
            'name', 
            'description', 
            'price', 
            'location',
            'amenities'
        ).limit(limit).execute()
        
        if not response.data:
            logger.warning("No turfs found in database")
            return []
            
        logger.info(f"Found {len(response.data)} turfs")
        return response.data
    except Exception as e:
        logger.error(f"Error in match_turfs: {e}")
        return []