import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_flutter_study/constants/enums.dart';
import 'package:bloc_flutter_study/cubit/internet_cubit.dart';
import 'package:meta/meta.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  final InternetCubit internetCubit;
  StreamSubscription internetStreamSubscription;

  CounterCubit({@required this.internetCubit})
      : super(CounterState(counterValue: 0)) {
    monitorInternetCubit();
  }

  StreamSubscription<InternetState> monitorInternetCubit() {
    return internetStreamSubscription = internetCubit.stream.listen((internetState) {
    if (internetState is InternetConnected &&
        internetState.connectionType == ConnectionType.wifi) {
      increment();
    }
    if (internetState is InternetConnected &&
        internetState.connectionType == ConnectionType.mobile) {
      decrement();
    }
  });
  }

  void increment() {
    emit(CounterState(
        counterValue: state.counterValue + 1, wasIncremented: true));
  }

  void decrement() {
    emit(CounterState(
        counterValue: state.counterValue - 1, wasIncremented: false));
  }

  @override
  Future<void> close() {
    internetStreamSubscription.cancel();
    return super.close();
  }
}
