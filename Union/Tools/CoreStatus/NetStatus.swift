//
//  NetStatus.swift
//  Union
//
//  Created by 万联 on 16/4/13.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

@objc protocol CoreStatusProtocol:NSObjectProtocol{

    optional func coreNetworkChangeNoti(noti:NSNotification)


}


let CoreStatusChangedNoti = "CoreStatusChangedNoti";

class NetStatus: NSObject {
    
    var isNoti:Bool = false;
    
    
    private static let instance:NetStatus = NetStatus();
    class var sharedInstance:NetStatus {
        return instance
    }
    
    
    lazy var networkReachabilityManeger:AFNetworkReachabilityManager = {
        let manager:AFNetworkReachabilityManager = AFNetworkReachabilityManager.sharedManager();
        manager.startMonitoring();
        return manager;
        
    }()
    
    static func currentNetworkStatus(){
      
        let status = NetStatus.sharedInstance;
        status.statusWithRadioAccessTechnology();
        
    
    }
    
    private func statusWithRadioAccessTechnology(){
    
        self.networkReachabilityManeger.setReachabilityStatusChangeBlock {[weak self] (status) -> Void in
            
//            if (status == AFNetworkReachabilityStatus.No;tReachable) {
//                print("Not")
//            }
//            if (status == AFNetworkReachabilityStatus.ReachableViaWWAN) {
//                print("WAN")
//            }
//            if (status == AFNetworkReachabilityStatus.ReachableViaWiFi) {
//                print("WIFI")
//                print(self.networkReachabilityManeger.reachableViaWiFi);
//            }
//            if (status == AFNetworkReachabilityStatus.Unknown) {
//               print("909 ===>>> Unknown")
//            }
            
        }
        
    
        
    
    }
    
    //开始监听
    static func startMonitoringNetWork(listener:CoreStatusProtocol){
    
        let statue = NetStatus.sharedInstance;
        if statue.isNoti{
           NSLog("CoreStatus已经处于监听中，请检查其他页面是否关闭监听!");
            self.stopMonitoringNetWork(listener);
        }
        
        NSNotificationCenter.defaultCenter().addObserver(listener, selector: Selector("coreNetworkChangeNoti:"), name: CoreStatusChangedNoti, object: nil);
        
         NSNotificationCenter.defaultCenter().addObserver(statue, selector: Selector("coreNetworkStatusChanged:"), name: AFNetworkingReachabilityDidChangeNotification, object: nil);
        
        
        statue.networkReachabilityManeger.startMonitoring();
        statue.statusWithRadioAccessTechnology();
        statue.isNoti = true;
    
    }
    //结束监听
    static func stopMonitoringNetWork(listener:CoreStatusProtocol){
     
        let statue = NetStatus.sharedInstance;
        if !statue.isNoti{
            NSLog("CoreStatus监听已经被关闭"); return;
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(statue, name: AFNetworkingReachabilityDidChangeNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().removeObserver(listener, name: CoreStatusChangedNoti, object: nil);
        
        statue.networkReachabilityManeger.stopMonitoring();
      
    }
    

}
extension NetStatus{
    
    func coreNetworkStatusChanged(notice:NSNotification){
    
    
    }



}


