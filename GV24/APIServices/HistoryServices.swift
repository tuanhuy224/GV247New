//
//  HistoryServices.swift
//  GV24
//
//  Created by admin on 6/6/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire



class HistoryServices: APIService {
    
    static let sharedInstance = HistoryServices()
    
    func getWorkListWith(status: WorkStatus , url:String,param:Parameters,header:HTTPHeaders,completion:@escaping(([Work]?, Error?) -> ())) {
        Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default,headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value).dictionary
                print("JSON = \(String(describing: json))")
                var workList:[Work] = []
                if let status = json?["status"], status == true {
                    if let list = json?["data"]?["docs"] {
                        for item in list {
                            let work = Work(json: item.1)
                            workList.append(work)
                        }
                        completion(workList, nil)
                    }
                }
                else {
                    completion(nil, nil)
                }
                break
            case .failure(let err):
                var error = Error()
                error.errorContent = err.localizedDescription
                completion(nil, error)
                break
            }
        }
    }
    
    func getTaskCommentHistory(url: String, param: Parameters, header: HTTPHeaders, completion:@escaping((Comment?, Error?) -> ())) {
        Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(url)
                print("params: \(param)")
                let json = JSON(value).dictionary
                print("JSON OWNER HISTORY COMMENT: \(String(describing: json))")
                if let status = json?["status"], status == true {
                    completion(Comment(json: (json?["data"])!), nil)
                }
                else {
                    completion(nil, nil)
                }
                break;
            case .failure(let err):
                completion(nil, (err as! Error))
                break;
            }
        }
    }
}
