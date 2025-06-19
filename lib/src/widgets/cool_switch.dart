import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CoolSwitch extends StatelessWidget {
  final double width;
  final bool value;
  const CoolSwitch({super.key, required this.value, this.width = 140});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      value ? "images/switch_on.svg" : "images/switch_off.svg",
      width: width,
    );
  }
}
