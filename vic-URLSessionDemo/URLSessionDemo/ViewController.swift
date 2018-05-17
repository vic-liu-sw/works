//
//  ViewController.swift
//  URLSessionDemo
//
//  Created by vic_liu on 2018/4/27.
//  Copyright © 2018年 vic_liu. All rights reserved.
//

import UIKit
import Foundation
import Reachability     // 檢測網路狀態



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let reachability = Reachability()!
//        reachability.whenReachable = { reachability in
//            if reachability.connection == .wifi {
//                print("Reachable via WiFi")
//            } else {
//                print("Reachable via Cellular")
//            }
//        }
//        reachability.whenUnreachable = { _ in
//            print("Not reachable")
//        }
//
//        do {
//            try reachability.startNotifier()
//        } catch {
//            print("Unable to start notifier")
//        }
        //實作1 json ServerAPI request & response
let request = URLRequest(url: URL(string:"https://www.mocky.io/v2/5ad1c7373000005200534c4b")!)
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

                if let product_list = jsonData!["products"] as? NSArray {
                    print(product_list)
             //    //   print(product_list[1]["price"])
//                    if let product_1 = product_list[0] as? NSDictionary{
//                        print(product_1["price"])
//
//                    }
                }

                let decoder = JSONDecoder()

                if let  result = try? decoder.decode(productResult.self,
                                                     from: data){
                    print(result.products)
                    print(result.products[1].price)

                    DispatchQueue.main.async(execute:{
                        for (index,product) in result.products.enumerated(){
                            //正規做法 透過 TableView 將每筆資訊寫道Cell上 根據Cell後續在動態修改
                            //目前作法放上去後就無法修正
                            let titleLabel = UILabel(frame: CGRect(x: 20,
                                                                   y: 60 + index*120,
                                                                   width: 400,
                                                                   height: 40))
                            titleLabel.text = product.name
                            titleLabel.font = UIFont.systemFont(ofSize: 20)
                            let descriptionLabel = UILabel(frame: CGRect(x: 20,
                                                                         y: 90 + index*120,
                                                                         width: 400,
                                                                         height: 40))
                            descriptionLabel.text = product.description
                            descriptionLabel.font = UIFont.systemFont(ofSize: 14)
                            self.view.addSubview(titleLabel)
                            self.view.addSubview(descriptionLabel)

                        }
                    })

                }

            } catch let error as JSONError{
                print(error.rawValue)
            } catch let error as NSError{ //最大眾寫法
                print(error.debugDescription)
            }

// //可以從 政府資料開發平台 找相關ＪＳＯＮＵＲＬ
//let request = URLRequest(url: URL(string:"https://cloud.culture.tw/frontsite/trans/SearchShowAction.do?method=doFindTypeJ&category=8")!)
//
//let requestTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
//                // 解析Response,透過DO/Catch,來針對特定情況來處理
//    do {
//        guard error == nil else{
//         throw JSONError.unknoweError
//      }
//        guard let data = data else{ //等同 data != nil
//         throw JSONError.noData
//    }
////    //JSON原本使用NSDictionary來接收,但是因為json data 是array所以要用NSarray
//        guard let jsonData = try? JSONSerialization.jsonObject(with: data,options: []) as? NSArray else{
//                throw JSONError.conversionFailed
//                }
//                    print("JsonDAta=\(jsonData!)")
//
//
//                } catch let error as JSONError{
//                    print(error.rawValue)
//                } catch let error as NSError{ //最大眾寫法
//                    print(error.debugDescription)
//                }
//
//
            
//************************
//        //下載圖片 https://images.gamme.com.tw/news2/2016/09/07/qpmZnp2VmJ_WrKQ.jpg
//
//        let request = URLRequest(url: URL(string: "https://images.gamme.com.tw/news2/2016/09/07/qpmZnp2VmJ_WrKQ.jpg")!)
//        let configiguration = URLSessionConfiguration.default
//        configiguration.timeoutIntervalForRequest = .infinity //讀取時間永久
//        let urlSession = URLSession(configuration: configiguration)
//        //這邊有出入,url 跟之前用data不一樣
//        let requestTask = urlSession.downloadTask(with: request) { (url, response, error) in
//
//            do {
//                guard error == nil else {
//                    throw JSONError.unknoweError
//                }
//                if let url = url {
//                   let downimage = UIImage(data: try Data(contentsOf: url))
//
//
//                    DispatchQueue.main.async(execute: {
//                        let imageView = UIImageView(image: downimage)
//                        imageView.frame = CGRect(x: 0, y: 60, width: 300, height: 300)
//                        imageView.contentMode = .scaleAspectFit
//                        self.view.addSubview(imageView)
//                    })
//                }
//            } catch let error as JSONError{
//                print(error.rawValue)
//            } catch let error as NSError{ //最大眾寫法
//                print(error.debugDescription)
//            }
//

            
            
            
        }
        
    
    
    requestTask.resume()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

