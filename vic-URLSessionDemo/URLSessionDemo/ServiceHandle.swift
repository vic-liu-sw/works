//
//  ServiceHandle.swift
//  URLSessionDemo
//
//  Created by vic_liu on 2018/4/27.
//  Copyright © 2018年 vic_liu. All rights reserved.
//

import Foundation
import Reachability



//只要將參數寫在ＣＡＬＳＳ之外 全專案都可參考到 可以另外寫一個空的ＳＷＩＦＴ存全域變數
enum JSONError: String, Error {
    case unknoweError = "Error: unknowned"
    case noData = "Error: no Data"
    case conversionFailed = "Error: conversion from JSON failed"
}



// 此檔案應為網路相關參數統一放入此處減少viewcontroller負擔
class ServiceHandle: NSObject {
    static let sharedHandle = ServiceHandle() //靜態呼叫 一開始就先建立
    var isInternetAvailable:Bool = true
    
    override init() {
        super.init()
        let reachability = Reachability()!
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    
    func sendRequestWithParameter(_ parameter: Dictionary <String , Any>) {
        if isInternetAvailable {
            
            
        }
    }
    
    func getDataWithParameter(_ parameter: Dictionary <String , Any>) {
        if isInternetAvailable {
            
            
        }
    }
    
    
    
    
    
    
    
}
