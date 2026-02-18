import 'package:bloc/bloc.dart';
import 'package:{{project_name}}/core/base/base_bloc.dart';
import 'package:{{project_name}}/features/{{{feature_path}}}/bloc/{{name.snakeCase()}}_event.dart';
import 'package:{{project_name}}/features/{{{feature_path}}}/bloc/{{name.snakeCase()}}_state.dart';

class {{name.pascalCase()}}Bloc
    extends BaseBloc<{{name.pascalCase()}}Event, {{name.pascalCase()}}State> {
  {{name.pascalCase()}}Bloc() : super({{name.pascalCase()}}State.initial()) {
    on<{{name.pascalCase()}}Event>(
      ({{name.pascalCase()}}Event event, Emitter<{{name.pascalCase()}}State> emit) {
        event.map(started: (event) => _onStarted(emit));
      },
    );
  }

  Future<void> _onStarted(Emitter<{{name.pascalCase()}}State> emit) async {}
}
