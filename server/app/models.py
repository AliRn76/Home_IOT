from django.db import models


class Bme280Sensor(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    temp = models.IntegerField(db_column='Temp', blank=True, null=True)  # Field name made lowercase.
    pressure = models.IntegerField(db_column='Pressure', blank=True, null=True)  # Field name made lowercase.
    humidity = models.IntegerField(db_column='Humidity', blank=True, null=True)  # Field name made lowercase.
    date = models.DateTimeField(db_column='Date', blank=True, null=True, auto_now=True)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'BME280Sensor'

    def __str__(self):
        return "Temp:" + str(self.temp) + " - Pressure:" + str(self.pressure) + " - Humidity:" + str(self.humidity)


class MoistureSensor(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    moisture = models.IntegerField(db_column='Moisture', blank=True, null=True)  # Field name made lowercase.
    date = models.DateTimeField(db_column='Date', blank=True, null=True, auto_now=True)  # Field name made lowercase.

    class Meta:
        managed = False
        db_table = 'MoistureSensor'

    def __str__(self):
        return "Moisture:" + str(self.moisture)

    def lastone(self):
        last = self.objects.all()
        return last.last()
