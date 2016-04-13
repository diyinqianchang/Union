//
//  VideoListModel.swift
//  Union
//
//  Created by 万联 on 16/4/13.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class VideoListModel: NSObject {
    
    
    var vid:String?
    var cover_url:String?
    var title:String?
    var video_length:String?
    var upload_time:String?
    
    override func setValue(value: AnyObject?, forKey key: String) {
          super.setValue(value, forUndefinedKey: key)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
          super.setValue(value, forUndefinedKey: key)
    }

}
