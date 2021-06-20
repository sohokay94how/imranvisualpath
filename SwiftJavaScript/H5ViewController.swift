//
//  H5ViewController.swift
//  SwiftJavaScript
//
//  Created by hengchengfei on 16/2/1.
//  Copyright © 2016年 chengfeisoft. All rights reserved.
//

import UIKit
import WebKit

class H5ViewController: UIViewController,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler  {
    private var url : NSURL?
    private var swiped:Bool?
    private var callbackHandlerName:[String]?
    private var callbackHandler:((handlerName:String,sendData:String,vc:UIViewController) -> Void)?
    
    private var webView:WKWebView!
    private var progressView:UIProgressView!
    private var request:NSURLRequest!

    /**
     初始化一个Web Controller
     
     - parameter url:  url地址
     - parameter callbackHandlerName: JavaScript调用App时，定义的名字(可定义多个)
     - parameter callbackHandler:     App收到Javascript时的回调方法
     
     - returns: controller实例
     */
    init(url:NSURL?,callbackHandlerName:[String]? = nil,callbackHandler:((handlerName:String,sendData:String,vc:UIViewController) -> Void)? = nil){
        self.url = url
        self.callbackHandlerName = callbackHandlerName
        self.callbackHandler = callbackHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
        progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.Default)
        progressView.frame = CGRectMake(0, 65, UIScreen.mainScreen().bounds.width, 100)
        progressView.tintColor = UIColor.blueColor()
        view.addSubview(progressView)
        
        
        let conf = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRectMake(0, 66, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 66), configuration: conf)
        view.insertSubview(webView, belowSubview: progressView)

        webView.addObserver(self, forKeyPath: "title", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        webView.navigationDelegate = self
        

        //APP调用JavaScript
        let userScript = WKUserScript(source: "redHeader()", injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
        conf.userContentController.addUserScript(userScript)
        
        //JavaScript回调APP
        if let handler = self.callbackHandlerName where handler.count > 0 {
            for j in handler {
                conf.userContentController.addScriptMessageHandler(self, name: j)
            }
        }
        
        let request = NSURLRequest(URL: self.url!, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 20)
        self.webView.loadRequest(request)
        
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "title" {
            title = webView.title
        }
        
        if keyPath == "loading" {
        }
        
        if keyPath == "estimatedProgress" {
            progressView.hidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }
    
    deinit{
        webView.removeObserver(self, forKeyPath:  "title")
        webView.removeObserver(self, forKeyPath:  "loading")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.navigationDelegate = nil
        webView.UIDelegate = nil
    }
    
    // MARK: -  WKScriptMessageHandler
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if callbackHandler != nil {
            callbackHandler!(handlerName: message.name,sendData:message.body as! String,vc:self)
        }
    }
}
