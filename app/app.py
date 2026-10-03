import os
import socket
from flask import Flask, request

app = Flask(__name__)


@app.route("/")
def home():
    return "Hello DevSecOps"


@app.route("/resolve")
def resolve():
    host = request.args.get("host", "localhost")
    try:
        return socket.gethostbyname(host)
    except socket.gaierror:
        return "unknown host", 404


if __name__ == "__main__":
    app.run(host=os.environ.get("APP_HOST", "127.0.0.1"), port=5000, debug=False)
