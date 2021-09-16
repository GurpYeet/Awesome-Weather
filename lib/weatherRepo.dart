import 'package:awesomeweather/WeatherModals/forcast.dart';
import 'package:awesomeweather/WeatherModals/locations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherRepo {
  final apiID = '05c84fa95e4c33a7daee07a12d9c3b8e';
  final giolocationbaseURL = 'http://api.openweathermap.org/geo/1.0/direct?q=';
  final baseURL = 'http://api.openweathermap.org/data/2.5/';
  Future<Location> getCurrentLatandLon(String city) async {
    final url = giolocationbaseURL + city + '&limit=1&appid=' + apiID;
    final response = await http.get(
      Uri.parse(url),
    );
    if (response.statusCode != 200) throw Exception();
    final jsonLocation = json.decode(response.body);
    print(jsonLocation);
    return Location.fromJson(jsonLocation[0]);
  }

  static Future<List<String>> searchCities(String query) async {
    final cityName = query;
    final geolocationbaseURL =
        'http://api.openweathermap.org/geo/1.0/direct?q=';
    final url = geolocationbaseURL +
        cityName +
        '&limit=3&appid=1f077d605f0216ac404a053d35569e05';
    final response = await http.get(
      Uri.parse(url),
    );
    if (response.statusCode != 200) throw Exception();
    final body = json.decode(response.body);
    print(body);
    return body.map<String>((json) {
      final city = json['name'];
      final country = json['country'];
      return '$city, $country';
    }).toList();
  }

  Future<Forecast> getCurrentForcast(Location location) async {
    final lat = location.lat;
    final long = location.lon;
    final url =
        baseURL + 'onecall?lat=$lat&lon=$long&exclude=minutely&appid=' + apiID;
    final response = await http.get(
      Uri.parse(url),
    );
    if (response.statusCode != 200) throw Exception();
    final jsonWeather = json.decode(response.body);
    print(jsonWeather['timezone']);
    return Forecast.fromJson(jsonWeather);
  }
}
