import 'package:bloc/bloc.dart';
import 'package:{{project_name}}/core/base/base_bloc.dart';
import 'package:{{project_name}}/features/{{{feature_path}}}/bloc/{{name.snakeCase()}}_event.dart';
import 'package:{{project_name}}/features/{{{feature_path}}}/bloc/{{name.snakeCase()}}_state.dart';

class {{name.pascalCase()}}Bloc extends BaseBloc<{{name.pascalCase()}}Event, {{name.pascalCase()}}State> {
{{name.pascalCase()}}Bloc() : super({{name.pascalCase()}}Initial()) {
on<{{name.pascalCase()}}Started>(_onStarted);
}

Future<void> _onStarted({{name.pascalCase()}}Started event, Emitter<{{name.pascalCase()}}State> emit) async {}
}
