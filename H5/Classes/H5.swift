//
//  H5.swift
//  PurchaseH5_Example
//
//  Created by lidong on 2022/7/27.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol PageDelegate: NSObjectProtocol {
    @objc optional func loaded(_ index:Int,_ page:H5.Page)
    @objc optional func closePage(_ index:Int,_ page:H5.Page)
    @objc optional func restore()
    @objc optional func buyAction(_ iapid:String,_ index:Int,_ page:H5.Page)
    @objc optional func selectedItem(_ iapid:String,_ index:Int,_ page:H5.Page)
    @objc optional func nextPage(_ index:Int,_ page:H5.Page)
    @objc optional func prevPage(_ index:Int,_ page:H5.Page)
    @objc optional func loadfail(_ index:Int,_ page:H5.Page)
}

public class H5 : NSObject{
    public static let shared = H5()
    var mainHander = MainHander()
    var pages = [Page]()
    
    public weak var controller:UIViewController?
    
    
    public var loadDataCallback:((_ finished:Bool)->Void)? = nil
    public var preloadedCallback:((_ finished:Bool)->Void)? = nil
    public var restoreCallback:(()->Void)? = nil
    public var buyCallback:((_ iapid:String,_ index:Int,_ page:H5.Page)->Void)? = nil
    public var selectedItemCallback:((_ iapid:String,_ index:Int,_ page:H5.Page)->Void)? = nil
    
    public func requestData(){
        mainHander.request {[weak self] b in
            guard let self = self else{
                return
            }
            if b{
                for (index,item) in Config.items.enumerated(){
                    let page = Page(index,item)
                    page.pageDelegate = self
                    self.pages.append(page)
                }
            }
            self.loadDataCallback?(b)
        }
    }
    
    public func show(_ index:Int = 0){
        if index > pages.count-1{
            return
        }
        if let vc = self.controller{
            pages[index].show(vc)
        }
    }
    
    public var isLoadedData:Bool{
        return pages.count > 0
    }
    
    public var isPreloaded:Bool{
        if pages.count == 0{
            return false
        }
        var b = true
        for page in pages{
            if page.pageHander.loadState != .loaded{
                b = false
                break
            }
        }
        return b
    }
    
    public func preloadAll(_ sourceType:SoureType = .server){
        for page in pages{
            page.request(sourceType)
        }
    }
}


extension H5 : PageDelegate{
    public func loaded(_ index:Int,_ page:H5.Page){
        if isPreloaded{
            preloadedCallback?(true)
        }
    }
    public func restore(){
        self.restoreCallback?()
    }
    public func buyAction(_ iapid:String,_ index:Int,_ page:H5.Page){
        buyCallback?(iapid,index,page)
    }
    public func selectedItem(_ iapid:String,_ index:Int,_ page:H5.Page){
        selectedItemCallback?(iapid,index,page)
    }
    public func nextPage(_ index:Int,_ page:H5.Page){
        let index = index + 1
        show(index)
    }
    public func prevPage(_ index:Int,_ page:H5.Page){
        let index = index - 1
        show(index)
    }
    public func loadfail(_ index:Int,_ page:H5.Page){
        preloadedCallback?(false)
    }
}
