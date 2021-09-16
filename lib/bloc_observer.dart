import 'dart:convert';

import 'package:awesomeweather/Bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class WeatherBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('onEvent $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('onChange $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('onTransition $transition');
    final dynamic state = transition.nextState;
    if (state is WeatherLoaded) {
      if (bloc is HydratedBloc) {
        final statejson = bloc.toJson(state);
        if (statejson != null) {
          HydratedBloc.storage.write(
            bloc.runtimeType.toString(),
            jsonEncode(statejson),
          );
        }
      }
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError $error');
    super.onError(bloc, error, stackTrace);
  }
}
