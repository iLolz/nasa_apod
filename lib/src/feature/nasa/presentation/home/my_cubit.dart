import 'dart:async';

class MyCubit<T> {
  late StreamController<T> stream;

  late T state;

  MyCubit(T initialValue) : super() {
    stream = StreamController.broadcast();
    state = initialValue;
  }

  void emit(T newState) {
    stream.sink.add(newState);
    state = newState;
  }
}

class UseCubit extends MyCubit<int> {
  UseCubit() : super(0);

  void increment() => emit(state + 1);

  void decrement() => emit(state - 1);
}
