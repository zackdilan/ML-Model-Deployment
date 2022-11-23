from typing import List, Union
from fastapi import FastAPI
from pydantic import BaseModel
from helpers.zero_shot_text_classifier import ZeroShotTextClassifier


# create our prediction query data model
class Query(BaseModel):
    sequence_to_classify: str
    labels: List[str]


app = FastAPI()


@app.post("/predict")
async def model_prediction(query: Query):
    # query_dict = query.dict()
    return ZeroShotTextClassifier.predict(query.sequence_to_classify, query.labels)


@app.get("/health_check")
async def health_check():
    ZeroShotTextClassifier.load()
    return {"success": True}
