part of alghwalbi_core;

class TextFormLabel extends StatelessWidget {
  final String? value;
  final Widget? valueWidget;
  final String label;
  final String? description;
  final TextStyle? valueStyle;
  TextFormLabel(
      {required this.label,
      this.description,
      this.value,
      this.valueWidget,
      this.valueStyle,
      super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10),
        Tooltip(
            message: description ?? '',
            child: Text(label,
                style:
                    TextStyle(color: ThemeService.textSubColor, fontSize: 11))),
        if (valueWidget != null) valueWidget!,
        if (value != null)
          SelectableText(value!,
              style: valueStyle ??
                  const TextStyle(color: Colors.black, fontSize: 15)),
        const SizedBox(height: 10),
        Container(height: 1, color: ThemeService.textSubColor),
        const SizedBox(height: 5),
      ],
    );
  }
}
