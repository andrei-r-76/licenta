import os
from flask import Flask
app = Flask(__name__)

@app.route("/")
def main():
    return """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(to bottom, #000f00 0%, #002200 40%, #003d00 70%, #046102 100%);
            font-family: sans-serif;
        }

        .card {
            text-align: center;
            padding: 3rem 5rem;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 16px;
            backdrop-filter: blur(10px);
        }

        h1 {
            font-size: 3rem;
            font-weight: 300;
            color: #ffffff;
            letter-spacing: 0.05em;
        }

        p {
            margin-top: 0.75rem;
            font-size: 0.95rem;
            color: rgba(255, 255, 255, 0.4);
            letter-spacing: 0.1em;
            text-transform: uppercase;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>Salut!</h1>
        <p>Site pentru testarea pipeline-ului</p>
    </div>
</body>
</html>
"""

