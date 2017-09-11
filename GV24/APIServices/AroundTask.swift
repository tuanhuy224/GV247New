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
typealias NearbyWorkCompletion = (( NearbyWork?, String?) -> ())
typealias WorkTypeAll = (( [WorkType]?, String?) -> ())

class AroundTask: APIService {
    static let sharedInstall = AroundTask()
    
    func getWorkAround(_ url: String, _ parameter: Parameters, completion: @escaping NearbyWorkCompletion) {
        getAllAround(url: url, method: .get, parameters: parameter, encoding: URLEncoding.default) { (json, error) in
            if error != nil{
                completion(nil, error)
            }else{
                let nearbyWork = NearbyWork(json: json!)
                completion( nearbyWork, nil)
            }
        }
    }
    
    func getWorkFromURL(url:String?,parameter:Parameters,completion:@escaping(dataCompletion)){
        getAllAround(url: url!, method: .get, parameters: parameter, encoding: URLEncoding.default) { (json, error) in
            if error != nil{
             completion(nil, error)
            }else{
                completion(self.ArrayWork(json:(json?["docs"])!),nil)
            }
        }
    }
    
    
    func getProcessID(url:String,parameter:Parameters,header:HTTPHeaders,completion:@escaping(dataCompletion)) {
        getProcess(url: url, param: parameter, header: header) { (json, error) in
            if error != nil{
            completion(nil, error)
            }else{
            completion(self.ArrayWork(json: (json?["data"])!), nil)
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
    
    func getWorkType(_ url: String, completion: @escaping WorkTypeAll){
        get(url: url) { (response, error) in
            if error == nil {
                completion(self.getWorkTypesFrom(jsonData: response!), nil)
            }else{
                completion(nil, error)
            }
        }
    }
    
    private func getWorkTypesFrom(jsonData : JSON) -> [WorkType]?{
        if let jsonArray = jsonData.array{
            var works : [WorkType] = [WorkType]()
            for workData in jsonArray{
                works.append(WorkType(json: workData))
            }
            
            return works.reversed()
        }
        return nil
    }
    
}
