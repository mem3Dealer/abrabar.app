import UIKit
import Flutter
import FirebaseCore
import FirebaseMessaging
import Branch

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  // let window: UIWindow?
  let gcmMessageIDKey = "gcm.Message_ID"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

       // if you are using the TEST key
  Branch.setUseTestBranchKey(false)
  // listener for Branch Deep Link data
  Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
       // do stuff with deep link data (nav to page, display content, etc)
      print(params as? [String: AnyObject] ?? {})
      }

      FirebaseApp.configure()
      if #available(iOS 10.0, *) {
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
      } else {
        let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
      }

      application.registerForRemoteNotifications()

      Messaging.messaging().delegate = self
   
    GeneratedPluginRegistrant.register (with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                       -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

       // handler for Push Notifications
        Branch.getInstance().handlePushNotification(userInfo)

      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }

}

extension AppDelegate : MessagingDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }

}
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    return Branch.getInstance().application(app, open: url, options: options)
}
func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
  // handler for Universal Links
    return Branch.getInstance().continue(userActivity)
}

func application(_ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
  Messaging.messaging().apnsToken = deviceToken;
}
 

func userNotificationCenter(_ center: UNUserNotificationCenter,
                            willPresent notification: UNNotification,
  withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
  let userInfo = notification.request.content.userInfo

  Messaging.messaging().appDidReceiveMessage(userInfo)

  // Change this to your preferred presentation option
  completionHandler([[.alert, .sound]])
}

func userNotificationCenter(_ center: UNUserNotificationCenter,
                            didReceive response: UNNotificationResponse,
                            withCompletionHandler completionHandler: @escaping () -> Void) {
  let userInfo = response.notification.request.content.userInfo

  Messaging.messaging().appDidReceiveMessage(userInfo)

  completionHandler()
}

func application(_ application: UIApplication,
didReceiveRemoteNotification userInfo: [AnyHashable : Any],
   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
  Messaging.messaging().appDidReceiveMessage(userInfo)
  completionHandler(.noData)
}
