part of alghwalbi_core;

class CoreHeader {
  final CoreHeaderType type;
  final double? scaleX;
  final double? scaleY;
  final Offset? offset;
  final Widget? child;
  final bool? floating;
  final bool? pinned;
  final Widget? shrinkChild;

  /// builder function taking a progress number on the parameter,
  /// progress value starts from 1 and move to 0 when it's totally shrunk
  final Widget Function(double)? builder;
  final Alignment? alignment;
  final double maxHeight;
  final double minHeight;
  final double elevation;
  final Color? color;
  final SliverPersistentHeaderDelegate delegate;
  CoreHeader.builder({
    Key? key,
    required this.builder,
    this.floating,
    this.pinned,
    this.color,
    required this.maxHeight,
    required this.minHeight,
    this.elevation = 0.0,
  })  : type = CoreHeaderType.feedOut,
        scaleX = null,
        scaleY = null,
        offset = null,
        child = null,
        shrinkChild = null,
        alignment = null,
        delegate = BuilderDelegate(
          builder: builder!,
          elevation: elevation,
          color: color,
          minHeight: minHeight,
          maxHeight: maxHeight,
        );
  CoreHeader.fixed({
    Key? key,
    required this.child,
    this.floating,
    this.pinned,
    this.color,
    required double height,
    this.elevation = 0.0,
  })  : type = CoreHeaderType.feedOut,
        scaleX = null,
        scaleY = null,
        offset = null,
        shrinkChild = null,
        minHeight = height,
        maxHeight = height,
        alignment = null,
        builder = null,
        delegate = FixedDelegate(
          child: child!,
          height: height,
          color: color,
          elevation: elevation,
        );
  CoreHeader.feedOut({
    Key? key,
    required this.child,
    this.floating,
    this.pinned,
    this.color,
    required double height,
    this.elevation = 0.0,
  })  : type = CoreHeaderType.feedOut,
        scaleX = null,
        scaleY = null,
        offset = null,
        builder = null,
        shrinkChild = null,
        minHeight = height,
        maxHeight = height,
        alignment = null,
        delegate = FadeOutDelegate(
          child: child!,
          height: height,
          elevation: elevation,
          color: color,
        );

  CoreHeader.transform({
    Key? key,
    required this.child,
    required this.shrinkChild,
    this.floating,
    this.pinned,
    this.color,
    required double expandedHeight,
    required double shrinkHeight,
    this.elevation = 0.0,
  })  : type = CoreHeaderType.transform,
        builder = null,
        scaleX = null,
        scaleY = null,
        offset = null,
        minHeight = expandedHeight,
        maxHeight = shrinkHeight,
        alignment = null,
        delegate = TransformDelegate(
          child: child!,
          shrinkChild: shrinkChild!,
          expandedHeight: expandedHeight,
          shrinkHeight: shrinkHeight,
          color: color,
          elevation: elevation,
        );

  CoreHeader.scale({
    Key? key,
    required this.scaleX,
    required this.scaleY,
    required this.child,
    this.alignment = Alignment.topLeft,
    required this.maxHeight,
    required this.minHeight,
    this.floating,
    this.pinned,
    this.color,
    this.elevation = 0.0,
  })  : type = CoreHeaderType.scale,
        builder = null,
        offset = null,
        shrinkChild = null,
        delegate = ScaleDelegate(
          elevation: elevation,
          child: child!,
          scaleX: scaleX!,
          scaleY: scaleY!,
          alignment: alignment!,
          maxHeight: maxHeight,
          minHeight: minHeight,
          color: color,
        );

  CoreHeader.transition({
    Key? key,
    required this.offset,
    required this.child,
    required this.maxHeight,
    required this.minHeight,
    this.floating,
    this.pinned,
    this.color,
    this.elevation = 0.0,
  })  : type = CoreHeaderType.transition,
        builder = null,
        scaleX = null,
        scaleY = null,
        shrinkChild = null,
        alignment = null,
        delegate = TransitionDelegate(
            child: child!, offset: offset!, color: color, elevation: elevation);
}

enum CoreHeaderType { fixed, feedOut, transition, scale, transform }
