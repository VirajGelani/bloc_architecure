import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:{{project_name}}/features/{{name.snakeCase()}}/bloc/{{name.snakeCase()}}_bloc.dart';
import 'package:{{project_name}}/features/{{name.snakeCase()}}/bloc/{{name.snakeCase()}}_event.dart';
import 'package:{{project_name}}/features/{{name.snakeCase()}}/bloc/{{name.snakeCase()}}_state.dart';

void main() {
  group('{{name.pascalCase()}}Bloc', () {
    blocTest<{{name.pascalCase()}}Bloc, {{name.pascalCase()}}State>(
    'emits Loading when Started event is added',
    build: () => {{name.pascalCase()}}Bloc(),
    act: (bloc) => bloc.add(const {{name.pascalCase()}}Started()),
    expect: () => [
    {{name.pascalCase()}}Loading(),
    ],
    );
  });
}
