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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var isLogged = false
    let googleMapsApiKey = "AIzaSyCNhv23qd9NWrFOalVL3u6w241HdJk7d-w"
    var navi:UINavigationController?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        DGLocalization.sharedInstance.startLocalization()
        GMSServices.provideAPIKey(googleMapsApiKey)
        if UserDefaultHelper.isLogin {
            navi = UINavigationController(rootViewController: HomeViewDisplayController())
        }else{
            navi = UINavigationController(rootViewController: LoginView())
        }
        window?.rootViewController = navi
        UINavigationBar.appearance().tintColor = UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1)]
        FirebaseApp.configure()
        let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
//        let token = Messaging.messaging().fcmToken
//        print("FCM token: \(token ?? "")")
        application.registerForRemoteNotifications()
        return true
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        print(userInfo)
    }
    private func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print(token)
//        for i in 0..<deviceToken.count {
//            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
//        }
        
        InstanceID.instanceID().setAPNSToken(deviceToken, type: .unknown)
        
        //print("tokenString: \(tokenString)")
    }
}
