import datetime
import json
import os
from flask import Flask, request

app = Flask(__name__)

# Get the port from an environment variable (standard practice for containers)
PORT = int(os.environ.get("PORT", 8080))

@app.route('/', methods=['GET'])
def get_time():
    """
    Returns the current timestamp and the visitor's IP address in JSON format.
    """
    # Get the client IP address from the request headers
    # We check for standard load balancer headers first (like X-Forwarded-For)
    # If not present, we fall back to the request's remote address.
    if 'X-Forwarded-For' in request.headers:
        client_ip = request.headers['X-Forwarded-For'].split(',')[0].strip()
    else:
        client_ip = request.remote_addr

    response_data = {
        "timestamp": datetime.datetime.now().isoformat(),
        "ip": client_ip
    }

    # Return pure JSON response
    return json.dumps(response_data), 200, {'Content-Type': 'application/json'}

if __name__ == '__main__':
    # Flask's default run host is 127.0.0.1. We need 0.0.0.0 for container accessibility.
    print(f"Starting SimpleTimeService on port {PORT}...")
    app.run(host='0.0.0.0', port=PORT, debug=False)