//
//  BaseTabBarController.swift
//  Union
//
//  Created by 万联 on 16/4/7.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    var newsVc:Union_NewsViewController?
    var videoVc:Union_VideoViewController?
    var encyVc:Union_EncyViewController?
    var myUnVc:Union_MyUnionViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsVc = Union_NewsViewController();
        self.addChildViewController(newsVc!, title: "联盟资讯", imageName: "iconfont-news", nVcTitle: "资讯");
        videoVc = Union_VideoViewController();
        self.addChildViewController(videoVc!, title: "视频直播", imageName: "iconfont-shipin", nVcTitle: "视频");
        encyVc  = Union_EncyViewController();
        self.addChildViewController(encyVc!, title: "联盟百科", imageName: "iconfont-ency", nVcTitle: "百科");
        myUnVc = Union_MyUnionViewController();
        self.addChildViewController(myUnVc!, title: "我的", imageName: "iconfont-myself", nVcTitle: "我");
        
        self.tabBar.translucent = false;
        self.tabBar.tintColor = MAINCOLOR;
        
    }
    
    func addChildViewController(childController: UIViewController,title:String,imageName:String,nVcTitle:String) {
        
        let nVc = UINavigationController(rootViewController: childController);
        childController.title = nVcTitle;
        nVc.tabBarItem.title = title;
        nVc.tabBarItem.image = UIImage(named: imageName);
        nVc.navigationBar.translucent = false;
        nVc.navigationBar.barTintColor = MAINCOLOR;
        nVc.navigationBar.barStyle=UIBarStyle.BlackOpaque;
        
        self.addChildViewController(nVc);

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}





