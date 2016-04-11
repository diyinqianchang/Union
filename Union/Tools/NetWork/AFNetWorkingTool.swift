//
//  AFNetWorkingTool.swift
//  Union
//
//  Created by 万联 on 16/4/8.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class AFNetWorkingTool: NSObject {
    
    //单利
//    private static let shareInstance = AFNetWorkingTool();
//    class var shareManager:AFNetWorkingTool {
//        return shareInstance;
//    }

    static func getDataFromNet(url:String,params:NSDictionary,success:((responseObject:AnyObject)->Void),failure:((error:NSError)->Void)){

        let manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager();
        manager.requestSerializer.willChangeValueForKey("timeoutInterval");
        manager.requestSerializer.timeoutInterval = 10;
        manager.requestSerializer.didChangeValueForKey("timeoutInterval");
        
        manager.operationQueue.cancelAllOperations();
        
//        [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];﻿﻿
        let set :Set = NSSet(objects: "application/json","text/html","text/json","text/javascript") as Set;
        
        manager.responseSerializer.acceptableContentTypes = set;
        manager.GET(url, parameters: params, success: { (operation, responseObject) -> Void in
          
            
                success(responseObject: responseObject);
            
            
            }) { (operation, error) -> Void in
                
                
                failure(error: error);
        }

    }
    
    
    static func postDataFromNet(url:String,params:NSDictionary,success:((responseObject:AnyObject)->Void),failure:((error:NSError)->Void)){
        
        let manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager();
        manager.requestSerializer.willChangeValueForKey("timeoutInterval");
        manager.requestSerializer.timeoutInterval = 10;
        manager.requestSerializer.didChangeValueForKey("timeoutInterval");
        
        manager.POST(url, parameters: params, success: { (operation, responseObject) -> Void in
            success(responseObject: responseObject);
            }) { (operation, error) -> Void in
                
                failure(error: error);
        }
        
    }

    
    
    
    

}
