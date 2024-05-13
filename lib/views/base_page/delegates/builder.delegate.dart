part of alghwalbi_core;

class BuilderDelegate extends SliverPersistentHeaderDelegate {
  final Widget Function(double) builder;
  final double elevation;
  final double maxHeight;
  final double minHeight;
  final Color? color;
  BuilderDelegate({
    required this.builder,
    required this.maxHeight,
    required this.minHeight,
    this.color,
    this.elevation = 0.0,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var progress = 1.0;
    try {
      progress = 1 - (min(shrinkOffset, minExtent) / minExtent);
    } catch (_) {}
    return Material(
      color: color,
      elevation: DelegateConfig.elevationValue(progress, elevation),
      child: builder(progress),
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
