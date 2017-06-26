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
    
    func getProfileCommentsWith(url:String,param:Parameters,header:HTTPHeaders,completion:@escaping(([Comment]?, ResultStatus) -> ())) {
        Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default,headers:header).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value).dictionary
                var comments:[Comment] = []
                if let status = json?["status"], status == true {
                    if let list = json?["data"]?["docs"] {
                        for item in list {
                            let comment = Comment(json: item.1)
                            comments.append(comment)
                        }
                        (comments.count > 0) ? completion(comments, ResultStatus.Success) : completion(nil, ResultStatus.EmptyData)
                    }else {
                        completion(nil,ResultStatus.EmptyData)
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
}
