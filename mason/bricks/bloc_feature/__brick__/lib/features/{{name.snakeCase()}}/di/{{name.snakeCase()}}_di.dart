import 'package:get_it/get_it.dart';
import 'package:{{project_name}}/features/{{name.snakeCase()}}/bloc/{{name.snakeCase()}}_bloc.dart';

void register
{{name.pascalCase()}}

Feature(GetIt getIt) {
  getIt.registerFactory < {{name.pascalCase()}}Bloc > (
          () => {{name.pascalCase()}}Bloc(),);
}
