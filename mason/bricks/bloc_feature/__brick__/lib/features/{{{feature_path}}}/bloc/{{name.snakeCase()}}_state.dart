import 'package:freezed_annotation/freezed_annotation.dart';

part '{{name.snakeCase()}}_state.freezed.dart';

@freezed
class {{name.pascalCase()}}State with _${{name.pascalCase()}}State {
  const factory {{name.pascalCase()}}State({
    @Default(false) bool isLoading,
    String? error,
  }) = _{{name.pascalCase()}}State;

  factory {{name.pascalCase()}}State.initial() =>
      const {{name.pascalCase()}}State();
}
