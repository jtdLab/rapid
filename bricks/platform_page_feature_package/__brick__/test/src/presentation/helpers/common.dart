import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

BlocProvider provider<T extends BlocBase<S>, S>(
  T bloc, {
  required S initialState,
}) {
  assert(bloc is MockBloc || bloc is MockCubit);
  whenListen(bloc, Stream<S>.empty(), initialState: initialState);
  return BlocProvider<T>(create: (_) => bloc);
}
