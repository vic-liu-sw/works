//
//  ViewController.swift
//  webView
//
//  Created by vic_liu on 2018/4/21.
//  Copyright © 2018年 vic_liu. All rights reserved.
//
import UIKit
import WebKit

class ViewController: UIViewController,
    UITextFieldDelegate,
WKNavigationDelegate{
    
    let fullScreenSize = UIScreen.main.bounds.size
    
    var textField: UITextField!
    var webView: WKWebView!
    var activityIndicator: UIActivityIndicatorView!
    
    
   var demoObserver: websiteObserver!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 預設尺寸
        let goWidth = 100.0
        let actionWidth = ( Double(fullScreenSize.width) - goWidth ) / 4
        
        view.backgroundColor = UIColor(red: 0.9,
                                       green: 0.9,
                                       blue: 0.9,
                                       alpha: 1)
        
        // 建立五個 UIButton
        var myButton = UIButton(frame: CGRect(x: 0,
                                     y: 20,
                                    width: actionWidth,
                                    height: actionWidth))
        myButton.setImage(UIImage(named: "back")!, for: .normal)
        myButton.addTarget(self, action: #selector(ViewController.back), for: .touchUpInside)
        self.view.addSubview(myButton)
        
        myButton = UIButton(frame: CGRect(x: actionWidth,
                                          y: 20,
                                          width: actionWidth,
                                          height: actionWidth))
        myButton.setImage(UIImage(named: "forward")!, for: .normal)
        myButton.addTarget(self, action: #selector(ViewController.forward), for: .touchUpInside)
        self.view.addSubview(myButton)
        
        myButton = UIButton(frame: CGRect(x: actionWidth * 2,
                                          y: 20,
                                          width: actionWidth,
                                          height: actionWidth))
        myButton.setImage(UIImage(named: "refresh")!, for: .normal)
        myButton.addTarget(self, action: #selector(ViewController.reload), for: .touchUpInside)
        self.view.addSubview(myButton)
        
        myButton = UIButton(frame: CGRect(x: actionWidth * 3,
                                          y: 20,
                                          width: actionWidth,
                                          height: actionWidth))
        myButton.setImage(UIImage(named: "stop")!, for: .normal)
        myButton.addTarget(self, action: #selector(ViewController.stop), for: .touchUpInside)
        self.view.addSubview(myButton)
        
        myButton = UIButton(frame: CGRect(x: Double(fullScreenSize.width) - goWidth,
                                          y: 20,
                                          width: goWidth,
                                          height: actionWidth))
        myButton.setTitle("前往", for: .normal)
        myButton.setTitleColor(UIColor.black, for: .normal)
        myButton.addTarget(self, action: #selector(ViewController.go), for: .touchUpInside)
        self.view.addSubview(myButton)
        
        // 建立一個 UITextField 用來輸入網址
        textField = UITextField(frame: CGRect(x: 16,
                                              y: 20.0 + CGFloat(actionWidth),
                                              width: fullScreenSize.width-32,
                                              height: 40))
        textField.text = "https://www.google.com"
        textField.backgroundColor = UIColor(red: 0.98,
                                            green: 0.98,
                                            blue: 0.98,
                                            alpha: 1)
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .go
        textField.delegate = self
        self.view.addSubview(textField)
        
        // 建立 WKWebView
        webView = WKWebView(frame: CGRect(x: 0,
                                          y: 72.0 + CGFloat(actionWidth),
                                          width: fullScreenSize.width,
                                          height: fullScreenSize.height - 60 - CGFloat(actionWidth)))
        
        // 設置委任對象
        webView.navigationDelegate = self
        
        // 加入到畫面中
        self.view.addSubview(webView)
        
        // 建立環狀進度條
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:.gray)
        activityIndicator.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.5)
        self.view.addSubview(activityIndicator);
        
        // 先讀取一次網址
        self.go()
        
               demoObserver = websiteObserver(lastURL: "")
       
        // //系統內建監控Ａpp按home後就會出現 //
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidEnterBackground,
                                               object: nil,
                                               queue: OperationQueue.main) { (_) in
                                                
                                                print("進入後台囉！")
                                                
                                                
                                                
        }
        // 系統內建監控app 從背景回到前景 //
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground,
                                               object: nil,
                                               queue: OperationQueue.main) { (_) in
                                                print("進入前景囉！")
        }
        
    }
    
    @objc func back() {
        // 上一頁
        webView.goBack()
    }
    
    @objc func forward() {
        // 下一頁
        webView.goForward()
    }
    
    @objc func reload() {
        // 重新讀取
        webView.reload()
    }
    
    @objc func stop() {
        // 取消讀取
        webView.stopLoading()
        activityIndicator.stopAnimating()
    }
    
    @objc func go() {
        
        // 隱藏鍵盤
        self.view.endEditing(true)
        
        // 前往對應網址
        let url = URL(string:textField.text!)
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
        
        // 你也可以設置 HTML 內容到一個常數
        // 用來載入一個靜態的網頁內容
        // let content = "<html><body><h1>Hello World !</h1></body></html>"
        // webView.loadHTMLString(content, baseURL: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.go()
        
        return true
    }
    
    func webView(_ webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {
        
        activityIndicator.stopAnimating()
        
        // 更新網址列的內容
        if let currentURL = webView.url {
            textField.text = currentURL.absoluteString
            
            let notificationName = Notification.Name(rawValue: "websiteDidFinishNavigation")
            //自己定義通知//
            NotificationCenter.default.post(name: notificationName,
                                            object: self,
                                            userInfo: ["url": currentURL.absoluteString])
        }
        
        
    }
    
}


