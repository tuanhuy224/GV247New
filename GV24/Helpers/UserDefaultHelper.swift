//
//  UserDefaultHelper.swift
//  Glam.HieuDaiKy
//
//  Created by DaiVP on 5/26/16.
//
//

import Foundation

class UserDefaultHelper {
    
    static let userDefault:UserDefaults = UserDefaults.standard
    
    class func setValueForKey(_ value:String?, key:String){
        userDefault.set(value, forKey: key)
        userDefault.synchronize()
    }
    
    class func getValueForKey(_ key:String, defaultValue:String?) -> String{
        if let value = userDefault.value(forKey: key) as? String{
            return value
        }
        
        guard let defaultValue = defaultValue else {return ""}
        return defaultValue
    }
    
    class func getUserID() -> String{
        return getValueForKey(Constants.kUserId, defaultValue: nil)
    }
    
    class func getUserToken() -> String {
        return getValueForKey(Constants.kUserToken, defaultValue: nil)
    }
    
    class func clearUserDefault() {
        setValueForKey("", key: Constants.kUserId)
        setValueForKey("", key: Constants.kUserToken)
    }
    
}
