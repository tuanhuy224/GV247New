//
//  APIPath.swift
//  GV24
//
//  Created by HuyNguyen on 6/7/17.
//  Copyright © 2017 admin. All rights reserved.
//
import Foundation

enum urlPath:String {
    case getListAround = "/more/getTaskAround"
    case getListHome = "/vi/auth/maid/login"
    case getURLWorkListHistory = "/en/maid/getHistoryTasks"
    case getTaskCommentWithTaskID = "/en/maid/getTaskComment"
    case getOwnerList = "/en/maid/getAllWorkedOwner"
    case urlReserve = "/task/reserve"
    case urlPocess = "/maid/getAllTasks"
    case urlOwner = "/owner/getById"
    case taskGetById = "/task/getById"
    case getTaskByAround = "/more/getTaskByWork"
    case getTaskOfOwner = "/en/maid/getTaskOfOwner"
    case cancelTask = "/task/cancel"
}
struct APIPaths {
    let baseURL = "https://yukotest123.herokuapp.com"
    
    func urlGetListAround() -> String {
        return "rootDomain".localize + urlPath.getListAround.rawValue
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
    func urlReserve() -> String {
        return "rootDomain".localize + urlPath.urlReserve.rawValue
    }
    func urlPocess() -> String {
        return "rootDomain".localize + urlPath.urlPocess.rawValue
    }
    func urlOwner() -> String {
        return "rootDomain".localize + urlPath.urlOwner.rawValue
    }
    func taskGetById() -> String {
        return "rootDomain".localize + urlPath.urlOwner.rawValue
    }
    func getTaskByAround() -> String {
        return "rootDomain".localize + urlPath.getTaskByAround.rawValue
    }
    func urlGetTaskOfOwner() -> String {
        return baseURL + urlPath.getTaskOfOwner.rawValue
    }
    func urlCancelTask() -> String {
        return "rootDomain".localize + urlPath.cancelTask.rawValue
    }
    
 }
