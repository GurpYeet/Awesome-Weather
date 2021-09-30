import 'package:awesomeweather/WeatherModals/locations.dart';
import 'package:equatable/equatable.dart';

class ResetWeather extends Equatable {
  final Location location;
  // final int update;
  final Map<String, dynamic> predata;
  // Equatable allows for a simple value equality in Dart.
  // All you need to do is to pass the class fields to the super constructor.
  ResetWeather({/*this.update*/ required this.location, required this.predata});

  @override
  List<Object?> get props => [location, predata];
}
