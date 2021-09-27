import 'dart:async';
import 'dart:io';
import 'package:awesomeweather/WeatherModals/forcast.dart';
import 'package:awesomeweather/WeatherModals/locations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'app_exception.dart';

class WeatherRepo {
  final apiID = '05c84fa95e4c33a7daee07a12d9c3b8e';
  final giolocationbaseURL = 'http://api.openweathermap.org/geo/1.0/direct?q=';
  final baseURL = 'http://api.openweathermap.org/data/2.5/';
  Future<Location> getCurrentLatandLon(String city) async {
    final url = giolocationbaseURL + city + '&limit=1&appid=' + apiID;
    try {
      final response = await http
          .get(
            Uri.parse(url),
          )
          .timeout(Duration(seconds: 5));
      print(response.statusCode);
      final jsonLocation = _processResponse(response);
      print(jsonLocation);
      return Location.fromJson(jsonLocation[0]);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time');
    }
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
    try {
      final response = await http.get(
        Uri.parse(url),
      );
      final jsonWeather = _processResponse(response);
      print(jsonWeather);
      return Forecast.fromJson(jsonWeather);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time');
    }
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        final data = json.decode(response.body);
        return data;
      case 400:
        throw BadRequestException(utf8.decode(response.bodyBytes));
      case 401:
      case 403:
        throw UnAuthorizedException(utf8.decode(response.bodyBytes));
      case 422:
        throw BadRequestException(utf8.decode(response.bodyBytes));
      case 500:
      default:
        throw FetchDataException(
            'Error occured with code : ${response.statusCode}');
    }
  }
}
