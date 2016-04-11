//
//  SettingManager.swift
//  Union
//
//  Created by 万联 on 16/4/11.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

private let instance = SettingManager();

class SettingManager: NSObject {
    
    class var sharedInstance:SettingManager {
        return instance;
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
