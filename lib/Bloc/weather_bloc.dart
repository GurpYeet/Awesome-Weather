import 'dart:async';
import 'package:awesomeweather/WeatherModals/forcast.dart';
import 'package:awesomeweather/WeatherModals/locations.dart';
import 'package:awesomeweather/app_exception.dart';
// import 'package:awesomeweather/homepage.dart';
import 'package:awesomeweather/weatherRepo.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import './bloc.dart';

class WeatherBloc extends HydratedBloc<ResetWeather, WeatherState> {
  WeatherRepo weatherRepo;
  DateFormat formater = DateFormat('HH');
  WeatherBloc(this.weatherRepo) : super(WeatherInitial());

  @override
  WeatherState fromJson(Map<String, dynamic> json) {
    if (json.isNotEmpty) {
      return WeatherLoaded(
        Forecast.fromJson(json['forecast']),
        Location.fromJson(json['location']),
      );
    } else {
      return WeatherInitial();
    }
  }

  @override
  Map<String, dynamic> toJson(WeatherState state) {
    if (state is WeatherLoaded) {
      return {
        'forecast': state.forecast.toJson(),
        'location': state.location.toJson()
      };
    } else if (state is WeatherError) {
      return {
        'forecast': state.data['forecast'],
        'location': state.data['location'],
      };
    } else {
      return {};
    }
  }

  @override
  Stream<WeatherState> mapEventToState(event) async* {
    yield WeatherLoading();
    try {
      Forecast weatherForecast =
          await weatherRepo.getCurrentForcast(event.location);
      yield WeatherLoaded(weatherForecast, event.location);
    } catch (error) {
      if (error is AppException)
        yield WeatherError(
          error: error.prefix ?? 'Something Went Wrong',
          data: event.predata,
        );
      else
        yield WeatherError(error: 'Something Went Wrong', data: event.predata);
    }
  }
}
