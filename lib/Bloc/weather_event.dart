import 'package:awesomeweather/WeatherModals/locations.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WeatherEvent extends Equatable {
  WeatherEvent([List props = const <dynamic>[]]) : super();
}

// There are twp event in this app for getting the weather and Reset the Weather

class GetWeather extends WeatherEvent {
  final String city;

  // Equatable allows for a simple value equality in Dart.
  // All you need to do is to pass the class fields to the super constructor.
  GetWeather(this.city) : super([city]);

  @override
  List<Object?> get props => [city];
}

class ResetWeather extends WeatherEvent {
  final Location location;
  // final int update;

  // Equatable allows for a simple value equality in Dart.
  // All you need to do is to pass the class fields to the super constructor.
  ResetWeather(/*this.update*/ this.location) : super([/*update*/ location]);

  @override
  List<Object?> get props => [location];
}

class GotoInitial extends WeatherEvent {
  @override
  List<Object?> get props => [];
}
