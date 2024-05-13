part of alghwalbi_core;

class CoreMobileScaffold extends StatelessWidget {
  final List<CoreHeader>? headers;
  final List<Widget>? children;
  final Widget? body;
  final Widget Function(BuildContext, int)? childrenBuilder;
  final int? childrenCount;
  final SliverAppBar? sliverAppBar;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final ScrollController controller;
  final Duration? animationDuration;
  const CoreMobileScaffold({
    super.key,
    this.headers,
    this.children,
    this.body,
    this.childrenBuilder,
    this.childrenCount,
    this.sliverAppBar,
    this.animationDuration,
    required this.controller,
    PreferredSizeWidget? appBar,
    this.floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    FloatingActionButtonAnimator? floatingActionButtonAnimator,
    List<Widget>? persistentFooterButtons,
    Widget? drawer,
    AlignmentDirectional? persistentFooterAlignment,
    void Function(bool)? onDrawerChanged,
    Widget? endDrawer,
    void Function(bool)? onEndDrawerChanged,
    Widget? bottomNavigationBar,
    Widget? bottomSheet,
    this.backgroundColor,
    bool? resizeToAvoidBottomInset,
    bool primary = true,
    DragStartBehavior drawerDragStartBehavior = DragStartBehavior.start,
    bool extendBody = false,
    bool extendBodyBehindAppBar = false,
    Color? drawerScrimColor,
    bool drawerEnableOpenDragGesture = true,
    double? drawerEdgeDragWidth,
    bool endDrawerEnableOpenDragGesture = true,
    String? restorationId,
  }) : assert(body != null || children != null || childrenBuilder != null,
            "body or childrenBuilder or children cannot be null");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      backgroundColor: backgroundColor,
      key: key,
      // appBar: appBar,
      // floatingActionButton: floatingActionButton,
      // floatingActionButtonLocation: floatingActionButtonLocation,
      // floatingActionButtonAnimator: floatingActionButtonAnimator,
      // persistentFooterButtons: persistentFooterButtons,
      // persistentFooterAlignment:
      //     persistentFooterAlignment ?? AlignmentDirectional.centerEnd,
      // drawer: drawer,
      // onDrawerChanged: onDrawerChanged,
      // endDrawer: endDrawer,
      // onEndDrawerChanged: onEndDrawerChanged,
      // bottomNavigationBar: bottomNavigationBar,
      // bottomSheet: bottomSheet,
      // backgroundColor: backgroundColor,
      // resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      // primary: primary,
      // drawerDragStartBehavior: drawerDragStartBehavior,
      // extendBody: extendBody,
      // extendBodyBehindAppBar: extendBodyBehindAppBar,
      // drawerScrimColor: drawerScrimColor,
      // drawerEdgeDragWidth: drawerEdgeDragWidth,
      // drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
      // endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
      // restorationId: restorationId,
      body: CustomScrollView(
        controller: controller,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          if (sliverAppBar != null) sliverAppBar!,
          if (headers != null)
            ...headers!.map((e) => SliverPersistentHeader(
                  pinned: e.pinned ?? false,
                  floating: e.floating ?? false,
                  delegate: e.delegate,
                )),
          body ??
              (animationDuration == null
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate(
                      childrenBuilder ??
                          (children != null
                              ? ((_, i) => children![i])
                              : (_, i) => const SizedBox()),
                      childCount: childrenCount,
                    ))
                  : animation.LiveSliverList(
                      controller: controller,
                      showItemInterval: Duration(
                          milliseconds:
                              (animationDuration!.inMilliseconds * 0.5)
                                  .toInt()),
                      showItemDuration: animationDuration!,
                      itemCount: childrenCount ?? children?.length ?? 0,
                      itemBuilder: (context, index, animation) {
                        return FadeTransition(
                            opacity: Tween<double>(
                              begin: 0,
                              end: 1,
                            ).animate(animation),
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, -1.1),
                                end: Offset.zero,
                              ).animate(animation),
                              child: (childrenBuilder ??
                                      (children != null
                                          ? ((_, i) => children![i])
                                          : (_, i) => const SizedBox()))
                                  .call(context, index),
                            ));
                      },
                    )),
        ],
      ),
    );
  }
}
