//
//  UrlGetViewController.swift
//  URLSessionDemo
//
//  Created by vic_liu on 2018/4/27.
//  Copyright © 2018年 vic_liu. All rights reserved.
//

import UIKit
import Reachability     // 檢測網路狀態
class UrlGetViewController: UIViewController {
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        

        
        //實作2  URL GET 應用
      //  let request = URLRequest(url: URL(string: "https://httpbin.org/get?para1=value1&para2=value2")!)
        var request = URLRequest(url: URL(string: "https://httpbin.org/get?para1=value1&para2=value2")!)
       // ＡＰＩＨeader 要add Key 可用//
        request.addValue("value1", forHTTPHeaderField: "para1")
        request.addValue("value2", forHTTPHeaderField: "para2")

        let requestTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
             // 解析Response,透過DO/Catch,來針對特定情況來處理
            do {
                guard error == nil else{
                    throw JSONError.unknoweError
                }
                guard let data = data else{ //等同 data != nil
                    throw JSONError.noData
                }
                //JSON可使用NSDictionary來接收
                guard let jsonData = try? JSONSerialization.jsonObject(with: data,
                                                                       options: []) as? NSDictionary else{
                                                                        throw JSONError.conversionFailed
                }
                print("JsonDAta=\(jsonData!)")


            } catch let error as JSONError{
                print(error.rawValue)
            } catch let error as NSError{ //最大眾寫法
                print(error.debugDescription)
            }
        
    }
    
    requestTask.resume()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
