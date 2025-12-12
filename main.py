# app/main.py

from fastapi import FastAPI, Request
from datetime import datetime, timezone
import logging

# Set up basic logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize FastAPI application
app = FastAPI(
    title="SimpleTimeService",
    description="A minimalist service that returns current time and visitor IP.",
    version="1.0.0"
)


@app.get("/", summary="Get current timestamp and visitor IP")
async def get_time_and_ip(request: Request):
    """
    Returns a JSON object containing the current UTC timestamp and the
    IP address of the client making the request.
    """
    # Get the current time in ISO 8601 format (UTC)
    current_time_utc = datetime.now(timezone.utc).isoformat()

    # Attempt to get the visitor's IP address
    # 1. Check for standard proxy headers (e.g., X-Forwarded-For)
    #    Note: This relies on the upstream proxy/load balancer to correctly set these headers.
    visitor_ip = request.headers.get("x-forwarded-for")
    
    # 2. Fallback to the direct client's host (the one that connected to the app, usually the Docker bridge IP or load balancer)
    if not visitor_ip:
        # request.client is a tuple (host, port)
        visitor_ip = request.client.host if request.client else "unknown"

    # Log the successful request
    logger.info(f"Request received from IP: {visitor_ip}. Sending time: {current_time_utc}")

    # Construct the response payload
    response_payload = {
        "timestamp": current_time_utc,
        "ip": visitor_ip,
    }

    # Return the JSON response
    return response_payload

