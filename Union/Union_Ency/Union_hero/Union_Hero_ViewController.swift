//
//  Union_Hero_ViewController.swift
//  Union
//
//  Created by 万联 on 16/4/22.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class Union_Hero_ViewController: UIViewController {

    var allView:Union_Hero_AllHeroView?
   
    lazy var tabView:TabView = {
    
        let tView:TabView = TabView(frame: CGRectMake(0,0,self.view.frame.size.width,40));
        tView.dataArray = ["免费英雄","我的英雄","全部英雄"];
        return tView;
    
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor();
        self.title = "英雄";
        self.view.addSubview(self.tabView);
        
        self.tabView.tabIndex_Block = {(selecteIndex)->Void in
        
        
        }
        
        
        self.allView = Union_Hero_AllHeroView(frame: CGRectMake(0,40,CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame) - 64 - 40));
        self.allView?.attachVc = self;
        self.allView?.heroDetailBlock = {[weak self](heroName)->Void in
        
            let union_Hero_Vc = Union_Hero_Details_Controller()
            
            self?.presentViewController(union_Hero_Vc, animated: false, completion: { () -> Void in
                
            })
        
        
        }
        self.view.addSubview(self.allView!);
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
