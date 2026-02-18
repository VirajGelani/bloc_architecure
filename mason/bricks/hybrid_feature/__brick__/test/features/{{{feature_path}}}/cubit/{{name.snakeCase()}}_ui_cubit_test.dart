import 'package:flutter_test/flutter_test.dart';

import 'package:{{project_name}}/features/{{{feature_path}}}/cubit/{{name.snakeCase()}}_ui_cubit.dart';
import 'package:{{project_name}}/features/{{{feature_path}}}/cubit/{{name.snakeCase()}}_ui_state.dart';

void main() {
  group('{{name.pascalCase()}}UiCubit', () {
    test('initial state is correct', () {
      final cubit = {{name.pascalCase()}}UiCubit();

      expect(cubit.state, const {{name.pascalCase()}}UiState());
    });
  });
}
