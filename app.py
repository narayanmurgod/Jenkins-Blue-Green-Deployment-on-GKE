from flask import Flask
app = Flask(__name__)

@app.route('/')
def blue_deployment():
    return '''
    <html>
      <body style="background-color: blue; color: white;">
        <h1>Blue Deployment</h1>
        <p>Version 1.0</p>
      </body>
    </html>
    '''

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)