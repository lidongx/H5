//
//  H5+Config.swift
//  PurchaseH5_Example
//
//  Created by lidong on 2022/7/27.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import WebKit
extension H5{
    public class Config{
        
        public static var language = "en"
        public static var version = "1.0.0"
        public static var dataParams = [String:Any]()
        public static var items = [Item]()
        
        private static let mainParam:[String:String] = [
            "version" : version,
            "device":H5.getDeviceString(),
            "language": language
        ]
        
        private static let pageParam:[String:Any] = [
            "version" : version,
            "device":H5.getDeviceString(),
            "language": language,
            "dataParams":dataParams
        ]
        
        public static var mainJsString:String {
            var js = ""
            js +=
            """
            window.iosData = \(H5.dictToString(params: mainParam));
            function receivedData(params){
                webkit.messageHandlers.subscription.postMessage({"name": "receivedData","params": params})
            }
            """
            return js
        }
        
        public static var pageJsString:String {
            var js = ""
            js +=
            """
                   window.iosData = \(H5.dictToString(params: pageParam));
                   function prevPage() { // 关闭页面
                       webkit.messageHandlers.subscription.postMessage({"name": "prevPage"})
                   }
                   
                   function closePage() { // 关闭页面
                       webkit.messageHandlers.subscription.postMessage({"name": "closePage"})
                   }

                   function jumpToUrl(params) { // terms页面
                       webkit.messageHandlers.subscription.postMessage({"name": "jumpToUrl","params": params})
                   }

                   function restore() { // restore
                       webkit.messageHandlers.subscription.postMessage({"name": "restore"})
                   }

                   function loadedPage() {
                       webkit.messageHandlers.subscription.postMessage({"name": "loadedPage"})
                   }
                    function buyAction(params) { // 确认订阅
                        webkit.messageHandlers.subscription.postMessage({"name": "buyAction", "params": params})
                    }
                    
                    function selectedItem(params) { // 确认订阅
                        webkit.messageHandlers.subscription.postMessage({"name": "selectedItem", "params": params})
                    }
                    
                    function nextPage() {
                        webkit.messageHandlers.subscription.postMessage({"name": "nextPage"})
                    }
            
                    function jumpToUrl(params){
                        webkit.messageHandlers.subscription.postMessage({"name": "jumpToUrl", "params": params})
                    }
                   
            """
            return js
        }

        public static var contentVersion:String? {
            get{
                return UserDefaults.standard.string(forKey: "contentVersion")
            }set{
                UserDefaults.standard.set(newValue, forKey: "contentVersion")
            }
        }
        
        public static var lastVersion:String? {
            get{
                return UserDefaults.standard.string(forKey: "lastVersion")
            }set{
                UserDefaults.standard.set(newValue, forKey: "lastVersion")
            }
        }
    }
}

