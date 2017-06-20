//
//  CommentServices.swift
//  GV24
//
//  Created by Macbook Solution on 6/20/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire



class CommentServices: APIService {
    
    static let sharedInstance = CommentServices()
    
    func getProfileCommentsWith(url:String,param:Parameters,header:HTTPHeaders,completion:@escaping(([Comment]?, Error?) -> ())) {
        Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default,headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value).dictionary
                print("JSON = \(String(describing: json))")
                var comments:[Comment] = []
                if let status = json?["status"], status == true {
                    if let list = json?["data"]?["docs"] {
                        for item in list {
                            print("item: \(item)\n")
                            let comment = Comment(json: item.1)
                            comments.append(comment)
                        }
                        completion(comments, nil)
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
}
