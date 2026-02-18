import 'package:get_it/get_it.dart';
import 'package:{{project_name}}/features/{{{feature_path}}}/bloc/{{name.snakeCase()}}_bloc.dart';

void register{{name.pascalCase()}}Feature(GetIt getIt) {
  getIt.registerFactory<{{name.pascalCase()}}Bloc>(
    () => {{name.pascalCase()}}Bloc(),
  );
}
