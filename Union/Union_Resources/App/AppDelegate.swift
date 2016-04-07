//
//  AppDelegate.swift
//  Union
//
//  Created by 万联 on 16/4/7.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var baseTabBarVc:BaseTabBarController?
    lazy var downloadVC:DownloadView = {
    
        let downV:DownloadView = DownloadView(frame: CGRectMake(CGRectGetWidth(self.window!.frame) - 80 , self.window!.frame.size.height - 190, 60, 60));
        downV.backgroundColor = UIColor.clearColor();
        return downV;
    
    }();

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds);
        self.window?.backgroundColor = UIColor.whiteColor();
        self.window?.makeKeyAndVisible();
        baseTabBarVc = BaseTabBarController();
        self.window?.rootViewController = baseTabBarVc!;
        
        self.loadDownloadView();
        self.loadstartImage();
        
        MobClick.startWithAppkey("55d4404ae0f55a066500096e", reportPolicy:BATCH, channelId: "");
        let version:String = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String;
        MobClick.setAppVersion(version);
        UMFeedback.setAppkey("55d4404ae0f55a066500096e");
       
        return true
    }
    
    func loadDownloadView(){
        self.window?.addSubview(self.downloadVC);
        self.window?.bringSubviewToFront(self.downloadVC);
        
        let isShowDownLoad = true;
        if isShowDownLoad{
        
            let defaults = NSUserDefaults.standardUserDefaults();
            var isHiddenDownloadView = false;
            
            
            
            if(defaults.objectForKey("settingDownloadviewHiddenOrShow") != nil){
                isHiddenDownloadView = (defaults.objectForKey("settingDownloadviewHiddenOrShow")?.boolValue)!;
            }
            if isHiddenDownloadView{
                self.downloadVC.hidden = true;
            }else{
                self.downloadVC.hidden = false;
            }
            
        }else{
         
            self.downloadVC.hidden = true;
        
        }
        
    
    
    }
    
    //加载启动图片
    func loadstartImage(){
    
        let icon:UIImage = UIImage(named: "startImage")!;
       
        let color = MAINCOLOR;
        let splashView = CBZSplashView(icon: icon, backgroundColor: color);
        splashView.iconStartSize = CGSizeMake(300, 180);
        splashView.animationDuration = 1.4;
        splashView.iconColor = UIColor.blackColor();
        
        self.window?.addSubview(splashView);
        GCDQueue.executeInMainQueue({ () -> Void in
            splashView.startAnimation();
            }, afterDelaySeconds: 0.5);
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
//            splashView.startAnimation();
//        });
        
    }
    func openDownloadVC(){
    
    
    }
    
    func applicationWillResignActive(application: UIApplication) {
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
       
    }

    func applicationWillEnterForeground(application: UIApplication) {
       
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
    }

    func applicationWillTerminate(application: UIApplication) {
        
    }

}

extension AppDelegate:UITabBarControllerDelegate{

    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        let transiton:CATransition = CATransition();
        transiton.type = kCATransitionFade;
        baseTabBarVc!.view.layer.addAnimation(transiton, forKey: nil);
    }

}


