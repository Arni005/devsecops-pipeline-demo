import subprocess
from flask import Flask, request

app = Flask(__name__)

@app.route("/")
def home():
    return "Hello DevSecOps"

@app.route("/ping")
def ping():
    host = request.args.get("host", "localhost")
    # INTENTIONAL FLAW: command injection (shell=True with user input)
    out = subprocess.check_output(f"ping -c 1 {host}", shell=True)
    return out

if __name__ == "__main__":
    # INTENTIONAL FLAW: debug on, binds to all interfaces
    app.run(host="0.0.0.0", debug=True)