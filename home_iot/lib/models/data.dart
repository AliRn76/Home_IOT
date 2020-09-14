class Data{
  int moisture;
  int temp;
  int pressure;
  int humidity;

  Data(
      this.moisture,
      this.temp,
      this.pressure,
      this.humidity,
      );

  /// baraye json estefade mishe --> harf avaleshon kochike
  Data.fromJson(Map<String, dynamic> json){
    moisture = json['moisture'];
    temp = json['temp'];
    pressure = json['pressure'];
    humidity = json['humidity'];
  }

  Data.fromMap(Map<String, dynamic> map){
    moisture = map['moisture'];
    temp = map['temp'];
    pressure = map['pressure'];
    humidity = map['humidity'];
  }

  /// convert to json baraye send e request
  Map<String, dynamic> toJson() {
    var map = Map<String, dynamic>();
    map['moisture'] = moisture;
    map['temp'] = temp;
    map['pressure'] = pressure;
    map['humidity'] = humidity;
    return map;
  }

/// toMap lazem nadarim chon moghe insert to db , done done mizanim
}