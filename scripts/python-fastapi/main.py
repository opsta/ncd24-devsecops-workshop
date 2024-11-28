"""
Import
"""
import json
import logging
import os
import random
import time
from typing import List

import httpx
import uvicorn
from fastapi import Depends, FastAPI, HTTPException, Request, Response
from fastapi.middleware.cors import CORSMiddleware


"""
Environment variables
"""
EXPOSE_PORT = os.environ.get("EXPOSE_PORT", 8000)

TARGET_ONE_SVC = os.environ.get("TARGET_ONE_SVC", f"localhost:{EXPOSE_PORT}")
TARGET_TWO_SVC = os.environ.get("TARGET_TWO_SVC", f"localhost:{EXPOSE_PORT}")

TIME_BOMB = os.environ.get("TIME_BOMB", "false").lower().strip() == "true"


"""
Initial application and FastAPI
"""
logging.basicConfig(level=logging.INFO)

app = FastAPI()

app.add_middleware(
  CORSMiddleware,
  allow_origins=["*"],  # Allow all origins
  allow_credentials=True,
  allow_methods=["*"],  # Allow all methods
  allow_headers=["*"],  # Allow all headers
)


"""
FastAPI routes
"""
@app.get("/")
async def root(request: Request):
  """
  Root endpoint with logging
  """
  logging.info(f"Request headers: {request.headers}")
  logging.debug("Debugging log")
  logging.info("Info log")
  logging.warning("Hey, This is a warning!")
  logging.error("Oops! We have an Error")
  logging.critical("Critical error. Please fix this!")
  return {"Hello": "World"}

@app.get("/io_task")
async def io_task():
  """
  IO task simulation with sleep
  """
  time.sleep(1)
  logging.info("io task")
  return "IO bound task finish!"

@app.get("/cpu_task")
async def cpu_task():
  """
  CPU task simulation with calculation
  """
  for i in range(1000):
    _ = i * i * i
  logging.info("cpu task")
  return "CPU bound task finish!"

@app.get("/random_status")
async def random_status(response: Response):
  """
  Random status code endpoint
  """
  response.status_code = random.choice([200, 200, 300, 400, 500])
  logging.info("random status")
  return {"path": "/random_status"}

@app.get("/random_sleep")
async def random_sleep(response: Response):
  """
  Random sleep time endpoint
  """
  time.sleep(random.randint(0, 5))
  logging.info("random sleep")
  return {"path": "/random_sleep"}

@app.get("/chain")
async def chain(response: Response):
  """
  Chain of requests
  """
  logging.info("Chain Start")
  async with httpx.AsyncClient() as client:
    await client.get(
      f"http://localhost:{EXPOSE_PORT}/",
    )
  async with httpx.AsyncClient() as client:
    await client.get(
      f"http://{TARGET_ONE_SVC}/io_task",
    )
  async with httpx.AsyncClient() as client:
    await client.get(
      f"http://{TARGET_TWO_SVC}/cpu_task",
    )
  logging.info("Chain Finished")
  return {"path": "/chain"}

@app.get("/error")
def error():
  """
  Error endpoint
  """
  logging.critical("Critical error. Please fix this!")
  raise HTTPException(status_code=500, detail="This is an error 500")

@app.get("/error_test")
async def error_test(response: Response):
  logging.error("got error!!!!")
  raise ValueError("value error")

@app.get("/health")
async def root(request: Request):
  """
  Health check
  """
  return {"status": "ok"}


"""
Main
"""
if __name__ == "__main__":
  # No Uvicorn access log since we will manage it
  uvicorn.run(app, host="0.0.0.0", port=EXPOSE_PORT, access_log=False)
