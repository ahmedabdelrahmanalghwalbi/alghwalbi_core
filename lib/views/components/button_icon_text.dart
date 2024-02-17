part of alghwalbi_core;

class AppButtonIconText extends StatefulWidget {
  /// button label
  final String label;

  /// icon
  final Widget? icon;

  /// button height
  final double? height;

  /// button color
  final Color? color;

  /// if the button will expand to fill size
  final bool isFullRow;

  /// onPress function
  final Future Function()? onPressed;

  /// Icon button
  const AppButtonIconText(
      {required this.label,
      this.icon,
      this.onPressed,
      this.color,
      this.height,
      this.isFullRow = false,
      super.key});
  @override
  _AppButtonIconTextState createState() => _AppButtonIconTextState();
}

class _AppButtonIconTextState extends State<AppButtonIconText> {
  bool isBussy = false;
  @override
  initState() {
    super.initState();
  }

  Future onPressed() async {
    try {
      if (isBussy) return;
      setState(() => isBussy = true);
      await widget.onPressed?.call();
      setState(() => isBussy = false);
    } catch (err) {}
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        elevation: widget.color == Colors.transparent ? 0 : null,
        shape: widget.color == Colors.transparent
            ? null
            : RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        highlightElevation: widget.color == Colors.transparent ? 0 : null,
        focusElevation: widget.color == Colors.transparent ? 0 : null,
        hoverElevation: widget.color == Colors.transparent ? 0 : null,
        disabledElevation: widget.color == Colors.transparent ? 0 : null,
        hoverColor:
            widget.color == Colors.transparent ? Colors.transparent : null,
        focusColor:
            widget.color == Colors.transparent ? Colors.transparent : null,
        splashColor:
            widget.color == Colors.transparent ? Colors.transparent : null,
        highlightColor:
            widget.color == Colors.transparent ? Colors.transparent : null,
        padding: EdgeInsets.all(5),
        color: widget.color ?? ThemeService.mainColor,
        onPressed: onPressed,
        child: Container(
          height: widget.height,
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              isBussy
                  ? Transform.scale(
                      scale: 0.5,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            widget.color == Colors.transparent
                                ? ThemeService.mainColor
                                : ThemeService.textOnMainColor),
                      ))
                  : Transform.scale(scale: 0.8, child: widget.icon),
              widget.isFullRow
                  ? Expanded(
                      child: Text(
                      widget.label,
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          color: widget.color == Colors.transparent
                              ? ThemeService.mainColor
                              : ThemeService.textOnMainColor),
                    ))
                  : Text(
                      widget.label,
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          color: widget.color == Colors.transparent
                              ? ThemeService.mainColor
                              : ThemeService.textOnMainColor),
                    )
            ],
          )),
        ));
  }
}
