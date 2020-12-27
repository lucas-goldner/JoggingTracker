//
//  AppDelegate.swift
//  JoggingTracker
//
//  Created by Lucas Goldner on 14.12.20.
//

import UIKit
import Firebase
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate, WebSocketConnectionDelegate {
    var isConnected = false
    var socket: NativeWebSocket?
    let gcmMessageIDKey = "gcmMessageIDKey"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let locationManager = LocationManager.shared
        locationManager.requestWhenInUseAuthorization()
        
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()


        
        Messaging.messaging().delegate = self
        // Override point for customization after application launch.
     

      
        return true
    }
    
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        var locManager = CLLocationManager()
        let regToken = UserDefaults.standard.object(forKey: "regToken") as? String
        locManager.requestWhenInUseAuthorization()
        var currentLocation: CLLocation!
        let currentUser = (Auth.auth().currentUser?.uid)!
        if
           CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
           CLLocationManager.authorizationStatus() ==  .authorizedAlways
        {
            currentLocation = locManager.location
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
            socket = NativeWebSocket(url: URL(string: "ws://localhost:1337")!, autoConnect: true)
            socket?.delegate = self
            socket?.send(text: "Locasione:"+String(currentLocation.coordinate.latitude)+"xN2.;Mlkd,0qD\"wPa_]Ne>}:uHlN9)jf"+"_"+String(currentLocation.coordinate.longitude)+"[>Susnt27hfINdn,xjU0&[6ejvZ_;\"P"+"...."+String(currentUser)+"fff"+regToken!)
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication){
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        var locManager = CLLocationManager()
        let regToken = UserDefaults.standard.object(forKey: "regToken") as? String
        locManager.requestWhenInUseAuthorization()
        var currentLocation: CLLocation!
        let currentUser = (Auth.auth().currentUser?.uid)!
        if
           CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
           CLLocationManager.authorizationStatus() ==  .authorizedAlways
        {
            currentLocation = locManager.location
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
            socket = NativeWebSocket(url: URL(string: "ws://localhost:1337")!, autoConnect: true)
            socket?.delegate = self
            socket?.send(text: "Locasione:"+String(currentLocation.coordinate.latitude)+"xN2.;Mlkd,0qD\"wPa_]Ne>}:uHlN9)jf"+"_"+String(currentLocation.coordinate.longitude)+"[>Susnt27hfINdn,xjU0&[6ejvZ_;\"P"+"...."+String(currentUser)+"fff"+regToken!)

        }
    }
    
    func onConnected(connection: WebSocketConnection) {
           print("Connected!")
       }
       
       func onDisconnected(connection: WebSocketConnection, error: Error?) {
           print("Disconnected!")
       }
       
       func onError(connection: WebSocketConnection, error: Error) {
           print("Error \(error)")
       }
       
       func onMessage(connection: WebSocketConnection, text: String) {
           DispatchQueue.main.async {
               //self.SendView.text.append("\(text)\n")
           }
       }

}


extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")
        UserDefaults.standard.set(fcmToken, forKey: "regToken")
        UserDefaults.standard.synchronize()
        print("registered token")
      let dataDict:[String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.alert, .sound]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    
    let application = UIApplication.shared
     
     if(application.applicationState == .active){
        
       print("user tapped the notification bar when the app is in foreground")
        if(userInfo.description.contains("Dein Freund ist am Joggen")) {
            print("Easy")
        }
     }
     
     if(application.applicationState == .inactive)
     {
       print("user tapped the notification bar when the app is in background")
     }

    completionHandler()
  }
}

