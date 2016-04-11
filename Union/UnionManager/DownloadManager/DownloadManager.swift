//
//  DownloadManager.swift
//  Union
//
//  Created by 万联 on 16/4/11.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class DownloadManager: NSObject {
    
    private static let instance = DownloadManager();
    class var sharedInstance:DownloadManager {
        return instance;
    }
    
    static func totleDiskSpace()->NSNumber{
    
        let manager = NSFileManager.defaultManager()
        var size:NSNumber?
        do{
            let fattributes:NSDictionary = try manager.attributesOfFileSystemForPath(NSHomeDirectory());
            size = fattributes.objectForKey(NSFileSystemSize) as? NSNumber;
            print(fattributes.objectForKey(NSFileSystemSize));
        }catch{
            print("error");
        }
        return size!;
    }
    
    static func freeDiskSpace()->NSNumber{
    
        let manager = NSFileManager.defaultManager()
        var size:NSNumber?
        do{
            let fattributes:NSDictionary = try manager.attributesOfFileSystemForPath(NSHomeDirectory());
            size = fattributes.objectForKey(NSFileSystemFreeSize) as? NSNumber;
            print(fattributes.objectForKey(NSFileSystemFreeSize));
        }catch{
            print("error");
        }
        return size!;
    
    
    }

}
