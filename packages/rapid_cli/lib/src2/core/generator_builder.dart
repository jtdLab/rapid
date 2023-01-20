import 'package:mason/mason.dart';

/// Signature for method that returns a [MasonGenerator] binded to [bundle].
typedef GeneratorBuilder = Future<MasonGenerator> Function(MasonBundle bundle);
