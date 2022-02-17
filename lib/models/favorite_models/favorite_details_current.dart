class FavoriteDetailsCurrentModel {
  FavoriteDetailsCurrentModel({
    this.data,
  });

  List<Data>? data;

  factory FavoriteDetailsCurrentModel.fromJson(Map<String, dynamic> json) =>
      FavoriteDetailsCurrentModel(
        data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
      );
}

class Data {
  Data({
    this.cityName,
    this.windSpd,
    this.weatherModel,
    this.temp,
  });

  String? cityName;
  var windSpd;
  WeatherModel? weatherModel;
  var temp;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        cityName: json["city_name"],
        windSpd: json["wind_spd"].round(),
        weatherModel: WeatherModel.fromJson(json["weather"]),
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

  String imageAsset() {
    var imageCode = code.toString();
    if (imageCode == "700" ||
        imageCode == "711" ||
        imageCode == "721" ||
        imageCode == "731" ||
        imageCode == "741" ||
        imageCode == "751") {
      return 'assets/images/mist.jpg';
    } else if (imageCode == "801" ||
        imageCode == "802" ||
        imageCode == "803" ||
        imageCode == "804") {
      return 'assets/images/cloud.jpg';
    } else if (imageCode == "600" ||
        imageCode == "601" ||
        imageCode == "602" ||
        imageCode == "610" ||
        imageCode == "611" ||
        imageCode == "612" ||
        imageCode == "621" ||
        imageCode == "622" ||
        imageCode == "623") {
      return 'assets/images/snow.jpg';
    } else if (imageCode == "500" ||
        imageCode == "501" ||
        imageCode == "502" ||
        imageCode == "511" ||
        imageCode == "520" ||
        imageCode == "521" ||
        imageCode == "522") {
      return 'assets/images/rain.jpg';
    } else if (imageCode == "800" && icon.toString() == "c01d") {
      return 'assets/images/cleard.jpg';
    } else if (imageCode == "800" && icon.toString() == "c01n") {
      return 'assets/images/clearn.jpg';
    } else if (imageCode == "300" || imageCode == "301" || imageCode == "302") {
      return 'assets/images/drizzle.jpg';
    } else if (imageCode == "200" ||
        imageCode == "201" ||
        imageCode == "202" ||
        imageCode == "230" ||
        imageCode == "231" ||
        imageCode == "232" ||
        imageCode == "233") {
      return 'assets/images/thunderstorm.jpg';
    } else {
      return '';
    }
  }

  factory WeatherModel.fromJson(Map<String, dynamic> json) => WeatherModel(
        icon: json["icon"],
        code: json["code"],
        description: json["description"],
      );
}
