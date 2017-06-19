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
    case getURLWorkListHistory = "/maid/getHistoryTasks"
    case getTaskCommentWithTaskID = "/maid/getTaskComment"
    case getOwnerList = "/maid/getAllWorkedOwner"
    case urlReserve = "/task/reserve"
    case urlPocess = "/maid/getAllTasks"
    case urlOwner = "/owner/getById"
    case taskGetById = "/task/getById"
    case getTaskByAround = "/more/getTaskByWork"
    case getTaskOfOwner = "/maid/getTaskOfOwner"
    case cancelTask = "/task/cancel"
    case getProfileComments = "/maid/getComment"
}
struct APIPaths {
    let baseURL = "https://yukotest123.herokuapp.com"
    
    func urlGetListAround() -> String {
        return "rootDomain".localize + urlPath.getListAround.rawValue
    }
    func urlGetWorkListHistory() -> String {
        return "rootDomain".localize + urlPath.getURLWorkListHistory.rawValue
    }
    func urlGetTaskCommentWithTaskID() -> String {
        return "rootDomain".localize + urlPath.getTaskCommentWithTaskID.rawValue
    }
    func urlGetOwnerList() -> String {
        return "rootDomain".localize + urlPath.getOwnerList.rawValue
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
        return "rootDomain".localize + urlPath.getTaskOfOwner.rawValue
    }
    func urlCancelTask() -> String {
        return "rootDomain".localize + urlPath.cancelTask.rawValue
    }
    
    func urlGetProfileComments() -> String {
        return "rootDomain".localize + urlPath.getProfileComments.rawValue
    }
    
 }
