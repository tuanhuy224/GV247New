//
//  APIServices+GetOwner.swift
//  GV24
//
//  Created by HuyNguyen on 7/24/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
typealias workCompletion = ((_ error: Error?, _ tasks: [Work]?, _ last_page: Int)->Void)
extension APIService{

  class func tasks(page: Int = 1,headers:HTTPHeaders, paramter:Parameters, completion: @escaping (workCompletion)) {
    let url = APIPaths().urlGetTaskOfOwner()
    Alamofire.request(url, method: .get, parameters: paramter, encoding: URLEncoding.default, headers: headers)
      .responseJSON { response in
        
        switch response.result{
        case .failure(let error):
          completion(error as? Error, nil, page)
        case .success(let value):
          let json = JSON(value)
          guard let dataArr = json["data"].dictionary else {
            completion(nil, nil, page)
            return
          }
          guard let dataJson = dataArr["docs"] else{
            completion(nil, nil, page)
          return
          }
          let arrayWorks = APIService.shared.ArrayWork(json: dataJson)
          let last_page = json["pages"].int ?? page
          completion(nil, arrayWorks, last_page)
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
