part of alghwalbi_core;

class CustomAnimatedPopup extends StatelessWidget {
  final String popupKey;
  final Widget shrinkedWidget;
  final Widget expandedWidget;
  final ShapeBorder? shapeBorder;
  final BorderRadius? borderRadius;
  final Color? color;
  final String? tooltip;
  final bool? isScrollable;
  final Axis? scrollDirection;

  const CustomAnimatedPopup(
      {required this.popupKey,
      required this.expandedWidget,
      required this.shrinkedWidget,
      super.key,
      this.shapeBorder,
      this.color,
      this.isScrollable,
      this.tooltip,
      this.borderRadius,
      this.scrollDirection});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            HeroDialogRoute(
              builder: (context) => Center(
                child: Hero(
                  tag: popupKey,
                  createRectTween: (begin, end) {
                    return CustomRectTween(begin: begin!, end: end!);
                  },
                  child: Material(
                      borderRadius: borderRadius,
                      color: color,
                      shape: shapeBorder,
                      child: isScrollable == true
                          ? SingleChildScrollView(
                              scrollDirection: scrollDirection ?? Axis.vertical,
                              child: expandedWidget)
                          : expandedWidget),
                ),
              ),
            ),
          );
        },
        child: Hero(
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin!, end: end!);
          },
          tag: popupKey,
          child: Material(
              borderRadius: borderRadius,
              color: color,
              shape: shapeBorder,
              child: shrinkedWidget),
        ),
      ),
    );
  }
}
