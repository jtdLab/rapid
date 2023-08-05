import 'package:faker/faker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '{{name.snakeCase()}}.freezed.dart';

sealed class {{name.pascalCase()}}{{{generics}}} {
  const {{name.pascalCase()}}._();

  factory {{name.pascalCase()}}({{{type}}} raw) {
    return _validate(raw);
  }

  factory {{name.pascalCase()}}.random({bool valid = true}) {
    final faker = Faker();

    if (valid) {
      return faker.randomGenerator.element([
        // TODO: insert random valid instances here
      ]);
    } else {
      return faker.randomGenerator.element([
        // TODO: insert random invalid instances here
      ]);
    }
  }

  static {{name.pascalCase()}}{{{generics}}} _validate{{{generics}}}({{{type}}} raw) {
    // TODO: implement validation here
    throw UnimplementedError();
  }

  {{{type}}} getOrCrash() {
    return switch (this) {
      Valid{{name.pascalCase()}}{{{generics}}} valid => valid.value,
      {{name.pascalCase()}}Failure failure =>
        throw StateError('Unexpected $failure at unrecoverable point.'),
    };
  }

  bool isValid() => this is Valid{{name.pascalCase()}};
}

@freezed
class Valid{{name.pascalCase()}}{{{generics}}} extends {{name.pascalCase()}}{{{generics}}} with _$Valid{{name.pascalCase()}}{{{generics}}} {
  const Valid{{name.pascalCase()}}._() : super._();
  const factory Valid{{name.pascalCase()}}({{{type}}} value) = _Valid{{name.pascalCase()}};
}

@freezed
sealed class {{name.pascalCase()}}Failure{{{generics}}} extends {{name.pascalCase()}}{{{generics}}} with _${{name.pascalCase()}}Failure{{{generics}}} {
  const {{name.pascalCase()}}Failure._() : super._();
  const factory {{name.pascalCase()}}Failure.foo() = {{name.pascalCase()}}FailureFoo;
  // TODO: add more failures here
}
