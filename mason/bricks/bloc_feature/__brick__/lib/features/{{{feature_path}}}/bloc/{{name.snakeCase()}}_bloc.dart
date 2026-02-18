import 'package:bloc/bloc.dart';
import 'package:{{project_name}}/core/base/base_bloc.dart';
import 'package:{{project_name}}/features/{{{feature_path}}}/bloc/{{name.snakeCase()}}_event.dart';
import 'package:{{project_name}}/features/{{{feature_path}}}/bloc/{{name.snakeCase()}}_state.dart';

class {{name.pascalCase()}}Bloc
    extends BaseBloc<{{name.pascalCase()}}Event, {{name.pascalCase()}}State> {
  {{name.pascalCase()}}Bloc() : super({{name.pascalCase()}}State.initial()) {
    on<{{name.pascalCase()}}Event>((event, emit) async {
      await event.when(
        started: () => _onStarted(emit),
      );
    });
  }

  Future<void> _onStarted(
    Emitter<{{name.pascalCase()}}State> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    await Future.delayed(const Duration(seconds: 1));

    emit(state.copyWith(isLoading: false));
  }
}
