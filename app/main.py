from fastapi import FastAPI
from fastapi.responses import HTMLResponse
from mangum import Mangum

app = FastAPI()

@app.get("/", response_class=HTMLResponse)
def read_root():
    html_content = """
    <!DOCTYPE html>
    <html lang="pl">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>AWS</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-900 text-gray-100 flex items-center justify-center min-h-screen font-sans">
        
        <div class="bg-gray-800 p-10 rounded-2xl shadow-2xl border border-gray-700 max-w-lg text-center transform transition-all hover:scale-105">
            <div class="text-6xl mb-6">YO</div>
            <h1 class="text-4xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-cyan-400 to-purple-500 mb-4">
                ITS WORKING
            </h1>
            <p class="text-gray-400 text-lg mb-8 leading-relaxed">
            GIT OPS
            </p>
            
            <div class="space-y-4">
                <button onclick="document.getElementById('secret').classList.remove('hidden')" 
                        class="w-full bg-cyan-600 hover:bg-cyan-500 text-white font-bold py-3 px-6 rounded-xl transition duration-300">
                    123
                </button>
                <p id="secret" class="hidden text-green-400 font-mono mt-4 p-4 bg-gray-900 rounded-lg border border-green-800">
                    secret
                </p>
            </div>
        </div>

    </body>
    </html>
    """
    return HTMLResponse(content=html_content, status_code=200)

handler = Mangum(app)