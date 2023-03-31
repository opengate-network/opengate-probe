"""Connection logic and API for using InfluxDB"""
import os

from influxdb_client import InfluxDBClient, WriteApi
from influxdb_client.client.write_api import ASYNCHRONOUS

# client is to be configured using ENV variables, see more at
# https://github.com/influxdata/influxdb-client-python#via-environment-properties
client = InfluxDBClient.from_env_properties()


def influx_write() -> WriteApi:
    """Get the InfluxDB asynchronous write API object"""
    return client.write_api(write_options=ASYNCHRONOUS)
