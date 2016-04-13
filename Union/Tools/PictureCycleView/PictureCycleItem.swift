//
//  PictureCycleItem.swift
//  Union
//
//  Created by 万联 on 16/4/12.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class PictureCycleItem: UIView {

    var picImageView:UIImageView?
    var titleLable:UILabel?
    var model:PictureCycleModel{
        willSet{
            
            if self.model != newValue{
                self.model = newValue;
            }
        
        }

        didSet{
            
//               print(self.model.photoUrl!);
                self.picImageView?.sd_setImageWithURL(NSURL(string: self.model.photoUrl!), placeholderImage: UIImage(named: "lollogo"))
                if self.model.picTitle != nil{
                    self.titleLable?.hidden = false;
                    self.titleLable?.text = self.model.picTitle!
                }else{
                    self.titleLable?.hidden = true;
                }
            
        }
        
    }
    override init(frame: CGRect) {
        
        self.model = PictureCycleModel();
        super.init(frame: frame);
        self.picImageView = UIImageView(image: UIImage(named: "lollogo"));
        self.addSubview(self.picImageView!);
        
        self.titleLable = UILabel(frame: CGRectMake(0,CGRectGetHeight(self.frame) - 45,CGRectGetWidth(self.frame),30));
        self.titleLable?.textColor = UIColor.whiteColor();
        self.titleLable?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4);
        self.titleLable?.textAlignment  = .Left;
        self.addSubview(self.titleLable!);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews();
        self.picImageView?.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        
        self.titleLable?.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 45 , CGRectGetWidth(self.frame), 30);
        
        
    }

}
