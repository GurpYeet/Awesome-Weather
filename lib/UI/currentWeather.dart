import 'package:awesomeweather/WeatherModals/forcast.dart';
import 'package:awesomeweather/WeatherModals/locations.dart';
import 'package:flutter/material.dart';
import 'weatherconverter.dart';

class CurrentWeather extends StatelessWidget {
  const CurrentWeather(
      {Key? key, required this.forecast, required this.location})
      : super(key: key);
  final Forecast forecast;
  final Location location;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            location.name,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 5),
          Text(
            getDate(timestamp: forecast.current.dt, format: 'MMMMEEEEd'),
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w300,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30, bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  converter(forecast.current.temp),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 80,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  minmaxtem(
                      forecast.daily[0].temp.min, forecast.daily[0].temp.max),
                  style: TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.w300),
                ),
                VerticalDivider(
                  thickness: 1,
                  width: 50,
                  color: Colors.white60,
                ),
                Text(
                  converter(forecast.current.feelsLike),
                  style: TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.w300),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30, bottom: 30),
            child: Text(
              forecast.current.weather.elementAt(0).description.toUpperCase(),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
            ),
          )
        ],
      ),
    );
  }
}
