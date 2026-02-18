import 'package:{{project_name}}/core/base/base_cubit.dart';
import 'package:{{project_name}}/features/{{{feature_path}}}/cubit/{{name.snakeCase()}}_ui_state.dart';

class {{name.pascalCase()}}UiCubit extends BaseCubit<{{name.pascalCase()}}UiState> {
{{name.pascalCase()}}UiCubit() : super(const {{name.pascalCase()}}UiState());


}
