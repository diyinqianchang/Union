//
//  Pictures_Sreoll_Model.swift
//  Union
//
//  Created by 万联 on 16/4/21.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class Pictures_Sreoll_Model: NSObject {
    
    var title:String?
    var url:String?
    var source:String?
    var fileWidth:NSNumber?
    var fileHeight:NSNumber?
    var picId:NSNumber?
    var picDesc:String?
    
    override func setValue(value: AnyObject?, forKey key: String) {
        super.setValue(value, forKey: key);
        
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    

}
