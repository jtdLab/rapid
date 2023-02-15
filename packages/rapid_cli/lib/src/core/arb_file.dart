import 'arb_file_impl.dart';
import 'file.dart';

/// {@template arb_file}
/// Abstraction of a arb file.
/// {@endtemplate}
abstract class ArbFile implements File {
  /// {@macro arb_file}
  factory ArbFile({
    String path = '.',
    required String name,
  }) =>
      ArbFileImpl(path: path, name: name);

  /// Sets [value] at [path].
  ///
  /// Path must have length 1.
  void setValue<T extends Object?>(
    Iterable<String> path,
    T? value,
  );
}
