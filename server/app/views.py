from django.shortcuts import render

from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from django.utils.datetime_safe import datetime
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.decorators import api_view, permission_classes

from .models import MoistureSensor, Bme280Sensor
from .serializers import Bme280SensorSerializers, MoistureSensorSerializers, DataSerializers


class DataAPIView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        # Serialize data
        moisture = request.data.get("moisture")
        temp = request.data.get("temp")
        pressure = request.data.get("pressure")
        humidity = request.data.get("humidity")

        create_moisture = MoistureSensor.objects.create(moisture=moisture)
        create_bme280 = Bme280Sensor.objects.create(temp=temp, pressure=pressure, humidity=humidity)
        create_moisture_response = create_moisture.save()
        create_bme280_response = create_bme280.save()
        print(create_moisture_response)
        print(create_bme280_response)

        data = {
            "moisture": moisture,
            "temp": temp,
            "pressure": pressure,
            "humidity": humidity,
        }
        return Response(data=data, status=status.HTTP_202_ACCEPTED)

    def get(self, request):
        bme280_all = Bme280Sensor.objects.all().order_by('-date')
        serializer = DataSerializers(bme280_all, many=True)
        return Response(data=serializer.data, status=status.HTTP_202_ACCEPTED)

def thread_view(request):
    return render(request, "main.html", {})




