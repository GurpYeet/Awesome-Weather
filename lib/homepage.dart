import 'package:awesomeweather/Bloc/weather_bloc.dart';
import 'package:awesomeweather/Bloc/weather_state.dart';
import 'package:awesomeweather/UI/Details.dart';
import 'package:awesomeweather/UI/currentWeather.dart';
import 'package:awesomeweather/UI/dailyForcast.dart';
import 'package:awesomeweather/UI/hourlyForcast.dart';
import 'package:awesomeweather/UI/search0.2.dart';
import 'package:awesomeweather/UI/weather_viewer.dart';
import 'package:awesomeweather/WeatherModals/forcast.dart';
import 'package:awesomeweather/WeatherModals/locations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'Bloc/weather_event.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<WeatherBloc, WeatherState>(
        listener: (context, state) {
          if (state is WeatherError)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                duration: Duration(seconds: 2),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                padding: EdgeInsets.all(15),
              ),
            );
        },
        builder: (context, state) {
          if (state is WeatherInitial) {
            return WeatherSearch();
          } else if (state is WeatherLoading) {
            return Loading();
          } else if (state is WeatherLoaded) {
            return Awesome(forecast: state.forecast, location: state.location);
          } else if (state is WeatherError) {
            if (state.data.isNotEmpty &&
                (state.data['forecast'] != null) &&
                (state.data['location'] != null))
              return Awesome(
                forecast: state.data['forecast'],
                location: state.data['location'],
                haserror: true,
                error: state.error,
              );
            return WeatherSearch();
          } else {
            return WeatherSearch();
          }
        },
      ),
    );
  }
}

class WeatherSearch extends StatelessWidget {
  WeatherSearch({Key? key}) : super(key: key);
  final TextEditingController text = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('Assets/images/weather.gif'),
              fit: BoxFit.cover)),
      child: Column(children: [
        Container(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SearchPage(forecast: null, location: null),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Search your city",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 40,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
              // SizedBox(height: MediaQuery.of(context).size.height * 0.56),
              // TextButton.icon(
              //   ,
              //   icon: Icon(
              //     Icons.search,
              //     size: 50,
              //     color: Colors.white,
              //   ),
              //   label: Text(
              //     'Search',
              //     style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 30,
              //         fontWeight: FontWeight.bold),
              //   ),
              // ),
              // TextField(
              //   textAlign: TextAlign.center,
              //   cursorColor: Colors.cyanAccent,
              //   cursorRadius: Radius.circular(5),
              //   cursorWidth: 4,
              //   style:
              //       TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              //   controller: text,
              //   cursorHeight: 25,
              //   onSubmitted: (text) {
              //     context.read<WeatherBloc>().add(
              //           GetWeather(city: text, predata: {}),
              //         );
              //   },
              //   decoration: InputDecoration(
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: BorderSide(color: Colors.white),
              //       borderRadius: BorderRadius.circular(30),
              //     ),
              //     enabledBorder: OutlineInputBorder(
              //       borderSide: BorderSide(color: Colors.white),
              //       borderRadius: BorderRadius.circular(30),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ]),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class Awesome extends StatelessWidget {
  Awesome(
      {Key? key,
      required this.forecast,
      required this.location,
      this.haserror = false,
      this.error = ''})
      : super(key: key);
  final bool haserror;
  final String error;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final Forecast forecast;
  final Location location;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WeatherBg(
          weatherType: WeatherViewe.weatherType(forecast.hourly[0].weather[0]),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        Column(
          children: [
            // if (haserror)

            Container(
              child: AppBar(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50))),
                elevation: 0,
                title: Text('Awesome Weather'),
                backgroundColor: Colors.transparent,
                actions: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: IconButton(
                      focusColor: Colors.transparent,
                      splashColor: Colors.blue[200],
                      hoverColor: Colors.transparent,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SearchPage(
                                  location: location,
                                  forecast: forecast,
                                )));
                      },
                      icon: Icon(Icons.search_rounded),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                onRefresh: () {
                  context.read<WeatherBloc>().add(ResetWeather(location));
                },
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  padding:
                      EdgeInsets.only(left: 20, top: 30, right: 20, bottom: 50),
                  children: [
                    CurrentWeather(
                      forecast: forecast,
                      location: location,
                    ),
                    Divider(
                      color: Colors.white60,
                      height: 10,
                      thickness: 1,
                    ),
                    HourlyForecast(hourly: forecast.hourly),
                    Divider(
                      color: Colors.white60,
                      height: 50,
                      thickness: 1,
                    ),
                    DailyForecast(daily: forecast.daily),
                    Divider(
                      color: Colors.white60,
                      height: 50,
                      thickness: 1,
                    ),
                    Details(details: forecast)
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Open Weather Map',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Updated 20/07 8:30 pm',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    IconButton(
                      color: Colors.white,
                      onPressed: () => context
                          .read<WeatherBloc>()
                          .add(ResetWeather(location)),
                      icon: Icon(Icons.refresh),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
