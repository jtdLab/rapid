import 'package:faker/faker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'foo_bar.freezed.dart';

@freezed
class FooBar with _$FooBar {
  const factory FooBar({
    required String id,
    // TODO: more fields
  }) = _FooBar;

  /// Returns an instance with random generated properties
  factory FooBar.dummy([Faker? f]) {
    final faker = f ?? Faker();

    return FooBar(
      id: faker.randomGenerator.string(16, min: 16),
    );
  }
}
