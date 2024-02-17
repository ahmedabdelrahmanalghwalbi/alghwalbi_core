part of alghwalbi_core;

abstract class BaseController {
  /// bust feild
  bool busy = false;

  /// on dispose
  void dispose() {}

  /// the state
  State? state;

  BuildContext? _context;

  /// the local function for setState
  void Function(VoidCallback)? setStateFunction;

  /// buld context for the controller
  BuildContext get context {
    return state?.context ?? _context ?? CoreApp.appGlobalkey.currentContext!;
  }

  /// base controller
  BaseController(this.state, {buildContext})
      : assert(state != null || buildContext != null) {
    _context = buildContext;
  }

  /// navigate to other page
  navigateTo(creator,
      [bool replacment = false,
      AnimationTypes animationType = AnimationTypes.slideLeft]) {
    return AppNavigator.navigateTo(context, creator,
        replacment: replacment, animationType: animationType);
  }

  /// setState
  setState() {
    if (setStateFunction != null) {
      setStateFunction?.call(() {});
    }

    // ignore: invalid_use_of_protected_member
    else if (state != null && (state?.mounted ?? false)) {
      state?.setState(() {});
    }
    ;
  }

  /// show message
  Future<dynamic> showMessage(
    String title,
    MessageType type, {
    String heroTag = 'submit_button',
    String? message,
    String? imageAssert,
    String? exceptionText,
  }) async {
    if (busy) return;
    busy = true;
    await AppNavigator.showMessage(context, title, type,
        message: message,
        imageAssert: imageAssert,
        exceptionText: exceptionText);
    busy = false;
  }

  /// confirm message with Yes and No buttons
  Future<bool> confirmMessage(String title,
      {String? message, String? imageAssert}) async {
    if (busy) return false;
    busy = true;
    var result = await AppNavigator.confirmMessage(context, title,
        message: message, imageAssert: imageAssert);
    busy = false;
    return result;
  }

  /// show loading popup
  setLoading() async {
    if (busy) return;
    busy = true;
    await AppNavigator.showLoading(context);
    busy = false;
  }

  /// dismiss the loading popup
  setResume([bool success = true]) {
    if (!busy) return;
    busy = false;
    AppNavigator.resume(success);
    //Navigator.of(context, rootNavigator: true).pop();
  }

  /// exec haptic feedback
  Future<void> hapticFeedback({bool heavy = true}) {
    return AppNavigator.hapticFeedback(heavy: heavy);
  }
}
