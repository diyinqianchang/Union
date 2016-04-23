//
//  Union_Hero_Details_Controller.swift
//  Union
//
//  Created by 万联 on 16/4/23.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class Union_Hero_Details_Controller: UIViewController {

    var menuBtn:UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
    }
    
    func loadMenuButton(){
    
        self.menuBtn = UIButton(type: UIButtonType.Custom);
        self.menuBtn?.backgroundColor = UIColor.clearColor();
    
    
    
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
