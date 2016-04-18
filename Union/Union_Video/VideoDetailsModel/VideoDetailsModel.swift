//
//  VideoDetailsModel.swift
//  Union
//
//  Created by 万联 on 16/4/18.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class VideoDetailsModel: NSObject {
    
    var vid:String?;    // 视屏ID
    var definition:String? ////视频清晰度 350  1000  1300
    var transcode_id:String?   ////视频转码ID
    var video_name:String?     //视频名
    var transcode:VideoTranscodeModel? //transcode
    var cover:String?     //封面图URL

    override init() {
        super.init();
        self.transcode = VideoTranscodeModel();
    }

    override func setValue(value: AnyObject?, forKey key: String) {
        
        if key == "transcode"{
            
            let tempDict:NSDictionary = [key:value!];
            let dict:NSDictionary = tempDict.objectForKey("transcode") as! NSDictionary;
            print("dict ====>\(dict)");
            self.transcode?.setValuesForKeysWithDictionary(dict as! [String : AnyObject])

        }else{
           super.setValue(value, forKey: key);
        }
        
    }
    override func valueForUndefinedKey(key: String) -> AnyObject? {
        return NSNull();
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
