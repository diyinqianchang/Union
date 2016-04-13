//
//  Union_News_TableView_Model.swift
//  Union
//
//  Created by 万联 on 16/4/8.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class Union_News_TableView_Model: NSObject {
    
    var id :String?
    var title:String?
    var content:String?
    var time :String?
    var readCount:String?
    var photo:String?
    var type:String?
    var destUrl:String?
    
    override func setValue(value: AnyObject?, forKey key: String) {
        super.setValue(value, forKey: key);
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
//        super.setValue(value, forUndefinedKey: key)
    }
    
    

}
