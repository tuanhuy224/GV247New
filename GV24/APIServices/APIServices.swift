//
//  APIServices.swift
//  GV24
//
//  Created by admin on 5/24/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


typealias ResponseCompletion = (JSON?, String?) -> ()
class APIService: NSObject {
    static let shared = APIService()
    func post(url : String, parameters: Parameters,header:[String:Any], completion: @escaping (ResponseCompletion)){
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let status = json["status"].bool
                if !status!{
                    guard let message = json["message"].string else{return}
                    completion(nil,message)
                }
                completion(json["data"],nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }

    func postReserve(url : String,method:HTTPMethod, parameters: Parameters,header:HTTPHeaders, completion: @escaping (ResponseCompletion)){
        Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let status = json["status"].bool
                if !status!{
                    guard let message = json["message"].string else{return}
                    completion(nil,message)
                }else{
                    completion(nil, String(describing: json["message"]))
                }
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    func deleteReserve(url : String,method:HTTPMethod, parameters: Parameters,header:HTTPHeaders, completion: @escaping (ResponseCompletion)){
        Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let status = json["status"].bool
                if !status!{
                    guard let message = json["message"].string else{return}
                    completion(nil,message)
                }else{
                    completion(nil, String(describing: json["message"]))
                }
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    func postMultipart(url : String, image: UIImage?, name: String?, parameters: Dictionary<String, String>, completion: @escaping (ResponseCompletion)){
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for (key,value) in parameters{
                    multipartFormData.append((value.data(using: .utf8))!, withName: key)
                }
        },
            to:url,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        let json = JSON(response.value as Any)
                        let status = json["status"].bool
                        if status == nil{
                        return
                        }
                        if status == false{
                            if let message = json["message"].string{
                                completion(nil, message)
                            }
                        }else{
                            completion(json["data"], nil)
                        }
                    }
                case .failure(let encodingError):
                    completion(nil, encodingError.localizedDescription)
                }
        })
    }
    func postLogin(url : String,method:HTTPMethod, parameters: [String:Any]?,encoding: JSONEncoding,header:[String:String], completion: @escaping (ResponseCompletion)){
        Alamofire.request(url, method:method,parameters: parameters, encoding: encoding, headers: header).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let status = json["status"].bool
                
                if !status!{
                    if let message = json["message"].string{
                        completion(nil, message)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getAllAround(url : String,method:HTTPMethod, parameters: Parameters,encoding: URLEncoding, completion: @escaping (ResponseCompletion)){
        Alamofire.request(url, method:method,parameters: parameters, encoding: encoding).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let status = json["status"].bool
                if !status!{
                    guard let message = json["message"].string else{return}
                    completion(nil,message)
                }
                completion(json["data"],nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    
    }
    
        
    func posturl(url:String,parameters:Parameters,completion: @escaping ((JSON?,Error?)->())){
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completion(json, nil)
                print("JSON: \(json)")
            case .failure(let error):
                completion(nil, error as? Error)
                print(error)
            }
        }
    }
    func getUrl(url:String,param:Parameters,header:HTTPHeaders,completion:@escaping(ResponseCompletion)) {
        Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default,headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let status = json["status"].bool
                if status == nil{return}
                if status == false{
                    if let message = json["message"].string{
                        completion(nil, message)
                    }
                }
                guard let data = json["data"].dictionary else{return}
                print(data)
                completion(json, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
                print(error)
            }
        }
    }
    func getProcess(url:String,param:Parameters,header:HTTPHeaders,completion:@escaping(ResponseCompletion)) {
        Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default,headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let status = json["status"].bool
                if status == nil{return}
                if status == false{
                    if let message = json["message"].string{
                    completion(nil, message)
                    }
                }
                completion(json, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
                print(error)
            }
        }
    }
    
    func getOwner(url:String,param:Parameters,header:HTTPHeaders,completion:@escaping((JSON?, Error?) -> ())) {
        Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default,headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let status = json["status"].bool
                if status == nil{return}
                if status == false{
                    if let message = json["message"].string{
                        completion(nil, message as? Error)
                    }
                }
                guard let data = json["data"].dictionary else{return}
                print("data: \(data)")
                completion(json["data"], nil)
            case .failure(let error):
                completion(nil, error as? Error)
                print(error)
            }
        }
    }
    func getImageFromURL(url:String, completion:@escaping((_ imagString:UIImage?, _ error:Error?)->())) {
        Alamofire.download(url).responseData { response in
            if let data = response.result.value {
                let image = UIImage(data: data)
                completion(image, nil)
            }
        }
    }
    
    func getLocation(url:String,completion:@escaping((JSON?, Error?) -> ())){
        let mUrl = "https://maps.googleapis.com/maps/api/geocode/json"
        let param = ["address" : url]
        Alamofire.request(mUrl, method: .get, parameters: param, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
//                guard let results = json["results"].array else{return}
//                guard let geometry = results[0]["geometry"].dictionary else{return}
//                guard let location = geometry["location"]?.dictionary else{return}
//                guard let lat = location["lat"], let lng = location["lng"] else{return}
                completion(json["results"], nil)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
class BaseService: NSObject {
    
    let apiService = APIService()
    
    override init() {
        super.init()
    }
    
    
}
