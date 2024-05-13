part of alghwalbi_core;

class ShimmerAnimatedLoading extends StatefulWidget {
  final double? height, width, circularRaduis, maxHeight, maxWidth;

  const ShimmerAnimatedLoading(
      {super.key,
      this.height,
      this.width,
      this.circularRaduis,
      this.maxHeight,
      this.maxWidth});

  @override
  State<ShimmerAnimatedLoading> createState() => _ShimmerAnimatedLoadingState();
}

class _ShimmerAnimatedLoadingState extends State<ShimmerAnimatedLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _color;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _color = ColorTween(
            begin: Colors.black.withOpacity(.02),
            end: Colors.black.withOpacity(.09))
        .animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _color,
      builder: (BuildContext context, Widget? child) {
        return Container(
          constraints: BoxConstraints(
            maxWidth: widget.maxWidth ?? double.infinity,
            maxHeight: widget.maxHeight ?? double.infinity,
          ),
          height: widget.height,
          width: widget.width,
          padding: const EdgeInsets.all(16 / 2),
          decoration: BoxDecoration(
              color: _color.value,
              borderRadius: BorderRadius.all(
                  Radius.circular(widget.circularRaduis ?? 1))),
        );
      },
    );
  }
}
