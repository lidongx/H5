//
//  H5+Parse.swift
//  PurchaseH5_Example
//
//  Created by lidong on 2022/7/27.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import HandyJSON

extension H5{
    
    public enum ItemType:String,HandyJSONEnum{
        case view = "view"
        case controller = "controler"
    }
    
    public class Property : HandyJSON{
        var shadowColor:String?
        var cornRadious:String?
        var isClickShadowQuit:Int = 0
        var animationType:String?
        var showType:String?
        required public init() {}
    }
    
    public class Item : HandyJSON{
        var width:String?
        var height:String?
        var url:String?
        var property:Property?
        var type:ItemType?
        required public init() {}
    }
    
    public class Data:HandyJSON{
        var data:[Item]?
        var contentVersion:String?
        var dataParams:[String:Any]?
        required public init() {}
    }
}
