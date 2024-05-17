part of alghwalbi_core;

///  A service to handle push notifications using Firebase Messaging.
///  This class manages initialization, token handling, and notification reception.
///  Note :- Android: Background notifications are handled by the system's notification manager.
///  Android Configuration:-
/// ---------------------- In android/app/src/main/AndroidManifest.xml
///
/// <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
/// <application>
///   <service
///     android:name="io.flutter.plugins.firebasemessaging.FirebaseMessagingService"
///     android:exported="true">
///     <intent-filter>
///       <action android:name="com.google.firebase.MESSAGING_EVENT"/>
///     </intent-filter>
///   </service>
/// </application>
/// Note:- iOS: Background notifications require additional setup with content-available and background modes.
/// iOS Configuration
/// ----------------- In ios/Runner/Info.plist
/// <key>UIBackgroundModes</key>
/// <array>
///   <string>fetch</string>
///   <string>remote-notification</string>
/// </array>
class PushNotificationService {
  static FirebaseMessaging? fcm;
  static bool _isInitialized = false;
  static bool _isTokenInit = false;
  static int _tries = 0;

  /// Initializes the push notification service.
  /// Sets up listeners for different states of the application.
  static Future<void> init(
      {required String apiUrlThatReciveUserToken,
      Future<void> Function({required dynamic payload})?
          methodThatTakePayloadDataToPerformSomeFunctionalitiesBeforeShowingNotificationOnAppScreen,
      Future<void> Function({required dynamic payload})?
          callbackWhenHandelOnNotificationCliked,
      Map<String, dynamic>? requestBody}) async {
    if (_isInitialized) {
      await _sendToken(
          apiUrlThatReciveUserToken: apiUrlThatReciveUserToken,
          requestBody: requestBody);
      return;
    }

    fcm = FirebaseMessaging.instance;

    // Set foreground notification options
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Listener for messages received while the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      handleOnNotificationReceived(
          message: message,
          isForeground: true,
          methodThatTakePayloadDataToPerformSomeFunctionalitiesBeforeShowingNotificationOnAppScreen:
              methodThatTakePayloadDataToPerformSomeFunctionalitiesBeforeShowingNotificationOnAppScreen,
          callbackWhenHandelOnNotificationCliked:
              callbackWhenHandelOnNotificationCliked);
    });

    // Listener for messages received when the app is opened from the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      handleOnNotificationReceived(
          message: message,
          isForeground: false,
          methodThatTakePayloadDataToPerformSomeFunctionalitiesBeforeShowingNotificationOnAppScreen:
              null,
          callbackWhenHandelOnNotificationCliked: null);
    });

    // Background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    try {
      await _sendToken(
          apiUrlThatReciveUserToken: apiUrlThatReciveUserToken,
          requestBody: requestBody);
      _isInitialized = true;
    } catch (e) {
      debugPrint(
          'Exception during push notification initialization: ${e.toString()}');
      _isInitialized = true;
      if (_tries <= 20) {
        await init(
            apiUrlThatReciveUserToken: apiUrlThatReciveUserToken,
            requestBody: requestBody);
        _tries++;
      }
    }
  }

  /// Resets the token initialization state. Used when the user logs out.
  static void onPushNotificationClosed() async {
    _isTokenInit = false;
    await FirebaseMessaging.instance.deleteToken();
  }

  /// Sends the FCM token to the server.
  /// Ensures the token is sent only once during the session.
  static Future<void> _sendToken(
      {required String apiUrlThatReciveUserToken,
      Map<String, dynamic>? requestBody}) async {
    if (_isTokenInit) return;
    var userToken = await fcm?.getToken();

    var result = await ApiService().httpPost(
        apiUrlThatReciveUserToken,
        requestBody ??
            {
              'token': userToken,
              'deviceType': kIsWeb ? 'web' : Platform.operatingSystem
            });

    debugPrint('New Token: $userToken, token Status: ${result.success}');
    _isTokenInit = true;
  }

  /// Handles background messages.
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    debugPrint('A background message just showed up: ${message.messageId}');
  }

  /// Handles notifications received in different states of the application.
  /// [methodThatTakePayloadDataToPerformSomeFunctionalitiesBeforeShowingNotificationOnAppScreen] propert to perform method That Take Payload Data from Recived Message To Perform Some Functionalities Before Showing Notification On App Screen
  /// for example :
  /// if (message.data['payload'] != null) {
  ///     payLoad = jsonDecode(message.data['payload']);
  ///     try {
  ///       switch (payLoad["type"].toString()) {
  ///         case 'CustomerBalanceSysTransaction':
  ///           if (AppConfigService.isCompany) {
  ///             var location = BeamerService.routerDelegate.currentBeamLocation
  ///                 .history.last.routeInformation.location;
  ///             if (location == '/subscriptions') {
  ///             CustomerValueNotifier.onChangingValue();
  ///             }
  ///           }
  ///           break;
  ///         default:
  ///       }
  ///     } catch (e) {
  ///       debugPrint('error ${e}');
  ///     }
  //.   }
  static void handleOnNotificationReceived(
      {required RemoteMessage message,
      Future<void> Function({required dynamic payload})?
          methodThatTakePayloadDataToPerformSomeFunctionalitiesBeforeShowingNotificationOnAppScreen,
      bool isForeground = false,
      Future<void> Function({required dynamic payload})?
          callbackWhenHandelOnNotificationCliked}) async {
    if (isForeground) {
      RemoteNotification? notification = message.notification;
      dynamic payload;
      if (message.data['payload'] != null) {
        payload = jsonDecode(message.data['payload']);
      }
      if (methodThatTakePayloadDataToPerformSomeFunctionalitiesBeforeShowingNotificationOnAppScreen !=
              null &&
          payload != null) {
        //callback function
        await methodThatTakePayloadDataToPerformSomeFunctionalitiesBeforeShowingNotificationOnAppScreen
            .call(payload: payload);
      }
      //showing the notification on the app screen (foreground)
      if (notification != null) {
        TimeoutMessage.show(
            title: notification.title ?? '',
            logoWithWihteText: CoreApp.logoWithWihteText ?? '',
            message: notification.body,
            onClick: () => handleOnNotificationClicked(
                payload: payload,
                callbackWhenHandelOnNotificationCliked:
                    callbackWhenHandelOnNotificationCliked));
      }
    }
  }

  /// Handles the callback action function when a notification is clicked.
  /// try {
  ///   await callbackWhenHandelOnNotificationCliked.call(payload: payload);
  ///   switch (payload["type"].toString()) {
  ///     case 'NewChatMessage':
  ///       // Implement your logic to navigate to the chat page
  ///       break;
  ///     case 'OrderStatusChanged':
  ///       // Implement your logic to navigate to the order status page
  ///       break;
  ///     case 'OrderEdited':
  ///       // Implement your logic to navigate to the order edit page
  ///       break;
  ///     default:
  ///       debugPrint('Unknown notification type: ${payload["type"]}');
  ///   }
  /// } catch (e) {
  ///   debugPrint('Error handling notification click: $e');
  /// }
  static void handleOnNotificationClicked(
      {required dynamic payload,
      Future<void> Function({required dynamic payload})?
          callbackWhenHandelOnNotificationCliked}) async {
    try {
      await callbackWhenHandelOnNotificationCliked?.call(payload: payload);
    } catch (e) {
      debugPrint('Error handling notification click: ${e.toString()}');
    }
  }

  /// Checks for notifications if the app was killed and then opened.
  static void checkNotificationOnKilledApp(
      {Future<void> Function({required dynamic payload})?
          callbackWhenHandelOnNotificationCliked}) async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      handleOnNotificationReceived(
          message: message,
          callbackWhenHandelOnNotificationCliked:
              callbackWhenHandelOnNotificationCliked);
    }
  }
}
