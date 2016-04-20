//
//  ReloadImageView.swift
//  Union
//
//  Created by 万联 on 16/4/20.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

typealias ReloadImgBlock = ()->Void;

class ReloadImageView: UIImageView {

    var reloadImgBlock:ReloadImgBlock?
    
    override init(var frame: CGRect) {
        
        if frame.size.height < 200 || frame.size.width < 200{
        
            frame.size.height = 200;
            frame.size.width = 200;
        }
        super.init(frame: frame);
        
        let tap:UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: Selector("reloadImageViewTapAction:"));
        self.addGestureRecognizer(tap);
        
        self.center = CGPointMake(SCREEN_WIDTH / 2.0,SCREEN_HEIGHT / 2.0);
        self.image = UIImage(named: "reloadImage");
        self.tintColor = UIColor.lightGrayColor();
        self.backgroundColor = UIColor.clearColor();
        self.hidden = true;
        self.userInteractionEnabled = true;
        
    }
    
    func reloadImageViewTapAction(tap:UITapGestureRecognizer){
    
        
        if self.reloadImgBlock != nil{
        
           self.reloadImgBlock!();
        }
    
    
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
