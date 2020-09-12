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
        await asyncio.sleep(1)
        moist_obj = await self.get_last()
        print(moist_obj)
        await self.send({
            "type": "websocket.send",
            # "text": "Hello World",
            "text": str(moist_obj.moisture),
        })

    async def websocket_receive(self, event):
        print("receive", event)

    async def websocket_disconnect(self, event):
        print("disconnect", event)

    @database_sync_to_async
    def get_last(self):
        return MoistureSensor.objects.all().last()