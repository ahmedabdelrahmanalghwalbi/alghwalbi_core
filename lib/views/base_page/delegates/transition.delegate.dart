part of alghwalbi_core;

class TransitionDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final Offset offset;
  final double elevation;
  final Color? color;

  const TransitionDelegate({
    required this.child,
    required this.offset,
    this.color,
    this.elevation = 0.0,
  });
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = shrinkOffset / maxExtent;

    final dx = ((offset.dx.isNegative ? (1 - progress) : progress) *
            (offset.dx - 1).abs()) +
        (min(offset.dx, 1));

    final dy = ((offset.dy.isNegative ? (1 - progress) : progress) *
            (offset.dy - 1).abs()) +
        (min(offset.dy, 1));

    return Material(
      color: color,
      elevation: DelegateConfig.elevationValue(progress, elevation),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Transform.translate(
            offset: Offset(dx, dy),
            child: child,
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => DelegateConfig.maxExtent;

  @override
  double get minExtent => DelegateConfig.minExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
