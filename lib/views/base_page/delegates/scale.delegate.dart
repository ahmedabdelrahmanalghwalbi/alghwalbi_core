part of alghwalbi_core;

class ScaleDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double scaleX;
  final double scaleY;
  final Alignment alignment;
  final double maxHeight;
  final double minHeight;
  final double elevation;
  final Color? color;
  const ScaleDelegate({
    required this.child,
    required this.scaleX,
    required this.scaleY,
    this.elevation = 0.0,
    required this.alignment,
    required this.minHeight,
    required this.maxHeight,
    this.color,
  }) : assert(scaleX <= 1 && scaleY <= 1,
            "'scaleX' and 'scaleY' must be less than 1");
  @override
  Widget build(
      BuildContext context, double shrunkOffset, bool overlapsContent) {
    final progress = min(shrunkOffset, minExtent) / minExtent;
    return Material(
      color: color,
      elevation: DelegateConfig.elevationValue(progress, elevation),
      child: Transform.scale(
        alignment: alignment,
        scaleX: ((1 - progress) * (1 - scaleX)) + scaleX,
        scaleY: ((1 - progress) * (1 - scaleY)) + scaleY,
        child: child,
      ),
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
