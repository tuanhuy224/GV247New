//
//  APIPath.swift
//  GV24
//
//  Created by HuyNguyen on 6/7/17.
//  Copyright © 2017 admin. All rights reserved.
//
//https://yukotest123.herokuapp.com/en/more/getTaskAround
import Foundation

let urlReserve = "https://yukotest123.herokuapp.com/en/task/reserve"
let urlPocess = "https://yukotest123.herokuapp.com/en/maid/getAllTasks"
enum urlPath:String {
    case getListAround = "/en/more/getTaskAround"
    case getListHome = "/vi/auth/maid/login"
    case getURLWorkListHistory = "/en/maid/getHistoryTasks"
    case getTaskCommentWithTaskID = "/en/maid/getTaskComment"
    case getOwnerList = "/en/maid/getAllWorkedOwner"
    case getTaskOfOwner = "/en/maid/getTaskOfOwner"
}

struct APIPaths {
    let baseURL = "https://yukotest123.herokuapp.com"
    
    func urlGetListAround() -> String {
        return baseURL + urlPath.getListAround.rawValue
    }
    
    func urlGetWorkListHistory() -> String {
        return baseURL + urlPath.getURLWorkListHistory.rawValue
    }
    
    func urlGetTaskCommentWithTaskID() -> String {
        return baseURL + urlPath.getTaskCommentWithTaskID.rawValue
    }
    
    func urlGetOwnerList() -> String {
        return baseURL + urlPath.getOwnerList.rawValue
    }
    
    func urlGetTaskOfOwner() -> String {
        return baseURL + urlPath.getTaskOfOwner.rawValue
    }
    
//    func urlAddProductToCart() -> String {
//        return baseURL + urlPath.addManage.rawValue
//    }
//    
//    func urlLoveProduct() -> String {
//        return baseURL + urlPath.listInformation.rawValue
//    }
//    
//    func urlUnLoveProduct() -> String {
//        return baseURL + urlPath.listHistory.rawValue
//    }
    
 }
