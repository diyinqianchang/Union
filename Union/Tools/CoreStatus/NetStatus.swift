//
//  NetStatus.swift
//  Union
//
//  Created by 万联 on 16/4/13.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit
import CoreTelephony


@objc protocol CoreStatusProtocol:NSObjectProtocol{

    optional func coreNetworkChangeNoti(noti:NSNotification)


}


let CoreStatusChangedNoti = "CoreStatusChangedNoti";

class NetStatus: NSObject {
    
    var isNoti:Bool = false;
    
   override static func initialize(){
       super.initialize();
       
    }
    
    //类的单利
    private static let instance:NetStatus = NetStatus();
    class var sharedInstance:NetStatus {
        return instance
    }
    
    //获取Reachability
    lazy var networkReachabilityManeger:Reachability = {
        let manager:Reachability = Reachability.reachabilityForInternetConnection()
        return manager;
        
    }()
    //在5上不行的
    lazy var telephonyNetworkInfo:CTTelephonyNetworkInfo = {
        
        let netInfo:CTTelephonyNetworkInfo = CTTelephonyNetworkInfo();
        return netInfo;
    
    }()
    
    lazy var netWorkStatusStringArr:Array<String> = {
        //未知网络
        /** 无网络 *//** 蜂窝网络 *//** Wifi网络 *//** 2G网络*//** 3G网络 *//** 4G网络 */
        let arr:Array<String> = ["未知网络","无网络","蜂窝网络","Wifi网络","2G网络","3G网络","4G网络"];
        return arr;
    }();
    
    static func currentNetworkStatus()->CoreNetWorkStatus{
      
        let status = NetStatus.sharedInstance;
        return status.statusWithRadioAccessTechnology();
    }
    
    static func currentNetworkStatusString()->String{
   
        let status = NetStatus.sharedInstance;
        
        let statusArr = status.netWorkStatusStringArr;
        
        let netStatus:Int = (self.currentNetworkStatus()).rawValue;
        
        return statusArr[netStatus];
        
    }
    
    
    private func statusWithRadioAccessTechnology()->CoreNetWorkStatus{
    
        let netStatus:NetworkStatus = self.networkReachabilityManeger.currentReachabilityStatus()
        
        let technology:String? = nil // = self.telephonyNetworkInfo.currentRadioAccessTechnology;
        
        if netStatus == NotReachable{
            return CoreNetWorkStatus.None;
        }else if netStatus == ReachableViaWiFi{
            return CoreNetWorkStatus.Wifi;
        }else {
            if technology != nil{
                if self.technology2GArray().contains(technology!){
                    return .Status2G;
                }else if self.technology3GArray().contains(technology!){
                    return .Status3G;
                }else if self.technology4GArray().contains(technology!){
                    return .Status4G;
                }
            }
            return CoreNetWorkStatus.WWAN;
        }
    }
    
    //开始监听
    static func startMonitoringNetWork(listener:CoreStatusProtocol){
    
        let status = NetStatus.sharedInstance;
        
        if status.isNoti{
           NSLog("CoreStatus已经处于监听中，请检查其他页面是否关闭监听!");
            self.stopMonitoringNetWork(listener);
        }
        
        NSNotificationCenter.defaultCenter().addObserver(listener, selector: Selector("coreNetworkChangeNoti:"), name: CoreStatusChangedNoti, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(status, selector: Selector("coreNetworkStatusChanged:"), name: kReachabilityChangedNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(status, selector: Selector("coreNetworkStatusChanged:"), name: CTRadioAccessTechnologyDidChangeNotification, object: nil);
        
        
        status.networkReachabilityManeger.startNotifier();
        status.isNoti = true;
    
    }
    //结束监听
    static func stopMonitoringNetWork(listener:CoreStatusProtocol){
     
        let status = NetStatus.sharedInstance;
        if !status.isNoti{
            NSLog("CoreStatus监听已经被关闭"); return;
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(status, name: kReachabilityChangedNotification, object: nil);
        NSNotificationCenter.defaultCenter().removeObserver(status, name: CTRadioAccessTechnologyDidChangeNotification, object: nil);
        NSNotificationCenter.defaultCenter().removeObserver(listener, name: CoreStatusChangedNoti, object: status);
        status.networkReachabilityManeger.stopNotifier();
        status.isNoti = false;
      
    }
   
    

}
extension NetStatus{
    
    func coreNetworkStatusChanged(notice:NSNotification){
      
        let userInfo:NSDictionary = ["currentStatusEnum":NetStatus.currentNetworkStatus().rawValue,"currentStatusString":NetStatus.currentNetworkStatusString()];
        NSNotificationCenter.defaultCenter().postNotificationName(CoreStatusChangedNoti, object: self, userInfo: userInfo as [NSObject : AnyObject]);
    }
    
    func technology2GArray()->Array<String>{
        return [CTRadioAccessTechnologyEdge,CTRadioAccessTechnologyGPRS];
    }
    
    func technology3GArray()->Array<String>{
        return [CTRadioAccessTechnologyHSDPA,CTRadioAccessTechnologyWCDMA,
                CTRadioAccessTechnologyHSUPA,CTRadioAccessTechnologyCDMA1x,
                CTRadioAccessTechnologyCDMAEVDORev0,CTRadioAccessTechnologyCDMAEVDORevA,
                CTRadioAccessTechnologyCDMAEVDORevB,CTRadioAccessTechnologyeHRPD];
    }

    func technology4GArray()->Array<String>{
        return [CTRadioAccessTechnologyLTE];
    }

}