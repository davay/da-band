from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/health")
async def health_check():
    return {"status": "healthy", "service": "api"}
