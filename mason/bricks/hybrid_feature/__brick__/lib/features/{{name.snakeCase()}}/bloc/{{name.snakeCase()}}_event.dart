import 'package:equatable/equatable.dart';

sealed class {{name.pascalCase()}}Event extends Equatable {
  const {{name.pascalCase()}}Event();

  @override
  List<Object?> get props => [];
}

class {{name.pascalCase()}}Started
    extends {{name.pascalCase()}}Event {
  const {{name.pascalCase()}}Started();
}
