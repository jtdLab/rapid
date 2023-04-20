import 'package:example_ui/src/assets.gen.dart';
import 'package:flutter/widgets.dart';

class RapidLogo extends StatelessWidget {
  final double width;
  final double height;

  const RapidLogo({super.key})
      : width = 175,
        height = 175;

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
