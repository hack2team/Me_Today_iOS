import SwiftUI
import FirebaseCore
import FirebaseMessaging
import UserNotifications


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    // FCM setup
    UNUserNotificationCenter.current().delegate = self
    Messaging.messaging().delegate = self

    // Request notification authorization
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
        if let error = error {
            print("Notification permission error: \(error)")
        } else {
            print("Notification permission granted: \(granted)")
        }
    }

      application.registerForRemoteNotifications()

      // 🔔 로컬 알림 테스트 (2초 뒤 표시)
      pushNotification(title: "하루가 기다리고 있어요!", body: "오늘의 질문에 답변해보세요", seconds: 10, identifier: "PUSH_TEST")

      // 🔔 매일 22시에 알림 예약
      scheduleDailyNotification()

      return true
  }
}


@main
struct YourApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


  var body: some Scene {
    WindowGroup {
      NavigationView {
          TabbarView()
      }
    }
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM registration token: \(String(describing: fcmToken))")
        // You can send this token to your server if needed
    }
    // PushNotificationHelper.swfit > PushNotificationHelper
    func pushNotification(title: String, body: String, seconds: Double, identifier: String) {
        // 1️⃣ 알림 내용, 설정
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body

        // 2️⃣ 조건(시간, 반복)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)

        // 3️⃣ 요청
        let request = UNNotificationRequest(identifier: identifier,
                                            content: notificationContent,
                                            trigger: trigger)

        // 4️⃣ 알림 등록
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner]) //포그라운드 상태에서도 상단 알림이 뜨도록 completion에 전달
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    func scheduleDailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "하루가 기다리고 있어요!"
        content.body = "오늘의 질문에 답변해보세요 🌙"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 22
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(
            identifier: "DAILY_REMINDER",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("⛔️ Daily notification scheduling failed:", error)
            } else {
                print("✅ Daily notification scheduled for 22:00")
            }
        }
    }
}
