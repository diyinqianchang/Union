//
//  Union_NewsViewController.swift
//  Union
//
//  Created by 万联 on 16/4/7.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class Union_NewsViewController: UIViewController {

    var tabView:TabView = {
    
        let tabArray = ["头条","视频","赛事","靓照","囧图","壁纸"];
        
        let tabView = TabView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 40));
        tabView.dataArray = tabArray;
        return tabView;
    
    }();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tabView);
        self.tabView.tabIndex_Block = ({(selectIndex:NSInteger)->Void in
        
            let se = selectIndex;
            print(se);
            
        });

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
