//
//  AppDelegate.swift
//  GV24
//
//  Created by admin on 5/23/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import UserNotifications
import FirebaseMessaging
import GooglePlaces
import GoogleMaps
import Firebase
import FirebaseInstanceID
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate{
    var window: UIWindow?
    var isLogged = false
    var isNotification:Bool = false
    let googleMapsApiKey = "AIzaSyCNhv23qd9NWrFOalVL3u6w241HdJk7d-w"
    var navi:UINavigationController?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        DGLocalization.sharedInstance.startLocalization()
        GMSServices.provideAPIKey(googleMapsApiKey)
        GMSPlacesClient.provideAPIKey(googleMapsApiKey)
        window = UIWindow(frame: UIScreen.main.bounds)
        if UserDefaultHelper.isLogin {
            navi = UINavigationController(rootViewController: HomeViewDisplayController())
        }else{
            navi = UINavigationController(rootViewController: LoginView())
        }
        window?.rootViewController = navi
       // UINavigationBar.appearance().titleTextAttributes = [ NSForegroundColorAttributeName:UIColor.black,NSFontAttributeName:UIFont(name:"SFUIText-Bold", size: sizeSeven)]
    
        
        UINavigationBar.appearance().tintColor = UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1)
        UINavigationBar.appearance().backgroundColor = .white
        UIApplication.shared.statusBarView?.backgroundColor = .white
        FirebaseApp.configure()
        registerForRemoteNotification()
        application.registerForRemoteNotifications()
        if isNotification == true {
            isNotification = false
            let navi = UINavigationController(rootViewController: HomeViewDisplayController())
            window?.rootViewController = navi
            let managerController = RecievedController(nibName: "RecievedController", bundle: nil)
            navi.pushViewController(managerController, animated: true)
        }
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
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if ( application.applicationState == .inactive || application.applicationState == .background){
            guard let window = UIApplication.shared.keyWindow else{return}
            let navi = UINavigationController(rootViewController: HomeViewDisplayController())
            window.rootViewController = navi
            let managerController = ManageViewController(nibName: "ManageViewController", bundle: nil)
            navi.pushViewController(managerController, animated: true)
            
        }
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
        InstanceID.instanceID().setAPNSToken(deviceToken, type: .sandbox)
        print("APNs device token: \(deviceToken.hexString())")
        print("firebase token string: \(InstanceID.instanceID().token() ?? "")")
        guard let firebaseToken = InstanceID.instanceID().token() else {return}
        UserDefaultHelper.setString(string: firebaseToken)
    }
    
    // Called when APNs failed to register the device for push notifications
    private func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }
}
extension AppDelegate:UNUserNotificationCenterDelegate{
    //Called when a notification is delivered to a foreground app.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("User Info = ",notification.request.content.userInfo)
        guard let status = notification.request.content.userInfo["status"] as? String else {return}
        guard let billID = notification.request.content.userInfo["bill"] as? String else {return}
        switch status {
        case "1":
            print("## status = 1")
        case "5":
            print("## status = 5")
            guard let window = UIApplication.shared.keyWindow else{return}
            let navi = UINavigationController(rootViewController: HomeViewDisplayController())
            window.rootViewController = navi
            let managerController = RecievedController(nibName: "RecievedController", bundle: nil)
            navi.pushViewController(managerController, animated: true)
            break
        case "6":
            print("## status = 6")
            isNotification = true
            guard let window = UIApplication.shared.keyWindow else{return}
            let navi = UINavigationController(rootViewController: HomeViewDisplayController())
            window.rootViewController = navi
            let managerController = RecievedController(nibName: "RecievedController", bundle: nil)
            navi.pushViewController(managerController, animated: true)
            break
            case "9":
                print("## status = 9")
            guard let window = UIApplication.shared.keyWindow else{return}
            let navi = UINavigationController(rootViewController: HomeViewDisplayController())
            window.rootViewController = navi
            let managerController = ManagerHistoryViewController(nibName: "ManagerHistoryViewController", bundle: nil)
                managerController.isDisplayAlert = true
                managerController.billId = billID
            navi.pushViewController(managerController, animated: true)
            break
        default:
            break
        }
        completionHandler([.alert, .badge, .sound])
        
    }
    
    //Called to let your app know which action was selected by the user for a given notification.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User Info = ",response.notification.request.content.userInfo)
        guard let param = response.notification.request.content.userInfo["status"] as? String else {return}
        guard let billID = response.notification.request.content.userInfo["bill"] as? String else {return}
        
//        
//        var business: pushnotifi
//        switch param {
//        case "1":
//            business = OpenHomeBusiness(userinfo)
//        default:
//            <#code#>
//        }
//        
//        business.execute()
//
        switch param {
        case "1":
            print("## status = 1")
            case "5":
                let navi = UINavigationController(rootViewController: HomeViewDisplayController())
                window?.rootViewController = navi
                let managerController = RecievedController(nibName: "RecievedController", bundle: nil)
                navi.pushViewController(managerController, animated: true)
            case "6":
                print("## status = 6")
                isNotification = true
                let navi = UINavigationController(rootViewController: HomeViewDisplayController())
                window?.rootViewController = navi
                let managerController = RecievedController(nibName: "RecievedController", bundle: nil)
                navi.pushViewController(managerController, animated: true)
            break
            case "9":
                print("## status = 9")
                let navi = UINavigationController(rootViewController: HomeViewDisplayController())
                window?.rootViewController = navi
                let managerController = ManagerHistoryViewController(nibName: "ManagerHistoryViewController", bundle: nil)
                managerController.isDisplayAlert = true
                managerController.billId = billID
                navi.pushViewController(managerController, animated: true)
            break
        default:
            break
        }
        completionHandler()
    }
}
extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
