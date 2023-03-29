"""main application file"""
from fastapi import FastAPI, Depends
from datetime import datetime

from influxdb_client import Point, WriteApi


from model import Measure
from influx import influx_write

app = FastAPI()


@app.get("/")
def get_index():
    """allows to check if the API answer 200 correctly to the probe"""
    return {
        "title": "opengate-probe API",
        "timestamp": datetime.now().isoformat(),
    }


@app.post("/measure", response_model_exclude_none=False)
def post_measure(measure: Measure, influx: WriteApi = Depends(influx_write)):
    """records a new measurement made by the probe"""
    p = Point("probe_measurement")\
        .time(measure.timestamp)\
        .field("ping", measure.speedtest.ping)\
        .field("type", measure.connection_type)\
        .field("up", measure.speedtest.upload)\
        .field("down", measure.speedtest.download)

    influx.write(bucket="probe", org="opengate", record=p)
    influx.flush()

    return "ok"
