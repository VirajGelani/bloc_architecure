import 'package:bloc/bloc.dart';
import 'package:bloc_architecure/core/base/base_ui_state.dart';

abstract class BaseCubit<S extends BaseUiState> extends Cubit<S> {
  BaseCubit(super.initialState);

  void setLoading(bool value) {
    emit(copyWithLoading(value));
  }

  void setError(String? message) {
    emit(copyWithError(message));
  }

  /// Each UiState MUST implement these
  S copyWithLoading(bool isLoading);
  S copyWithError(String? errorMessage);
}
