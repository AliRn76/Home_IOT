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

class DataSerializers(serializers.ModelSerializer):
    moisture = serializers.SerializerMethodField('get_moisture')
    class Meta:
        model = Bme280Sensor
        fields = ['moisture', 'temp', 'pressure', 'humidity', 'date']

    def get_moisture(self, obj):
        try:
            object = MoistureSensor.objects.filter(date=obj.date).first()
            moisture = object.moisture
        except:
            moisture = None

        return moisture

