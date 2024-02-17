part of alghwalbi_core;

abstract class AppState<T extends StatefulWidget, C extends BaseController>
    extends State<T> {
  late C controller;

  C createController();

  @override
  initState() {
    controller = createController();
    super.initState();
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }
}
