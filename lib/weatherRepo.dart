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
  Future<List<Location>> getCities(String city) async {
    final url = giolocationbaseURL + city + '&limit=3&appid=' + apiID;
    try {
      final response = await http
          .get(
            Uri.parse(url),
          )
          .timeout(Duration(seconds: 5));
      print(response.statusCode);
      final jsonLocation = _processResponse(response);
      return List<Location>.from(jsonLocation.map((x) => Location.fromJson(x)));
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time');
    }
  }

  Future<Forecast> getCurrentForcast(Location location) async {
    final lat = location.lat;
    final long = location.lon;
    final url =
        baseURL + 'onecall?lat=$lat&lon=$long&exclude=minutely&appid=' + apiID;
    try {
      final response = await http
          .get(
            Uri.parse(url),
          )
          .timeout(Duration(seconds: 5));
      final jsonWeather = _processResponse(response);
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
        var data = json.decode(response.body);
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
