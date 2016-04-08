//
//  StringDeal.swift
//  Union
//
//  Created by 万联 on 16/4/8.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import Foundation

extension String{

    //取出敏感字
    mutating func removeSensitiveWordsWithArray(arr:Array<String>) -> String{
    
        for(_,item) in arr.enumerate(){
            
            self = self.stringByReplacingOccurrencesOfString(item, withString: "");
        }
        return self;
    
    }
    
    //MARK: 获取高度
    
    static func getHeightWithString(string:String,width:CGFloat,fontSize:CGFloat) -> CGFloat {
    
        let dict:NSDictionary = [NSFontAttributeName:UIFont.systemFontOfSize(fontSize)];
        
        let rect = (string as NSString).boundingRectWithSize(CGSizeMake(width,CGFloat.max), options: [NSStringDrawingOptions.UsesFontLeading,NSStringDrawingOptions.UsesLineFragmentOrigin], attributes: dict as? [String : AnyObject], context: nil);
        
        return rect.size.height + 20;

    }
    //MARK: 获取宽度
   static func getWidthWithString(string:String,height:CGFloat,fontSize:CGFloat) -> CGFloat {
        
        let dict:NSDictionary = [NSFontAttributeName:UIFont.systemFontOfSize(fontSize)];
        
        let rect = (string as NSString).boundingRectWithSize(CGSizeMake(CGFloat.max,height), options: [NSStringDrawingOptions.UsesFontLeading,NSStringDrawingOptions.UsesLineFragmentOrigin], attributes: dict as? [String : AnyObject], context: nil);
        
        return rect.size.width;
        
    }
    


}