//
//  TimeFormattor.swift
//  Union
//
//  Created by 万联 on 16/4/8.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class TimeFormattor: NSObject {
    
    
    static func timeTransform(time:String) -> String{
    
        //当前时间
        let currentDate:NSDate = NSDate();
        //转化时间戳
        let timeInterval:NSTimeInterval = currentDate.timeIntervalSince1970;
        //当前天shu
        let currentDays = Int(timeInterval)/(24*3600);
        //更新的时间戳
        
        let modelTime = (time as NSString).doubleValue;
        let modelDays = Int(modelTime)/(24*3600);
        
        //差值
        let timeDay = currentDays - modelDays;
        let timeSecondes = Int(timeInterval) - Int(modelTime);
        
        //时间格式
        
        let formatter:NSDateFormatter = NSDateFormatter();
        
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle;
        formatter.dateFormat = "yyyy-MM-dd hh:mm";
        
        let update = NSDate(timeIntervalSince1970: modelTime);
        let timeStr = formatter.stringFromDate(update);
        
        if timeDay == 0{
        
            if timeSecondes < 3600 {
            
                return NSString(format: "%ld分钟之前", timeSecondes / 60) as String;
                
            }else{
                
                let timeString1 = (timeStr as NSString).substringFromIndex(11);
                
                return NSString(format: "今天%@", timeString1) as String;
            
            }
            
        }else if timeDay == 1{
        
            let timeString1 = (timeStr as NSString).substringFromIndex(11);
            return NSString(format: "昨天%@", timeString1) as String;
        
        }else{
        
            return timeStr;
        
        }

    }

}
