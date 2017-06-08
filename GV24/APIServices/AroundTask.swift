//
//  ArTask.swift
//  GV24
//
//  Created by HuyNguyen on 6/6/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

typealias dataCompletion = (([Work]?,String?)->())
class AroundTask: APIService {
    static let sharedInstall = AroundTask()
    func getWorkFromURL(url:String?,parameter:Parameters,completion:@escaping(dataCompletion)){
        getAllAround(url: url!, method: .get, parameters: parameter, encoding: URLEncoding.default) { (json, error) in
            if error != nil{
             completion(nil, error)
            }else{
                completion(self.ArrayWork(json:(json?["docs"])!),nil)
            }
        }
    }

   private func ArrayWork(json:JSON) -> [Work]? {
        var jsonArray:[Work] = [Work]()
        if let datas = json.array {
            for data in datas {
                jsonArray.append(Work(json:data))
            }
        }
        return jsonArray
    }
}
