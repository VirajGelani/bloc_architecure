import 'package:{{project_name}}/core/base/base_cubit.dart';
import 'package:{{project_name}}/features/{{name.snakeCase()}}/cubit/{{name.snakeCase()}}_ui_state.dart';

class {{name.pascalCase()}}UiCubit
extends BaseCubit<{{name.pascalCase()}}UiState> {
{{name.pascalCase()}}UiCubit()
    : super(const {{name.pascalCase()}}UiState());

@override
{{name.pascalCase()}}UiState copyWithLoading(bool isLoading) {
return state.copyWith(isLoading: isLoading);
}

@override
{{name.pascalCase()}}UiState copyWithError(String? errorMessage) {
return state.copyWith(errorMessage: errorMessage);
}
}
