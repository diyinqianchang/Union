//
//  VideoTranscodeModel.swift
//  Union
//
//  Created by 万联 on 16/4/18.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class VideoTranscodeModel: NSObject {

    var size:String?      //视频大小
    var width:String?     //视频宽
    var height:String?    //视频高
    var duration:String?  //视频时长
    var urls:NSArray?     //视频URL
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    override func valueForUndefinedKey(key: String) -> AnyObject? {
        return NSNull();
    }
    
    
}
