import 'package:equatable/equatable.dart';

class {{name.pascalCase()}}UiState extends Equatable {
  final bool isLoading;
  final String? error;

  const {{name.pascalCase()}}UiState({
    this.isLoading = false,
    this.error,
  });

  {{name.pascalCase()}}UiState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return {{name.pascalCase()}}UiState(
    isLoading: isLoading ?? this.isLoading,
    error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, error];
}
