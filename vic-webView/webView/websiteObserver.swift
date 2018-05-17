//
//  websiteobserver.swift
//  webView
//
//  Created by vic_liu on 2018/4/21.
//  Copyright © 2018年 vic_liu. All rights reserved.
// 監聽網頁更新後上一次網頁未更新的紀錄,並更新之

import UIKit

class websiteObserver: NSObject {
    
    var lastURL: String = ""
    init(lastURL: String) {
        super.init()
      self.lastURL = lastURL
        //監聽websiteDidFinishNavigation發出的通知
        let notificationName = Notification.Name("websiteDidFinishNavigation")
        NotificationCenter.default.addObserver(self, selector: #selector(websiteDidFinishNavigation(Notification:)), name: notificationName, object: nil)
        
        
    }
    //實作觸發websiteDidFinishNavigation後,更新 LastURL//
    @objc func websiteDidFinishNavigation(Notification: Notification) {
        let userInfo = Notification.userInfo as! [String: AnyObject]
        self.lastURL = userInfo["url"] as! String
        print("更新 LastURL: \(self.lastURL)")
    
        
    }
    deinit {
      //記得移除監聽//
        NotificationCenter.default.removeObserver(self)
        
    }

}
