import 'package:awesomeweather/WeatherModals/forcast.dart';
import 'package:awesomeweather/WeatherModals/locations.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum State { initail, error, loading, loaded }

@immutable
abstract class WeatherState extends Equatable {
  WeatherState([List props = const <dynamic>[]]) : super();
  // final Location location;
  // final State state;
  // final Forecast forecast;
  // final String error;
  // WeatherState(
  //     {required this.location,
  //     required this.forecast,
  //     required this.error,
  //     this.state = State.initail})
  //     : super();

  // WeatherState copyWith(
  //     {State? state, String? error, Forecast? data, Location? location}) {
  //   return WeatherState(
  //       error: error ?? this.error,
  //       forecast: data ?? this.forecast,
  //       state: state ?? this.state,
  //       location: location ?? this.location);
  // }

  // @override
  // List<Object?> get props => [state, location, forecast, error];
}

class WeatherInitial extends WeatherState {
  @override
  List<Object?> get props => [];
}

class WeatherLoading extends WeatherState {
  @override
  List<Object?> get props => [];
}

// Only the WeatherLoaded event needs to contain data
class WeatherLoaded extends WeatherState {
  final Forecast forecast;
  final Location location;
  WeatherLoaded(this.forecast, this.location) : super([forecast, location]);

  @override
  List<Object?> get props => [forecast, location];
}

class WeatherError extends WeatherState {
  final String error;
  final Map<String, dynamic> data;
  // final Forecast previousForecast;
  // final Location previousLocation;
  WeatherError({required this.error, required this.data})
      : super([error, data]);

  // WeatherError copyWith({String? error, Forecast? data, Location? location}) =>
  //     WeatherError(
  //         error: error ?? this.error,
  //         previousForecast: data ?? this.previousForecast,
  //         previousLocation: location ?? this.previousLocation);
  @override
  List<Object?> get props => [error];
}
