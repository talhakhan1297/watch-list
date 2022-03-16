import 'package:equatable/equatable.dart';

enum APICallState { initial, loading, loaded, failure }

class GeneralApiState<T> extends Equatable {
  final T? model;
  final APICallState apiCallState;
  final String? errorMessage;

  const GeneralApiState({
    this.model,
    this.apiCallState = APICallState.initial,
    this.errorMessage,
  });

  GeneralApiState<T> copyWith({
    T? model,
    APICallState? apiCallState,
    String? errorMessage,
  }) {
    return GeneralApiState(
      model: model ?? this.model,
      apiCallState: apiCallState ?? this.apiCallState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [model, apiCallState, errorMessage];
}
