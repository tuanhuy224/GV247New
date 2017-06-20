//
//  AppDelegate.swift
//  GV24
//
//  Created by admin on 5/23/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import GooglePlaces
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    var window: UIWindow?
    var isLogged = false
    let googleMapsApiKey = "AIzaSyCNhv23qd9NWrFOalVL3u6w241HdJk7d-w"
    var navi:UINavigationController?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        DGLocalization.sharedInstance.startLocalization()
        GMSServices.provideAPIKey(googleMapsApiKey)
        GMSPlacesClient.provideAPIKey(googleMapsApiKey)
        if UserDefaultHelper.isLogin {
            navi = UINavigationController(rootViewController: HomeViewDisplayController())
        }else{
            navi = UINavigationController(rootViewController: LoginView())
        }
        window?.rootViewController = navi
        UINavigationBar.appearance().tintColor = UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1)]
        FirebaseApp.configure()
        registerForRemoteNotification()
        application.registerForRemoteNotifications()
        return true
    }
    // MARK: - Check vesion IOS
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }else{
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    
    // [START receive_message]
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if ( application.applicationState == .inactive || application.applicationState == .background){
            guard let window = UIApplication.shared.keyWindow else{return}
            let navi = UINavigationController(rootViewController: HomeViewDisplayController())
            window.rootViewController = navi
        }
    }
    func tokenRefreshNotification(notification: NSNotification) {
        if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        connectToFcm()
    }
    func connectToFcm() {
        Messaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error!)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    // [END connect_to_fcm]
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        connectToFcm()
    }
    // [START disconnect_from_fcm]
    func applicationDidEnterBackground(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = true
        print("Disconnected from FCM.")
    }

    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        print("\(deviceToken)")
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        
        // Persist it in your backend in case it's new

        InstanceID.instanceID().setAPNSToken(deviceToken, type: .sandbox)
        InstanceID.instanceID().setAPNSToken(deviceToken, type: .prod)
        print("\(String(describing: InstanceID.instanceID().token()))")
    }
    
    // Called when APNs failed to register the device for push notifications
    private func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
}
extension AppDelegate:UNUserNotificationCenterDelegate{
    //Called when a notification is delivered to a foreground app.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("User Info = ",notification.request.content.userInfo)
        completionHandler([.alert, .badge, .sound])
    }
    
    //Called to let your app know which action was selected by the user for a given notification.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User Info = ",response.notification.request.content.userInfo)
        completionHandler()
    }
}

