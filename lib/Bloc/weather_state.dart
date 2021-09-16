import 'package:awesomeweather/WeatherModals/forcast.dart';
import 'package:awesomeweather/WeatherModals/locations.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WeatherState extends Equatable {
  WeatherState([List props = const <dynamic>[]]) : super();
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
  WeatherError(this.error) : super([error]);
  @override
  List<Object?> get props => [error];
}
