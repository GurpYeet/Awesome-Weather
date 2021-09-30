// ignore_for_file: non_constant_identifier_names

import 'package:awesomeweather/WeatherModals/locations.dart';
import 'package:awesomeweather/weatherRepo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_exception.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  WeatherRepo repo;
  CityBloc(this.repo) : super(CityInitial());

  @override
  Stream<CityState> mapEventToState(CityEvent event) async* {
    yield CityLoading();
    try {
      List<Location> locations = await repo.getCities(event.city);
      yield CitiesLoaded(locations);
    } catch (error) {
      if (error is AppException)
        yield CitiesError(
          error.prefix ?? 'Something Went Wrong',
        );
      else
        yield CitiesError('Something Went Wrong');
    }
  }
}

class CityEvent extends Equatable {
  final String city;
  final Map<String, dynamic> predata;
  CityEvent({required this.city, required this.predata});

  @override
  List<Object?> get props => [];
}

@immutable
abstract class CityState extends Equatable {
  CityState([List props = const <dynamic>[]]) : super();
}

class CityLoading extends CityState {
  @override
  List<Object?> get props => [];
}

class CityInitial extends CityState {
  @override
  List<Object?> get props => [];
}

class CitiesLoaded extends CityState {
  final List<Location> cities;
  CitiesLoaded(this.cities) : super([cities]);
  @override
  List<Object?> get props => [cities];
}

class CitiesError extends CityState {
  final String error;
  CitiesError(this.error) : super([error]);
  @override
  List<Object?> get props => [error];
}
