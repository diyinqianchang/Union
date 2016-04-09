//
//  SummonerDataBaseManager.swift
//  Union
//
//  Created by 万联 on 16/4/9.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class SummonerDataBaseManager: NSObject {
    
    private static let shareInstance = SummonerDataBaseManager();
    class var sharedInstance:SummonerDataBaseManager {
        return shareInstance;
    }
    
    
    
    
    
    
    
    
    func getModelProperties(model:AnyObject)->Array<String>{
    
        let count:UnsafeMutablePointer<UInt32> = UnsafeMutablePointer<UInt32>.alloc(5);
        let properties:UnsafeMutablePointer<objc_property_t> = class_copyPropertyList(model.classForCoder, count);
        var arr:Array<String> = Array();
        for index in 0..<Int(count.memory){
            let property = properties.advancedBy(index);
            let propertyName = property_getName(property.memory)
            let name:NSString = NSString(UTF8String: propertyName)!
            arr.append(name as String);
        }
        print(arr);
        count.destroy();
        properties.destroy();
        free(properties);
        return arr;
    }
    
    
    
    
    
    func dataBasePath()->String{
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true);
        return path.first!
    }
    
    

}
