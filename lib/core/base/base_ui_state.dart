import 'package:equatable/equatable.dart';

abstract class BaseUiState extends Equatable {
  final bool isLoading;
  final String? errorMessage;

  const BaseUiState({
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [isLoading, errorMessage];
}
