import 'package:example_ui/src/assets.gen.dart';
import 'package:flutter/widgets.dart';

class RapidLogo extends StatelessWidget {
  final double width;
  final double height;

  const RapidLogo({super.key})
      : width = 150,
        height = 150;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Assets.images.logo.svg(
        package: 'example_ui',
      ),
    );
  }
}
