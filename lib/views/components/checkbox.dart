part of alghwalbi_core;

class AppCheckBox extends StatefulWidget {
  /// checkbox label
  final String? label;
  final String? description;

  /// checkbox value
  final bool? initalValue;

  /// expand to fit full row
  final bool isFullrow;

  /// on value changed call back
  final void Function(bool)? onChanged;

  /// check box controll
  const AppCheckBox(
      {required this.label,
      this.initalValue,
      this.description,
      this.onChanged,
      this.isFullrow = false,
      super.key});
  @override
  AppCheckBoxState createState() => AppCheckBoxState();
}

class AppCheckBoxState extends State<AppCheckBox> {
  bool _value = false;
  bool? _classValue;
  @override
  void initState() {
    _classValue = widget.initalValue;
    _value = widget.initalValue ?? false;

    super.initState();
    if (widget.initalValue == null) valueChanged(false);
  }

  valueChanged(v) {
    _value = v;
    setState(() {});
    if (widget.onChanged != null) {
      widget.onChanged?.call(
          _value); // change the default value to be [false] when it's null
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initalValue != _classValue) {
      _classValue = widget.initalValue;
      _value = widget.initalValue ?? false;
    }
    return MaterialButton(
        onPressed: () => valueChanged(!_value),
        child: Row(
          children: <Widget>[
            Checkbox(
              value: _value,
              onChanged: valueChanged,
            ),
            widget.isFullrow
                ? Expanded(
                    child: Tooltip(
                        message: widget.description ?? '',
                        child: Text(
                          widget.label ?? '',
                          maxLines: 3,
                          softWrap: true,
                        )))
                : Tooltip(
                    message: widget.description ?? '',
                    child: Text(widget.label ?? ''))
          ],
        ));
  }
}
