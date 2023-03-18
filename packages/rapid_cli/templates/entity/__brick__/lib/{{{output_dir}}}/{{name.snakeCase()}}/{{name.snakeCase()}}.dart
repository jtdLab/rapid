import 'package:faker/faker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '{{name.snakeCase()}}.freezed.dart';

@freezed
class {{name.pascalCase()}} with _${{name.pascalCase()}} {
  const factory {{name.pascalCase()}}({
    required String id,
    // TODO: more fields
  }) = _{{name.pascalCase()}};

  /// Returns a random instance.
  factory {{name.pascalCase()}}.random() {
    final faker = Faker();

    return {{name.pascalCase()}}(
      id: faker.randomGenerator.string(16, min: 16),
    );
  }
}
