//
//  SortCollectionViewCell.swift
//  Union
//
//  Created by 万联 on 16/4/22.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class SortCollectionViewCell: UICollectionViewCell {
    
    var imageView:UIImageView?
    var titleLabel:UILabel?
    var upDataLabel:UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.imageView = UIImageView(frame: CGRectMake(0,0,self.frame.size.width,self.frame.size.height - 20));
        self.imageView?.image = UIImage(named: "poluoimage_gray");
        self.contentView.addSubview(self.imageView!);
        
        self.titleLabel = UILabel(frame: CGRectMake(0,self.frame.size.height - 20,self.frame.size.width,20));
        self.titleLabel?.textAlignment = .Center;
        self.titleLabel?.font = UIFont.systemFontOfSize(12);
        self.titleLabel?.textColor = UIColor.grayColor();
        self.contentView.addSubview(self.titleLabel!);
        
        self.upDataLabel = UILabel(frame: CGRectMake(0,self.imageView!.frame.size.width - 20,self.frame.size.width,20));
        self.upDataLabel?.textAlignment = .Right;
        self.upDataLabel?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7);
        self.upDataLabel?.font = UIFont.systemFontOfSize(14);
        self.upDataLabel?.textColor = UIColor.whiteColor();
        self.contentView.addSubview(self.upDataLabel!);
        
        
        
    }
    
    func fillCellWithModel(model:SortModel){
    
        let url = NSURL(string: model.icon!);
        self.imageView?.sd_setImageWithURL(url, placeholderImage: UIImage(named: "poluoimage_gray"));
        
        if model.dailyUpdate == "0"{
            self.upDataLabel?.hidden = true;
        }else{
            self.upDataLabel?.hidden = false;
        }
        
        self.titleLabel?.text = model.name!;
        
        let dailInt = (model.dailyUpdate! as NSString).integerValue;
        
        var str:String?
        if dailInt > 99{
            str = NSString(format: "最新%d+个", dailInt) as String;
        }else{
           str = NSString(format: "最新%d+个", dailInt) as String;
        }
        
        let strAttribute = NSMutableAttributedString(string: str!)
        
        strAttribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, 2));
        strAttribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange((str! as NSString).length - 1, 1))
         strAttribute.addAttribute(NSForegroundColorAttributeName, value: MAINCOLOR, range: NSMakeRange(2,(str! as NSString).length - 3))
        
        self.upDataLabel?.attributedText = strAttribute;
        
        
    
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
