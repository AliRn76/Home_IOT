from rest_framework import serializers
from app.models import Bme280Sensor, MoistureSensor


class Bme280SensorSerializers(serializers.ModelSerializer):
    class Meta:
        model   = Bme280Sensor
        fields  = "__all__"


class MoistureSensorSerializers(serializers.ModelSerializer):
    class Meta:
        model   = MoistureSensor
        fields  = "__all__"
