//
//  EncyItemView.swift
//  Union
//
//  Created by 万联 on 16/4/22.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class EncyItemView: UIView {
    
    
    var imageView:UIImageView?
    var label:UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.whiteColor();
        
        self.imageView = UIImageView();
        self.addSubview(self.imageView!);
        
        self.label = UILabel();
        self.label?.textColor = UIColor.lightGrayColor();
        self.label?.textAlignment = .Center;
        self.label?.font = UIFont.systemFontOfSize(14);
        self.addSubview(label!);
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        
        self.imageView?.frame = CGRectMake(CGRectGetWidth(self.frame) / 7.0, CGRectGetWidth(self.frame) / 7.0, CGRectGetWidth(self.frame) / 7.0 * 5, CGRectGetWidth(self.frame) / 7.0 * 5);
        self.label?.frame = CGRectMake(0, CGRectGetWidth(self.frame) / 7.0 * 6, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame) / 7.0);
        
    }
    
    var model:EncyModel = EncyModel(name: "", iconName: ""){
    
        willSet{
        
            if self.model != newValue{
                self.model = newValue;
            }
        
        }
        didSet{
        
            self.imageView?.image = UIImage(named: model.iconName!)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
            self.label?.text = model.name!
        
        }
    
    }
    
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    

}
