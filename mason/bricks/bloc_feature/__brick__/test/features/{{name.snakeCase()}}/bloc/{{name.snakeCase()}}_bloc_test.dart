import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:{{project_name}}/features/{{{feature_path}}}/bloc/{{name.snakeCase()}}_bloc.dart';
import 'package:{{project_name}}/features/{{{feature_path}}}/bloc/{{name.snakeCase()}}_event.dart';
import 'package:{{project_name}}/features/{{{feature_path}}}/bloc/{{name.snakeCase()}}_state.dart';

void main() {
  group('{{name.pascalCase()}}Bloc', () {
    test('initial state is correct', () {
      expect(
        {{name.pascalCase()}}Bloc().state,
        {{name.pascalCase()}}State.initial(),
      );
    });
    blocTest<{{name.pascalCase()}}Bloc, {{name.pascalCase()}}State>(
      'emits loading true then false when started is added',
      build: () => {{name.pascalCase()}}Bloc(),
      act: (bloc) => bloc.add(const {{name.pascalCase()}}Event.started()),
      expect: () => [
        const {{name.pascalCase()}}State(isLoading: true),
        const {{name.pascalCase()}}State(isLoading: false),
      ],
    );
  });
}
