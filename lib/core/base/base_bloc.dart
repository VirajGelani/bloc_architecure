import 'package:bloc/bloc.dart';

abstract class BaseBloc<E, S> extends Bloc<E, S> {
  BaseBloc(super.initialState);

/// Common place for logging, analytics, guards, etc.
}
