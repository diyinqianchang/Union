//
//  SettingManager.swift
//  Union
//
//  Created by 万联 on 16/4/11.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

private let instance = SettingManager();

enum SaveFlowSettingType:Int{

    case AllNetWorking = 0,OnlyWiFi,Close

}



class SettingManager: NSObject {
    
    class var sharedInstance:SettingManager {
        return instance;
    }
    
    
    func loadImageAccordingToTheSetType()->Bool{
    
    
        let defaults = NSUserDefaults.standardUserDefaults();
        
        let type:NSNumber? = defaults.objectForKey("setting_saveflow_selectedindexpath") as! NSNumber?
        
        
        if type != nil{
        
        switch type!{
        
        case SaveFlowSettingType.AllNetWorking.rawValue:
                return true;
                break;
            case SaveFlowSettingType.OnlyWiFi.rawValue:
                
                let currentStatus = NetStatus.currentNetworkStatus();
                if currentStatus == CoreNetWorkStatus.Wifi{
                    return true;
                
                }else{
                  return false;
                }

                break;
            case SaveFlowSettingType.Close.rawValue:
                return false;
                break;
        default:
            return true;
            break;
        }
    
        }else{
        
            return true;
        }
    }
    
    
    
    
    
    func playSoundAccordingToTheSetType(){
    
    
        let defaults = NSUserDefaults.standardUserDefaults();
        if defaults.objectForKey("setting_messagepush_isvibration") != nil{
            let isVibration = defaults.objectForKey("")?.boolValue;
            if isVibration! {
                let lxplay = LXPlaySound();
                lxplay.play();
            }
            
        }
        if defaults.objectForKey("setting_messagepush_issound") != nil{
        
            let isSound = defaults.objectForKey("")?.boolValue;
            if isSound!{
            
                let lxplay = LXPlaySound(resouseName: "Tock", type: "caf");
                lxplay.play();
            
            }
        
        }
    
    }
    func downloadViewHiddenOrShow(isHidden:Bool){
        
        let app = UIApplication.sharedApplication().delegate as! AppDelegate;
        
        if isHidden{
        
            app.downloadVC.hidden = true;
          
        }else{
        
            app.downloadVC.hidden = false;
          
        }
    }

}
