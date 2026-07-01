from fastapi import FastAPI
from mangum import Mangum

app = FastAPI()

@app.get("/")
def read_root():
    return {"status": "success", "message": "Hello from Lambda"}

@app.get("/test")
def test_this():
    return {"status": "test works"}


handler = Mangum(app)