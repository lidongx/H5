//
//  H5+PageHander.swift
//  PurchaseH5_Example
//
//  Created by lidong on 2022/7/27.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import WebKit

public enum LoadState{
    case notload
    case loading
    case loaded
    case failed
}

public enum SoureType{
    case local
    case server
}

@objc public protocol PageHanderDelegate: NSObjectProtocol {
    @objc optional func loaded()
    @objc optional func closePage()
    @objc optional func restore()
    @objc optional func buyAction(_ iapid:String)
    @objc optional func selectedItem(_ iapid:String)
    @objc optional func nextPage()
    @objc optional func prevPage()
    @objc optional func loadfail()
}
extension H5{

    public class PageHander : NSObject{

        var loadState:LoadState = .notload
        var item:Item!
        
        weak var delegate:PageHanderDelegate? = nil
        
        public func request(_ sourceType:SoureType){
            
            guard let urlString = item.url else{
                self.delegate?.loadfail?()
                return
            }
            guard let url = URL(string: urlString) else {
                self.delegate?.loadfail?()
                return
            }
            var policy = URLRequest.CachePolicy.returnCacheDataDontLoad
            if sourceType == .server{
                policy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
            }
            let request = URLRequest(url: url, cachePolicy: policy, timeoutInterval: 15)
            webView.load(request)
        }
        
        func isExistCache()->Bool{
            guard let urlString = item.url else{
                return false
            }
            guard let url = URL(string: urlString) else {
                return false
            }
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataDontLoad, timeoutInterval: 5)
            if URLCache.shared.cachedResponse(for: request)?.data != nil{
                return true
            }
            return false
        }
        
        lazy var webView:WKWebView = {
            let res = WKWebView.init(frame: UIScreen.main.bounds,configuration: self.getConfig(H5.Config.pageJsString))
            res.backgroundColor = .white
            res.scrollView.isScrollEnabled = false
            res.navigationDelegate = self
            res.uiDelegate = self
            if #available(iOS 11.0, *) {
                res.scrollView.contentInsetAdjustmentBehavior = .never
            } else {
                // Fallback on earlier versions
            }
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


extension H5.PageHander: WKUIDelegate {

}


extension H5.PageHander : WKNavigationDelegate{
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.loadState = .failed
    }
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }

}

extension H5.PageHander : WKScriptMessageHandler{
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard
            message.name == "subscription",
            let params = message.body as? [String: Any],
            let name = params["name"] as? String
        else { return }
        switch name {
        case "loadedPage":
            self.loadState = .loaded
            self.delegate?.loaded?()
        case "closePage":
            self.delegate?.closePage?()
        case "restore":
            self.delegate?.restore?()
        case "buyAction":
            if let subParams = params["params"] as? [String: Any]{
                if let iapId = subParams["id"] as? String{
                    self.delegate?.buyAction?(iapId)
                }
            }
        case "selectedItem":
            if let subParams = params["params"] as? [String: Any]{
                if let iapId = subParams["id"] as? String{
                    self.delegate?.selectedItem?(iapId)
                }
            }
        case "nextPage":
            self.delegate?.nextPage?()
        case "prevPage":
            self.delegate?.prevPage?()
        case "jumpToUrl":
            if let subParams = params["params"] as? [String: Any]{
                if let urlString = subParams["url"] as? String{
                    if let url = URL(string: urlString),
                        UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        default: break
        }
    }
}
