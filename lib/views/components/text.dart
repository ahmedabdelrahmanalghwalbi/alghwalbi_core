part of alghwalbi_core;

class CoreText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool ltr;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  const CoreText(this.text,
      {super.key,
      this.style,
      this.textAlign,
      this.ltr = false,
      this.maxLines,
      this.softWrap,
      this.overflow});
  @override
  Widget build(BuildContext context) {
    return ltr
        ? Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              text,
              style: style,
              textAlign: textAlign,
              maxLines: maxLines,
              overflow: overflow,
              softWrap: softWrap,
            ),
          )
        : Text(
            text,
            style: style,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
            softWrap: softWrap,
          );
  }
}
