//UserDefaultHelper
//  GV24
//
//  Created by HuyNguyen on 5/25/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit
enum gender {
    static let boy = "Nam"
    static let girl = "Nữ"
}
enum GlobalConstants {
    
    static let englishCode = "en"
    static let finnishLangCode = "vi"
}

class UserDefaultHelper {
    var key = "userLogin"
    
    static var isLogin : Bool{
        if UserDefaults.standard.value(forKey: "token") != nil{
            return true
        }
        return false
    }
    static func setSlider(slider:String){
    UserDefaults.standard.set(slider, forKey: "slider")
    UserDefaults.standard.synchronize()
    }
    static func getSlider() -> String?{
    return UserDefaults.standard.value(forKey: "slider") as? String
    }
    static func setUserDefault(token:String, user:User?){
        let dic = [
                    "idUser":user!.id!,
                    "userName":user!.username!,
                   "email":user!.email!,
                   "phone":user!.phone!,
                   "avatarUrl": user!.image!,
                   "addressName":(user?.address?.name)!,
                   "gender":user!.gender!,
                    "lat":(user?.address?.location?.latitude)!,
                    "lng":(user?.address?.location?.longitude)!
                   ] as Dictionary<String, Any>
        UserDefaults.standard.set(dic, forKey: "user")
        UserDefaults.standard.set(token, forKey: "token")
        UserDefaults.standard.synchronize()
    }
    class func getToken() -> String? {
        return UserDefaults.standard.object(forKey: "token") as? String
    }
    static var currentUser : User? {
            if isLogin {
                let userDic = UserDefaults.standard.value(forKey: "user") as! Dictionary<String, Any>
                let user = User()
                user.id = userDic["idUser"] as? String
                user.username = userDic["userName"] as? String
                user.email = userDic["email"] as? String
                user.phone = userDic["phone"] as? String
                user.image = userDic["avatarUrl"] as? String
                let address = Address()
                address.name = userDic["addressName"] as? String
                user.lat = (userDic["lat"] as? Double)!
                user.lng = (userDic["lng"] as? Double)!
                user.gender = userDic["gender"] as? Int
                return user
            }
            return nil
    }
    static func setUserOwner(user:Owner?){
        let dicOwner = [
            "idOwner":user!.id!,
            "username":user!.username!,
            "email":user!.email!,
            "phone":user!.phone!,
            "image": user!.image!,
            "addressName":(user!.address?.name!)!,
            "gender":user!.gender!,
            "latOwner":(user!.address?.location?.latitude)!,
            "lngOwner":(user!.address?.location?.longitude)!
            ] as Dictionary<String, Any>
        UserDefaults.standard.set(dicOwner, forKey: "userOwner")
        UserDefaults.standard.synchronize()
    }
    static var ownerUser : Owner? {
            let userOwner = UserDefaults.standard.value(forKey: "userOwner") as? [String:Any]
            let user = Owner()
            user.id = userOwner?["idOwner"] as? String
            user.username = userOwner?["username"] as? String
            user.email = userOwner?["email"] as? String
            user.phone = userOwner?["phone"] as? String
            user.image = userOwner?["image"] as? String
            let address = Address()
            address.name = userOwner?["addressName"] as? String
            user.name = userOwner?["addressName"] as? String
            user.latOwner = userOwner?["latOwner"] as? Double
            user.lngOwner = userOwner?["lngOwner"] as? Double
            user.gender = userOwner?["gender"] as? Int
            return user
    }
    
    static func setString(string:String?){
        UserDefaults.standard.set(string, forKey: "string")
        UserDefaults.standard.synchronize()
    }
    static func getString() -> String? {
        return UserDefaults.standard.value(forKey: "string") as? String
    }

}
