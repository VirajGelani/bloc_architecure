import 'package:{{project_name}}/core/base/base_ui_state.dart';

class {{name.pascalCase()}}UiState extends BaseUiState {
const {{name.pascalCase()}}UiState({super.isLoading, super.errorMessage});

{{name.pascalCase()}}UiState copyWith({bool? isLoading, String? errorMessage}) {
return {{name.pascalCase()}}UiState(
isLoading: isLoading ?? this.isLoading,
errorMessage: errorMessage ?? this.errorMessage,
);
}
}