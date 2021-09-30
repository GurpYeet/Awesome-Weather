import 'dart:ui';
import 'package:awesomeweather/WeatherModals/forcast.dart';
import 'package:flutter/material.dart';

class Details extends StatelessWidget {
  const Details({Key? key, required this.details}) : super(key: key);
  final Forecast details;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.white.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      color: Colors.white.withOpacity(0.3),
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 25),
              child: Text(
                'DETAILS',
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wind Speed',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${details.current.windSpeed}',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Pressure',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      '${details.current.pressure} hpa',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Humidity',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      '${details.current.humidity}%',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      child: Text(
                        'Chance of Rain',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        '${details.current.clouds}%',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
