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
import IQKeyboardManagerSwift
import BRYXBanner
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
        IQKeyboardManager.sharedManager().enable = true
        window = UIWindow(frame: UIScreen.main.bounds)
        if UserDefaultHelper.isLogin {
            let home = UINavigationController(rootViewController: HomeViewDisplayController())
            window?.rootViewController = home
            window?.makeKeyAndVisible()
        }else{
            let login = UINavigationController(rootViewController: LoginView())
            window?.rootViewController = login
            window?.makeKeyAndVisible()
        }
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName:fontSize.fontName(name: .light, size: sizeSix)], for: .normal)
        UINavigationBar.appearance().tintColor = AppColor.backButton
        UINavigationBar.appearance().backgroundColor = .white
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
            Messaging.messaging().delegate = self
                if error == nil{
                    DispatchQueue.main.async {
                        
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }else{
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
         UserDefaultHelper.setString(string: fcmToken)
    }
    
      
    // [START receive_message]
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      
      
        if ( application.applicationState == .inactive || application.applicationState == .background){
            guard let window = UIApplication.shared.keyWindow else{ return }
            let navi = UINavigationController(rootViewController: HomeViewDisplayController())
            window.rootViewController = navi
            let managerController = PageViewController()
            navi.pushViewController(managerController, animated: true)
            
        }else{
      
      }
    }
    // [END connect_to_fcm]
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    // [START disconnect_from_fcm
    func applicationDidEnterBackground(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = true
        print("Disconnected from FCM.")
    }

    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
        print("device token: \(deviceToken)")
        print("Messaging.messaging().apnsToken:\(String(describing: Messaging.messaging().apnsToken))")
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
        if let billID = notification.request.content.userInfo["bill"] as? String {
            guard let window = UIApplication.shared.keyWindow else{return}
            let navi = UINavigationController(rootViewController: HomeViewDisplayController())
            window.rootViewController = navi
            let managerController = ManagerHistoryViewController()
            managerController.isDisplayAlert = true
            managerController.billId = billID
            navi.pushViewController(managerController, animated: true)
        }
        let banner = Banner(title: "Image Notification", subtitle: "", image: UIImage(named: ""), backgroundColor: UIColor(red:48.00/255.0, green:174.0/255.0, blue:51.5/255.0, alpha:1.000))
        switch status {
        case "6":
          
          banner.dismissesOnTap = true
          banner.show(duration: 3.0)
            isNotification = true
            guard let window = UIApplication.shared.keyWindow else{return}
            let navi = UINavigationController(rootViewController: HomeViewDisplayController())
            window.rootViewController = navi
            let page = PageViewController()
            navi.pushViewController(page, animated: true)
            break
        case "99":
            banner.dismissesOnTap = true
            banner.show(duration: 3.0)
            guard let window = UIApplication.shared.keyWindow else{return}
            let navi = UINavigationController(rootViewController: HomeViewDisplayController())
            window.rootViewController = navi
            let page = PageViewController()
            navi.pushViewController(page, animated: true)
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
        if let billID = response.notification.request.content.userInfo["bill"] as? String {
            let navi = UINavigationController(rootViewController: HomeViewDisplayController())
            window?.rootViewController = navi
            let managerController = ManagerHistoryViewController(nibName:"ManagerHistoryViewController", bundle: nil)
            managerController.isDisplayAlert = true
            managerController.billId = billID
            navi.pushViewController(managerController, animated: true)
        }
        switch param {
        case "6":
                print("## status = 6")
                isNotification = true
                let navi = UINavigationController(rootViewController: HomeViewDisplayController())
                window?.rootViewController = navi
                let managerController = PageViewController()
                navi.pushViewController(managerController, animated: true)
            break
        case "99":

            guard let window = UIApplication.shared.keyWindow else{return}
            let navi = UINavigationController(rootViewController: HomeViewDisplayController())
            window.rootViewController = navi
            let managerController = PageViewController()
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
