import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? size;
  final FontWeight? weight;
  final Color? color;
  final int? maxline;
  final double? spacing;
  final TextOverflow? flow;
  final TextAlign? align;
  final bool? isFit;
  const CustomText(
      {super.key,
      required this.text,
      this.size,
      this.weight,
      this.color,
      this.maxline,
      this.spacing,
      this.flow,
      this.align,
      this.isFit});

  @override
  Widget build(BuildContext context) {
    return isFit == true
        ? FittedBox(
            child: Text(text,
                maxLines: maxline,
                textAlign: align,
                style: TextStyle(
                    color: color,
                    fontSize: size,
                    fontWeight: weight,
                    overflow: flow,
                    letterSpacing: spacing)),
          )
        : Text(text,
            maxLines: maxline,
            textAlign: align,
            style: TextStyle(
                color: color,
                fontSize: size,
                fontWeight: weight,
                overflow: flow,
                letterSpacing: spacing));
  }
}
