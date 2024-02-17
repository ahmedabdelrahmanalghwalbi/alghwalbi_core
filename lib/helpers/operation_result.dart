part of alghwalbi_core;

class OperationResult<T> {
  bool success;
  T? data;
  String? message;
  Map<String, dynamic>? multiMessage;
  String? minVersion;
  String? lastVersion;
  String? innerError;
  String? errorCodeString;
  List<String>? features;

  /// the return type for all functions
  OperationResult(
      {this.success = false,
      this.data,
      this.message,
      this.multiMessage,
      this.errorCodeString,
      this.minVersion,
      this.lastVersion,
      this.innerError,
      this.features});

  /// show message with successful of field info
  Future<dynamic> showMessage(BuildContext context,
      [String? generalMessage]) async {
    if (message != null && (message?.isNotEmpty ?? false)) {
      return await AppNavigator.showMessage(context, message ?? '',
          success ? MessageType.success : MessageType.error);
    } else if (generalMessage != null && generalMessage.isNotEmpty) {
      return await AppNavigator.showMessage(context, generalMessage,
          success ? MessageType.success : MessageType.error);
    }
  }

  @override
  toString() {
    if (success == true) {
      return '>>>>>>>>>> Success, Message: $message Inner: $innerError';
    } else {
      return 'XXXXXXXXXX FAILED:  Message: $message  Inner: $innerError';
    }
  }
}
