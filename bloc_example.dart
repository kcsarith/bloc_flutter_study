import 'dart:async';

import 'package:bloc/bloc.dart';

enum CounterEvent { increment, decrement }

class CounterState {
  int counterValue;
  CounterState({this.counterValue});
}

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0);

  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
    switch (event) {
      case CounterEvent.increment:
        yield state + 1;
        break;
      case CounterEvent.decrement:
        yield state - 1;
        break;
    }
    throw UnimplementedError();
  }
}

void main() async {
  final bloc = CounterBloc();
  final StreamSubscription streamSubscription = bloc.stream.listen(print);

  bloc.add(CounterEvent.increment);
  bloc.add(CounterEvent.increment);
  bloc.add(CounterEvent.increment);
  bloc.add(CounterEvent.increment);
  bloc.add(CounterEvent.increment);
  bloc.add(CounterEvent.decrement);
  await Future.delayed(Duration.zero);

  await streamSubscription.cancel();
  await bloc.close();
}
