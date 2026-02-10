import 'package:bloc/bloc.dart';
import 'package:{{project_name}}/features/{{name.snakeCase()}}/cubit/{{name.snakeCase()}}_ui_state.dart';

class {{name.pascalCase()}}UiCubit
extends Cubit<{{name.pascalCase()}}UiState> {
  {{name.pascalCase()}}UiCubit()
      : super(const {{name.pascalCase()}}UiState());

  void setLoading(bool value) {
    emit(state.copyWith(isLoading: value));
  }

  void setError(String? message) {
    emit(state.copyWith(error: message));
  }
}
