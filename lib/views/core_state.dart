part of alghwalbi_core;

abstract class CoreStatefulWidget<C extends CoreController>
    extends StatefulWidget {
  final C? controller;

  /// you can use this id to refresh/setState the widget by the stateID
  /// when null then use the statefull class name
  final String? stateId;
  CoreStatefulWidget(this.controller, {super.key, this.stateId}) {
    if (beamer() != null && BeamerService.routes.containsKey(beamer()!.path)) {
      debugPrint(
          'XXXXXX you need to register the beamer function in BeamerServer.pages');
    }
  }

  CoreBeamerPageRoute? beamer();
}

abstract class CoreState<T extends CoreStatefulWidget, C extends CoreController>
    extends State<T> with LifecycleAware, LifecycleMixin {
  late C controller;

  /// Whether this [State] object is displayed on the screen.
  bool isDislplayed = false;
  Future<void> onDisplayed(Widget page, bool isDislplayed) async {
    controller.onDisplayed(widget, isDislplayed);
  }

  C createController();

  @override
  void onLifecycleEvent(LifecycleEvent event) {
    if (event == LifecycleEvent.active) {
      controller.state = this;
      isDislplayed = true;
    } else {
      isDislplayed = false;
    }
    onDisplayed(widget, isDislplayed);
  }

  @override
  initState() {
    controller = createController();
    controller.setNewState(widget.stateId ?? widget.toString(), this);
    debugPrint('${widget.stateId} - Class name ${widget.runtimeType}');
    controller.init(widget);
    controller.initLate(widget).then((value) => controller.setState());
    super.initState();
  }

  @override
  dispose() {
    controller.dispose(widget);
    super.dispose();
  }
}
