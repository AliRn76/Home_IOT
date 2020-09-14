import asyncio
import json
from django.contrib.auth import get_user_model
from channels.consumer import AsyncConsumer
from channels.db import database_sync_to_async

from .models import Bme280Sensor, MoistureSensor

class MoistureSensorConsumer(AsyncConsumer):
    async def websocket_connect(self, event):
        print("connected", event)
        await self.send({
            "type": "websocket.accept",
        })

        while True:
            moist_obj = await self.last_moisture()
            bme_obj = await self.last_bme280()
            data = {
                "moisture": moist_obj.moisture,
                "temp": bme_obj.temp,
                "pressure": bme_obj.pressure,
                "humidity": bme_obj.humidity,
            }
            await self.send({
                "type": "websocket.send",
                "text": json.dumps(data),
            })
            await asyncio.sleep(1)

    async def websocket_receive(self, event):
        print("receive", event)

    async def websocket_disconnect(self, event):
        print("disconnect", event)

    @database_sync_to_async
    def last_moisture(self):
        return MoistureSensor.objects.all().last()

    @database_sync_to_async
    def last_bme280(self):
        return Bme280Sensor.objects.all().last()
