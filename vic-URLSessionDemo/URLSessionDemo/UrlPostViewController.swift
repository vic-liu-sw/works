//
//  UrlPostViewController.swift
//  URLSessionDemo
//
//  Created by vic_liu on 2018/4/27.
//  Copyright © 2018年 vic_liu. All rights reserved.
//

import UIKit
import Reachability     // 檢測網路狀態
class UrlPostViewController: UIViewController {

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
        
         //實作3  URL POST 應用
        let paramter = ["param1": "value1",
                        "param2": "value2"]
        var request = URLRequest(url: URL(string: "https://httpbin.org/post")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: paramter,
                                                          options: JSONSerialization.WritingOptions())
        } catch let error{
            print(error)
        }

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
