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
    
    func getWorkListWith(status: WorkStatus? , url:String,param:Parameters,header:HTTPHeaders,completion:@escaping(([Work]?, ResultStatus) -> ())) {
        Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default,headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value).dictionary
                print("JSON = \(String(describing: json))")
                var workList:[Work] = []
                if let status = json?["status"], status == true {
                    if let list = json?["data"]?["docs"] {
                        for item in list {
                            print("item: \(item)\n")
                            let work = Work(json: item.1)
                            workList.append(work)
                        }
                        (workList.count > 0) ? completion(workList, ResultStatus.Success) : completion(nil, ResultStatus.EmptyData)
                    }else {
                        completion(nil, ResultStatus.EmptyData)
                    }
                }
                else {
                    (json?["message"] == "Unauthorized") ? completion(nil, ResultStatus.Unauthorize) : completion(nil, ResultStatus.EmptyData)
                }
                break
            case .failure:
                completion(nil, ResultStatus.Unauthorize)
                break
            }
        }
    }
    
    func getTaskCommentHistory(url: String, param: Parameters, header: HTTPHeaders, completion:@escaping((Comment?, ResultStatus) -> ())) {
        Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value).dictionary
                print("JSON OWNER HISTORY COMMENT: \(String(describing: json))")
                if let status = json?["status"], status == true {
                    completion(Comment(json: (json?["data"])!), ResultStatus.Success)
                }
                else {
                    (json?["message"] == "Unauthorized") ? completion(nil, ResultStatus.Unauthorize) : completion(nil, ResultStatus.EmptyData)
                }
                break;
            case .failure:
                completion(nil, ResultStatus.Unauthorize)
                break;
            }
        }
    }
}
