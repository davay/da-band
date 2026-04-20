from fastapi import FastAPI

# Although Caddy strips the /da-band prefix before forwarding requests,
# root_path is still needed so the OpenAPI docs generate correct public URLs.
app = FastAPI(root_path="/da-band")


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/health")
async def health_check():
    return {"status": "healthy", "service": "api"}
