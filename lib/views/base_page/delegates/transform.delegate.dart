part of alghwalbi_core;

class TransformDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final Widget shrinkChild;
  final double expandedHeight;
  final double shrinkHeight;
  final double elevation;
  final Color? color;
  TransformDelegate({
    required this.child,
    required this.shrinkChild,
    required this.expandedHeight,
    required this.shrinkHeight,
    this.color,
    this.elevation = 0.0,
  });
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = min(shrinkOffset, minExtent) / minExtent;

    return Material(
      color: color,
      elevation: DelegateConfig.elevationValue(progress, elevation),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedOpacity(
            duration: DelegateConfig.animationDurationValue,
            opacity: progress,
            child: shrinkChild,
          ),
          AnimatedOpacity(
              duration: DelegateConfig.animationDurationValue,
              opacity: 1 - progress,
              child: child),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => shrinkHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
