import 'package:bloc/bloc.dart';
import 'package:bloc_architecure/core/base/base_ui_state.dart';

abstract class BaseCubit<S extends BaseUiState> extends Cubit<S> {
  BaseCubit(super.initialState);
}
