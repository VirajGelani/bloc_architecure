import 'package:equatable/equatable.dart';

sealed class {{name.pascalCase()}}State extends Equatable {
  const {{name.pascalCase()}}State();

  @override
  List<Object?> get props => [];
}

class {{name.pascalCase()}}Initial
    extends {{name.pascalCase()}}State {}

class {{name.pascalCase()}}Loading
    extends {{name.pascalCase()}}State {}

class {{name.pascalCase()}}Success
    extends {{name.pascalCase()}}State {}

class {{name.pascalCase()}}Failure
    extends {{name.pascalCase()}}State {
  final String message;
  const {{name.pascalCase()}}Failure(this.message);

  @override
  List<Object?> get props => [message];
}
