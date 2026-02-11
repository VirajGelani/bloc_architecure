import 'package:get_it/get_it.dart';
import 'package:{{project_name}}/features/{{name.snakeCase()}}/cubit/{{name.snakeCase()}}_ui_cubit.dart';

void register
{{name.pascalCase()}}

Feature(GetIt getIt) {
  getIt.registerFactory < {{name.pascalCase()}}UiCubit > (
          () => {{name.pascalCase()}}UiCubit(),);
}
