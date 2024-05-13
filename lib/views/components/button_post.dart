part of alghwalbi_core;

class AppButtonPost extends StatefulWidget {
  /// button label
  final String label;

  /// button on press function
  final Future Function()? onPressed;

  /// border round edge
  final double roundEdge;

  /// button height
  final double height;

  /// background  color
  final Color? color;

  /// text style
  final TextStyle? textStyle;

  /// hero for navigation animation
  final String? heroTag;

  /// main button
  const AppButtonPost(
      {required this.label,
      this.onPressed,
      this.heroTag,
      this.roundEdge = 0,
      this.height = 50.0,
      this.color,
      this.textStyle,
      super.key});
  @override
  AppButtonPostState createState() => AppButtonPostState();
}

class AppButtonPostState extends State<AppButtonPost>
    with SingleTickerProviderStateMixin {
  double width = 320;
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _animationRadius;
  bool _isBusy = false;
  @override
  initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _animation = Tween(
      begin: width,
      end: 40.0,
    ).animate(CurvedAnimation(
        parent: _controller, curve: const Interval(0.0, 0.250)));
    _animationRadius = Tween(
      begin: widget.roundEdge,
      end: 50.0,
    ).animate(CurvedAnimation(
        parent: _controller, curve: const Interval(0.0, 0.250)));
    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  onPressed() async {
    try {
      _isBusy = true;
      _controller.forward();
      await widget.onPressed?.call();
      _controller.reverse();
      _isBusy = false;
    } catch (_) {}
  }

  showLoading() {
    return _isBusy && _animation.value < 100;
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.heroTag != null
        ? Hero(
            tag: widget.heroTag ?? '',
            child: _getButton(),
          ) //"submit_button" + widget.label
        : _getButton();
  }

  Widget _getButton() {
    return MaterialButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_animationRadius.value)),
      color: widget.color ?? ThemeService.secondryColor,
      onPressed: onPressed,
      child: SizedBox(
        height: widget.height,
        width: _animation.value == width
            ? null
            : _animation.value, //double.infinity,
        child: Center(
          child: showLoading()
              ? const CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Transform.scale(
                  scale: (_animation.value - 40) / 280,
                  child: Text(
                    widget.label,
                    style: widget.textStyle ??
                        TextStyle(
                            color: ThemeService.textOnSecondColor,
                            fontSize: 18.0),
                  ),
                ),
        ),
      ),
    );
  }
}
