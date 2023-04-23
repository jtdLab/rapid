part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.loadInProgress() = HomeLoadInProgress;
  const factory HomeState.loadSuccess({
    required String readMe,
  }) = HomeLoadSuccess;
  const factory HomeState.loadFailure({
    required MarkdownServiceFetchMarkdownFileFailure failure,
  }) = HomeLoadFailure;
}
