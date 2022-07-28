//
//  ViewController.swift
//  H5
//
//  Created by lidong@smalltreemedia.com on 07/28/2022.
//  Copyright (c) 2022 lidong@smalltreemedia.com. All rights reserved.
//

import UIKit
import H5

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        H5.shared.controller = self
        
        H5.shared.requestData()
        
        H5.shared.loadDataCallback = { b in
            if b{
                H5.shared.preloadAll()
            }
        }
        
        H5.shared.preloadedCallback = {sourceType, b in
            if b{
                H5.shared.show()
            }else{
                if sourceType == .server{
                   // 从服务器上加载失败 从缓存中读取 预加载失败 从缓存中加载
                    if H5.shared.isCachedAll{
                        H5.shared.preloadAll(.local)
                    }
                }
            }
          
        }
        
        H5.shared.buyCallback = { (iapid,index,page) in
            print(iapid)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

