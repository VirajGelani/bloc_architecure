import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:{{project_name}}/features/{{{feature_path}}}/cubit/{{name.snakeCase()}}_ui_cubit.dart';
import 'package:{{project_name}}/features/{{{feature_path}}}/cubit/{{name.snakeCase()}}_ui_state.dart';

void main() {
  group('{{name.pascalCase()}}UiCubit', () {
    blocTest<{{name.pascalCase()}}UiCubit, {{name.pascalCase()}}UiState>(
    'emits loading true',
    build: () => {{name.pascalCase()}}UiCubit(),
    act: (cubit) {},
    expect: () => [],
    );

    blocTest<{{name.pascalCase()}}UiCubit, {{name.pascalCase()}}UiState>(
    'emits error message',
    build: () => {{name.pascalCase()}}UiCubit(),
    act: (cubit) {},
    expect: () => [],
    );
  });
}
