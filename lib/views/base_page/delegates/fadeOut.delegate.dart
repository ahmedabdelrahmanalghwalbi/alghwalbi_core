part of alghwalbi_core;

class FadeOutDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double elevation;
  final double height;
  final Color? color;
  const FadeOutDelegate({
    required this.child,
    required this.height,
    this.color,
    this.elevation = 0.0,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = max(1 - (shrinkOffset / height * 2), 0).toDouble();
    return Material(
      color: color,
      elevation: DelegateConfig.elevationValue(progress, elevation),
      child: Opacity(
        opacity: progress,
        child: child,
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
