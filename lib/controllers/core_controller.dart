part of alghwalbi_core;

abstract class CoreController {
  /// busy felid
  bool busy = false;

  Map<String, List<State>> states = {};

  void setNewState(String stateId, State state) {
    if (states[stateId] == null) {
      states[stateId] = [state];
    } else {
      states[stateId]!.add(state);
    }
  }

  /// refresh all statefull widgets assigned to this controller
  void setStateAll(VoidCallback fn) {
    for (var sList in states.values) {
      for (var s in sList) {
        if (s.mounted) {
          s.setState(fn);
        }
      }
    }
  }

  /// the stateId is the statefull class name or the specified value
  void setStateById(String stateId, VoidCallback fn) {
    for (var s in (states[stateId] ?? [])) {
      if (s.mounted) {
        s.setState(fn);
      }
    }
  }

  /// on dispose
  void dispose(Widget page) {}

  /// executed automaticly on initState,
  /// built to initlize the NOT nullable properties like TextEditorController
  /// you can use somthing like
  /// if (page is EmployeeListPage) {
  ///     employees = [];
  ///  } else if (page is EmployeeFormPage) {
  ///     employeeName = TextEditingController();
  ///  }
  void init(Widget page);

  /// executed automaticly on initState
  /// built to initiate properties from server
  /// the framwork is calling setState automatclly after this function
  /// you can use somthing like
  /// if (page is EmployeeListPage) {
  ///     employees = await LoadFromDb();
  ///  } else if (page is EmployeeFormPage) {
  ///     employeeName = await LoadName();
  ///  }
  Future<void> initLate(Widget page);

  /// fire the function after the page is mounted
  ///
  /// [Alert] it can be fired multiple times
  Future<void> onDisplayed(Widget page, bool isDisplayed) async {}

  /// the state
  State? state;

  BuildContext? _context;

  /// the local function for setState
  void Function(VoidCallback)? setStateFunction;

  /// buld context for the controller
  BuildContext get context {
    return state?.context ?? _context ?? CoreApp.appGlobalkey.currentContext!;
  }

  /// navigate to other page
  navigateTo(creator,
      [bool replacment = false,
      AnimationTypes animationType = AnimationTypes.slideLeft]) {
    return AppNavigator.navigateTo(context, creator,
        replacment: replacment, animationType: animationType);
  }

  /// setState
  setState([void Function()? fn]) {
    if (setStateFunction != null) {
      setStateFunction?.call(() {});
    }
    // ignore: invalid_use_of_protected_member
    else if (state != null && (state?.mounted ?? false)) {
      state?.setState(fn ?? () {});
    }
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
