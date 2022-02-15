class LocForecastWeatherModel {
  LocForecastWeatherModel({
    required this.data,
  });

  List<Data> data;

  factory LocForecastWeatherModel.fromJson(Map<String, dynamic> json) => LocForecastWeatherModel(
        data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
      );
}

class Data {
  Data({
    this.dateTime,
    this.weatherModel,
    this.minTemp,
    this.maxTemp,
    this.temp,
  });

  DateTime? dateTime;
  WeatherModel? weatherModel;
  var minTemp;
  var maxTemp;
  var temp;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        dateTime: DateTime.parse(json["datetime"]),
        weatherModel: WeatherModel.fromJson(json["weather"]),
        minTemp: json["min_temp"].round() - 2,
        maxTemp: json["max_temp"].round() + 2,
        temp: json["temp"].round(),
      );
}

class WeatherModel {
  WeatherModel({
    this.icon,
    this.code,
    this.description,
  });

  String? icon;
  int? code;
  String? description;

  factory WeatherModel.fromJson(Map<String, dynamic> json) => WeatherModel(
        icon: json["icon"],
        code: json["code"],
        description: json["description"],
      );
}
