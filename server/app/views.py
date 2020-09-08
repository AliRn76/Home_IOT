from rest_framework import status
from rest_framework.response import Response
from django.utils.datetime_safe import datetime
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.decorators import api_view, permission_classes

from .models import MoistureSensor, Bme280Sensor
from .serializers import Bme280SensorSerializers, MoistureSensorSerializers

@api_view(['POST', ])
@permission_classes((AllowAny, ))
def add_data(request):
    # Serialize data
    moisture = request.data.get("Moisture")
    temp = request.data.get("Temp")
    pressure = request.data.get("Pressure")
    humidity = request.data.get("Humidity")
    # serializer = Bme280SensorSerializers(data=request.data)

    create_moisture = MoistureSensor.objects.create(moisture=moisture)
    create_bme280 = Bme280Sensor.objects.create(temp=temp, pressure=pressure, humidity=humidity)
    create_moisture_response = create_moisture.save()
    create_bme280_response = create_bme280.save()
    print(create_moisture_response)
    print(create_bme280_response)


    data = {
        "Moisture": moisture,
        "Temp": temp,
        "Pressure": pressure,
        "Humidity": humidity,
    }
    return Response(data=data, status=status.HTTP_202_ACCEPTED)
    # if serializer.is_valid():
    #     item = serializer.save()
    #     # If Name was null or empty
    #     if item.name is None or item.name == '':
    #         data = {
    #             "response": "name can't be null"
    #         }
    #         return Response(data=data, status=status.HTTP_406_NOT_ACCEPTABLE)
    #     # If number was null
    #     if item.number is None:
    #         item.number = 0
    #     item.save()
    #     # Save the Log
    #     log = Log.objects.create(
    #         text    = "{} تعداد: {} ثبت شد.".format(item.name, item.number),
    #         type    = "add",
    #         date=datetime.now()
    #     )
    #     log_response = log.save()
    #     print("log_response: {}".format(log_response))
    #     data = {
    #         "response": "success",
    #         "name": item.name,
    #         "number": item.number
    #     }
    #     return Response(data=data, status=status.HTTP_200_OK)
    # else:

