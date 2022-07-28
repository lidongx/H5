//
//  H5+Hander.swift
//  PurchaseH5_Example
//
//  Created by lidong on 2022/7/27.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import WebKit

extension H5{
    public class MainHander : NSObject{

        let urlString = "http://192.168.10.194:8081/#/index-test"
        var callback:((Bool)->Void)? = nil
        
        public func request(_ callback:((Bool)->Void)? = nil){
            guard let url = URL(string: urlString) else { return }
            self.callback = callback
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 15)
            webView.load(request)
        }
        
        lazy var webView:WKWebView = {
            let res = WKWebView.init(frame: UIScreen.main.bounds,configuration: self.getConfig(H5.Config.mainJsString))
            print(H5.Config.mainJsString)
            res.backgroundColor = .white
            res.scrollView.isScrollEnabled = false
            res.navigationDelegate = self
            return res
        }()
        
        func getConfig(_ jsString:String)->WKWebViewConfiguration{
            let config = WKWebViewConfiguration()
            let userScript = WKUserScript(source: jsString, injectionTime: .atDocumentStart, forMainFrameOnly: false)
            config.userContentController.add(self, name: "subscription")
            config.userContentController.addUserScript(userScript)
            config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
            return config
        }
    }
}

extension H5.MainHander : WKNavigationDelegate{
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.callback?(false)
    }
}

extension H5.MainHander : WKScriptMessageHandler{
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard
            message.name == "subscription",
            let params = message.body as? [String: Any],
            let name = params["name"] as? String
        else { return }
        switch name {
        case "receivedData":
            if let subParams = params["params"] as? [String: Any] {
                let dataString = H5.dictToUtf8String(subParams)
                print(dataString)
                if let data = H5.Data.deserialize(from: dataString){
                    if let version = data.contentVersion{
                        H5.Config.contentVersion = version
                    }
                    if let items = data.data{
                        H5.Config.items.append(contentsOf: items)
                    }
                    if let dataParams = data.dataParams{
                        H5.Config.dataParams = dataParams
                    }
                    self.callback?(true)
                    return
                }
            }
            self.callback?(false)
            self.callback = nil
            
        default: break
        }
    }
}
