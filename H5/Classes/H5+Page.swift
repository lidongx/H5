//
//  H5+Page.swift
//  PurchaseH5_Example
//
//  Created by lidong on 2022/7/27.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

extension H5{
    public class Page : NSObject{
        var pageHander = PageHander()
        var item:Item!
        var boxView:UIView = UIView(frame: UIScreen.main.bounds)
        var pageViewController = UIViewController()

        var callback:(()->Void)? = nil
        
        weak var pageDelegate:PageDelegate? = nil
        
        var souceType:SoureType = .server
        
        var index:Int = 0
        public init(_ index:Int,_ item:Item){
            self.index = index
            self.item = item
            pageHander.item = item
          
        }
        public func request(_ sourceType:SoureType,_ callback:(()->Void)? = nil){
            self.souceType = sourceType
            self.callback = callback
            pageHander.delegate = self
            pageHander.request(sourceType)
        }

        func show(_ viewController:UIViewController){
            if item.type == .view{
                showView(viewController)
            } else if item.type == .controller{
                showController(viewController)
            }
        }
        
        private func showView(_ viewController:UIViewController){
            boxView.removeFromSuperview()
            pageHander.webView.removeFromSuperview()
            boxView.addSubview(pageHander.webView)
            if let colorString = item.property?.shadowColor{
                if let color = H5.colorFor(hex: colorString){
                    boxView.backgroundColor = color
                }
            }
            
            if let cornRadiousString = item.property?.cornRadious{
                if let cornRadious = Float(cornRadiousString){
                    pageHander.webView.layer.cornerRadius = CGFloat(cornRadious)
                    pageHander.webView.layer.masksToBounds = true
                }
            }
            
            if let widthString = item.width,let width = Int(widthString), let heightString = item.height, let height = Int(heightString){
                pageHander.webView.snp.makeConstraints { make in
                    make.width.equalTo(width)
                    make.height.equalTo(height)
                    make.center.equalToSuperview()
                }
            }else{
                pageHander.webView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
            viewController.view.addSubview(boxView)
        }
        
        private func showController(_ viewController:UIViewController){
            pageHander.webView.removeFromSuperview()
            pageViewController.view.addSubview(pageHander.webView)
            pageHander.webView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            viewController.present(pageViewController, animated: true)
        }
    }
    
   
    
}

extension H5.Page : PageHanderDelegate{
    public func loaded(){
        self.pageDelegate?.loaded?(index,self)
    }
    public func closePage(){
        if item.type == .view{
            boxView.removeFromSuperview()
        }else if item.type == .controller{
            pageViewController.dismiss(animated: true)
        }
    }
    public func restore(){
        pageDelegate?.restore?()
    }
    public func buyAction(_ iapid:String){
        pageDelegate?.buyAction?(iapid, index, self)
    }
    public func selectedItem(_ iapid:String){
        pageDelegate?.selectedItem?(iapid, index, self)
    }
    public func nextPage(){
        closePage()
        pageDelegate?.nextPage?(index, self)
    }
    public func prevPage(){
        closePage()
        pageDelegate?.prevPage?(index, self)
    }
}
