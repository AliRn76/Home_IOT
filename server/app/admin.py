from django.contrib import admin
from .models import Bme280Sensor, MoistureSensor

admin.site.register(Bme280Sensor)
admin.site.register(MoistureSensor)