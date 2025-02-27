from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "<body style='background-color:blue;'><h1 style='color:white;'>Blue Web Portal</h1></body>"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
