//
//  Utils.swift
//  TestHtml5
//
//  Created by lidong on 2022/7/27.
//

import Foundation
import UIKit

extension H5{
    public static func isIphoneX() -> Bool {
        var isiPhoneX: Bool = false
        if UIDevice.current.userInterfaceIdiom == .phone {
            let height = UIScreen.main.nativeBounds.size.height
            let width = UIScreen.main.nativeBounds.size.width
            var ratio: CGFloat = 0
            if height > width {
                ratio = height / width
            } else {
                ratio = width / height
            }
            if ratio >= 2.1, ratio < 2.3 {
                isiPhoneX = true
            }
        }
        return isiPhoneX
    }

    public static func isPad() -> Bool {
        return (UIDevice.current.userInterfaceIdiom == .pad) ? true : false
    }

    public static func getDeviceString()->String{
        if isPad(){
            return "ipad"
        }else if isIphoneX(){
            return "iphonex"
        }else{
            return "iphone"
        }
    }

    public static func arrayToUtf8String(_ data:[Any])->String{
        if let theJSONData = try?  JSONSerialization.data(
            withJSONObject: data,
            options: .prettyPrinted
        ),
        let theJSONText = String(data: theJSONData,
                                 encoding: String.Encoding.utf8) {
            return theJSONText
        }
        return ""
    }
    
    public static func dictToUtf8String(_ data:[String:Any])->String{
        if let theJSONData = try?  JSONSerialization.data(
            withJSONObject: data,
            options: .prettyPrinted
        ),
        let theJSONText = String(data: theJSONData,
                                 encoding: String.Encoding.utf8) {
            return theJSONText
        }
        return ""
    }
    
    public static func dictToString(params:[String:Any])->String{
        if let theJSONData = try?  JSONSerialization.data(
            withJSONObject: params,
            options: .prettyPrinted
        ),
        let theJSONText = String(data: theJSONData,
                                    encoding: String.Encoding.ascii) {
            return theJSONText
        }
        return ""
    }
    
    public static func colorFor(hex:String) -> UIColor?{
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
}



extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
