"""contains the data model used for the API"""
from pydantic import BaseModel, Field
from datetime import datetime


class Speedtest(BaseModel):
    """A result of the speedtest"""
    download: int = Field(description="Downlink speed in Mbps (Megabits per second)")
    upload: int = Field(description="Uplink speed in Mbps (Megabits per second)")
    ping: int = Field(description="Ping in milliseconds to the speedtest server")


class Measure(BaseModel):
    """A complete measurement performed by the probe"""
    timestamp: datetime = Field(description="ISO 8601 timestamp of when the test was started on the prob")
    speedtest: Speedtest = Field(description="Performance of the speedtest performed")
    ping: dict[str, int | None] = Field(
        description="Performance of pings performed. The result is in milliseconds or null if the ping failed"
    )

    class Config:
        """Example of a measure"""
        schema_extra = {
            "example": {
                "timestamp": "2023-02-15T23:14:13.043318",
                "speedtest": {
                    "download": 712,
                    "upload": 442,
                    "ping": 3.972
                },
                "ping": {
                    "198.41.0.4": 7.09,
                    "199.9.14.201": 17.36,
                    "192.33.4.12": 5.43,
                    "199.7.91.13": 19.49,
                    "192.203.230.10": 5.87,
                    "192.5.5.241": 5.59,
                    "192.112.36.4": None,
                    "198.97.190.53": 17.08,
                    "192.36.148.17": 306.74,
                    "192.58.128.30": 33.29,
                    "193.0.14.129": 11.36,
                    "199.7.83.42": 5.36,
                    "202.12.27.33": 290.19
                }
            }
        }
