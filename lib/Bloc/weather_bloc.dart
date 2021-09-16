import 'dart:async';
import 'package:awesomeweather/WeatherModals/forcast.dart';
import 'package:awesomeweather/WeatherModals/locations.dart';
import 'package:awesomeweather/weatherRepo.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import './bloc.dart';

class WeatherBloc extends HydratedBloc<WeatherEvent, WeatherState> {
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
    } else {
      return {};
    }
  }

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is GetWeather) {
      yield WeatherLoading();
      try {
        Location location = await weatherRepo.getCurrentLatandLon(event.city);
        Forecast weatherForecast =
            await weatherRepo.getCurrentForcast(location);
        yield WeatherLoaded(weatherForecast, location);
      } catch (error) {
        print(error);
        yield WeatherError('Opps Something Went Wrong');
      }
    } else if (event is GotoInitial) {
      yield WeatherInitial();
    } else if (event is ResetWeather) {
      yield WeatherLoading();
      // Location location = await weatherRepo.getCurrentLatandLon(event.city);
      Forecast weatherForecast =
          await weatherRepo.getCurrentForcast(event.location);
      yield WeatherLoaded(weatherForecast, event.location);
    }
  }
}
