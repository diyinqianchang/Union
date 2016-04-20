//
//  PrettyPicturesModel.swift
//  Union
//
//  Created by 万联 on 16/4/20.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class PrettyPicturesModel: NSObject {
    
    var galleryId:String?
    var coverUrl:String?
    var title:String?
    var picsum:String?
    var coverWidth:String?
    var coverHeight:String?
    var modify_time:String?
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    override func setValue(value: AnyObject?, forKey key: String) {
        super.setValue(value, forKey: key);
    }

}
