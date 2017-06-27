//
//  UserService.swift
//  gv24App
//
//  Created by Nguyen Duy Duong on 5/22/17.
//  Copyright © 2017 HBBs. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire

class UserService: APIService {

    static let sharedInstance = UserService()

    func logIn(userName : String, password: String,device_token:String, completion : @escaping ((User?, String?, String?)->())){
        let url = "https://yukotest123.herokuapp.com/vi/auth/maid/login"
        let params : Dictionary<String, String>? = ["username": userName, "password": password,"device_token":device_token]
        postMultipart(url: url, image: nil, name: nil, parameters: params!) { (jsonData, error) in
            if error == nil{
                let token = jsonData?["token"].string
                let user = User(json: (jsonData?["user"])!)
                completion(user,token,nil)
            
            }else{
                completion(nil, nil, error)
            }
        }
    }
    
    func register(info: Dictionary<String, String>, avatar: UIImage, completion : @escaping ((User?, String?, String?)->())){
        let url = "auth/register"
        postMultipart(url: url, image: avatar, name: "image", parameters: info) { (jsonData, error) in
            if error == nil{
                let token = jsonData?["token"].string
                let user = User(json: (jsonData?["user"])!)
                completion(user,token , nil)
            }else{
                completion(nil, nil, error)
            }
        }
    }
    
}
