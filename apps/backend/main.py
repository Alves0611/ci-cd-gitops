from fastapi import FastAPI
from fastapi.responses import JSONResponse
import os

app = FastAPI()

GREETING_MESSAGE = os.getenv("GREETING_MESSAGE", "validating")
SECRET_VALUE = os.getenv("MY_SECRET", "default_secret")

@app.get("/")
def root():
    return {"message": GREETING_MESSAGE}

@app.get("/healthz")
def liveness():
    return JSONResponse(status_code=200, content={"status": "alive"})

@app.get("/readyz")
def readiness():
    return JSONResponse(status_code=200, content={"status": "ready"})

@app.get("/config")
def show_config():
    return {
        "GREETING_MESSAGE": GREETING_MESSAGE,
        "MY_SECRET": SECRET_VALUE
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8080)
