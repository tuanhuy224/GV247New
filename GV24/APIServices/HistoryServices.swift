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
    /* getListWith is use for getting:
    +getTaskOfOwner on WorkListViewController page
    +getList on HistoryViewController page
     */
    func getListWith(object: Any,url:String,param:Parameters,header:HTTPHeaders,completion:@escaping(([Work]?, ResultStatus) -> ())) {
        Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default,headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value).dictionary
                var workList:[Work] = []
                if let status = json?["status"], status == true {
                    if let list = json?["data"]?["docs"] {
                        for item in list {
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
 
    func getWorkAbility(url: String, param:Parameters, header: HTTPHeaders, completion: @escaping(([WorkType]?, ResultStatus) -> ())){
        Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value).dictionary
                if let status = json?["status"], status == true {
                    var list: [WorkType] = []
                    let result = json?["data"]?.array
                    for item in result! {
                        let workType = WorkType(json: item)
                        list.append(workType)
                    }
                    (list.count > 0) ? completion(list, ResultStatus.Success) : completion(nil, ResultStatus.EmptyData)
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
