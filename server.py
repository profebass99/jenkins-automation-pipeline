from flask import Flask
app = Flask(__name__)
@app.route("/")

def hello():
    return """
        <!DOCTYPE html>
        <html>
            <head>
                <title>My Flask Website</title>
            </head>
            <body>
                <h1>Welcome to my Flask website!</h1>
                <p>This is a simple HTML page served using Flask.</p>
            </body>
        </html>
    """
if __name__ == "__main__":
    app.run(host='0.0.0.0') 
