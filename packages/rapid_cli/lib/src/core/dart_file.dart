import 'package:code_builder/code_builder.dart' show Method;

import 'dart_file_impl.dart';
import 'file.dart';

export 'package:code_builder/code_builder.dart';

/// {@template dart_file}
/// Abstraction of a dart file.
/// {@endtemplate}
abstract class DartFile implements File {
  factory DartFile({
    String path = '.',
    required String name,
  }) =>
      DartFileImpl(path: path, name: name);

  /// Formates and writes [contents] to the underlying file.
  @override
  void write(String contents);

  /// Adds [import] with an optional [alias].
  ///
  /// Hint: The imports get sorted after adding
  void addImport(String import, {String? alias});

  /// Adds [export].
  ///
  /// Hint: The exports get sorted after adding
  void addExport(String export);

  /// Adds parameter with [paramName] to the [index]-th call to function with [functionToCallName] inside
  /// the body of function [functionName] and assigns it to [paramValue].
  ///
  /// **IMPORTANT**: Does nothing if the the parameter already exists.
  ///
  /// For example:
  ///
  /// Given:
  /// ```dart
  /// void foo() {
  ///  bar();
  ///  bar();
  /// }
  /// ```
  /// When call:
  /// ```dart
  /// addNamedParamToMethodCallInTopLevelFunctionBody(
  ///   paramName: 'a',
  ///   paramValue: '"hello"',
  ///   functionName: 'foo',
  ///   functionToCallName: 'bar',
  ///   index: 1
  /// );
  /// ```
  /// The result is:
  /// ```dart
  /// void foo() {
  ///  bar();
  ///  bar(
  ///   a: "hello",
  ///  );
  /// }
  /// ```
  void addNamedParamToMethodCallInTopLevelFunctionBody({
    required String paramName,
    required String paramValue,
    required String functionName,
    required String functionToCallName,
    int index = 0,
  });

  /// Adds [function] as a top-level function.
  void addTopLevelFunction(Method function);

  /// Returns all [import]s.
  List<String> readImports();

  /// Returns a list with the names of all top-level functions.
  List<String> readTopLevelFunctionNames();

  /// Reads the values of a list stored in the top-level variable [name].
  List<String> readTopLevelListVar({required String name});

  /// Reads the [property] of the [annotation] the class with [className] is annotated with.
  ///
  /// The property must be list of Type in source file.
  List<String> readTypeListFromAnnotationParamOfClass({
    required String property,
    required String annotation,
    required String className,
  });

  /// Reads the [property] of the [annotation] the function with [functionName] is annotated with.
  ///
  /// The property must be list of Type in source file.
  List<String> readTypeListFromAnnotationParamOfTopLevelFunction({
    required String property,
    required String annotation,
    required String functionName,
  });

  /// Removes [import].
  void removeImport(String import);

  /// Removes [export].
  void removeExport(String export);

  /// Removes parameter with [paramName] from the [index]-th call to function with [functionToCallName] inside
  /// the body of function [functionName].
  ///
  /// For example:
  ///
  /// Given:
  /// ```dart
  /// void foo() {
  ///  bar();
  ///  bar(
  ///   a: "hello",
  ///  );
  /// }
  /// ```
  /// When call:
  /// ```dart
  /// removeNamedParamFromMethodCallInTopLevelFunctionBody(
  ///   paramName: 'a',
  ///   functionName: 'foo',
  ///   functionToCallName: 'bar',
  ///   index: 1
  /// );
  /// ```
  /// The result is:
  /// ```dart
  /// void foo() {
  ///  bar();
  ///  bar();
  /// }
  /// ```
  void removeNamedParamFromMethodCallInTopLevelFunctionBody({
    required String paramName,
    required String functionName,
    required String functionToCallName,
    int index = 0,
  });

  /// Removes the top-level function with [name].
  void removeTopLevelFunction(String name);

  /// Sets the values of a list stored in a top-level variable [name].
  void setTopLevelListVar({
    required String name,
    required List<String> value,
  });

  /// Sets the [property] of the [annotation] the function with [functionName] is annotated with to [value].
  ///
  /// For example:
  ///
  /// Given:
  /// ```dart
  /// @SomeAnnotation(someProp: 5)
  /// void foo() {}
  /// ```
  /// When call:
  /// ```dart
  /// setAnnotationProperty(
  ///   property: 'someProp',
  ///   annotation: 'SomeAnnotation',
  ///   functionName: 'foo
  ///   value: 100
  /// );
  /// ```
  /// The result is:
  /// ```dart
  /// @SomeAnnotation(someProp: 100)
  /// void foo() {}
  /// ```
  void setTypeListOfAnnotationParamOfTopLevelFunction({
    required String property,
    required String annotation,
    required String functionName,
    required List<String> value,
  });

  /// Sets the [property] of the [annotation] the class with [className] is annotated with to [value].
  ///
  /// For example:
  ///
  /// Given:
  /// ```dart
  /// @SomeAnnotation(someProp: 5)
  /// class Foo {}
  /// ```
  /// When call:
  /// ```dart
  /// setAnnotationProperty(
  ///   property: 'someProp',
  ///   annotation: 'SomeAnnotation',
  ///   className: 'Foo
  ///   value: 100
  /// );
  /// ```
  /// The result is:
  /// ```dart
  /// @SomeAnnotation(someProp: 100)
  /// class Foo {}
  /// ```
  void setTypeListOfAnnotationParamOfClass({
    required String property,
    required String annotation,
    required String className,
    required List<String> value,
  });
}
