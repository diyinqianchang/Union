//
//  LXPlaySound.swift
//  Union
//
//  Created by 万联 on 16/4/11.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit
import AudioToolbox

class LXPlaySound: NSObject {
    
    private var soundID:SystemSoundID?
    
    override init() {
        super.init();
        soundID = kSystemSoundID_Vibrate;
    }
    init(resouseName:String,type:String) {
        super.init();
        let path :String? = NSBundle(identifier: "com.apple.UIKit")?.pathForResource(resouseName, ofType: type);
        if path != nil{
           
            let theSoundId:UnsafeMutablePointer<SystemSoundID> = UnsafeMutablePointer<SystemSoundID>.alloc(10);
            
            let error:OSStatus = AudioServicesCreateSystemSoundID(NSURL(fileURLWithPath: path!), theSoundId);
            if error == kAudioServicesNoError{
            
                self.soundID = theSoundId.memory;
                
            }else{NSLog("创建声音失败")}
        
        }
        
    }
    
    init(fileName:String) {
        super.init();
        let fileURL:NSURL? = NSBundle.mainBundle().URLForResource(fileName, withExtension: nil);
        if fileURL != nil{
        
            let theSoundId:UnsafeMutablePointer<SystemSoundID> = UnsafeMutablePointer<SystemSoundID>.alloc(10);
            
            let error:OSStatus = AudioServicesCreateSystemSoundID(fileURL!, theSoundId);
            if error == kAudioServicesNoError{
                
                self.soundID = theSoundId.memory;
                
            }else{NSLog("创建声音失败")}

            
        }
    }
    func play(){
    
        AudioServicesPlaySystemSound(self.soundID!);
    
    }
    deinit{
        
        AudioServicesDisposeSystemSoundID(self.soundID!);
    }
    

}
