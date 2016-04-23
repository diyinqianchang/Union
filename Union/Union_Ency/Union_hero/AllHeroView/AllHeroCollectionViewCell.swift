//
//  AllHeroCollectionViewCell.swift
//  Union
//
//  Created by 万联 on 16/4/23.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class AllHeroCollectionViewCell: UICollectionViewCell {
    
    
    var picImageView:UIImageView?
    var titleLabel:UILabel?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.backgroundColor = UIColor.whiteColor();
        self.picImageView = UIImageView(frame: CGRectMake(0,10,CGRectGetWidth(self.frame),CGRectGetWidth(self.frame)));
        self.contentView.addSubview(self.picImageView!);
        
        self.titleLabel = UILabel(frame: CGRectMake(0,CGRectGetWidth(self.frame) + 15,CGRectGetWidth(self.frame),20));
        self.titleLabel?.font = UIFont.systemFontOfSize(14);
        self.titleLabel?.textAlignment = .Center;
        self.titleLabel?.numberOfLines = 0;
        self.contentView.addSubview(self.titleLabel!);
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func fillCellWithModel(model:ListHeroMode){
    
    
        let picURL = NSString(format: kUnion_Ency_HeroImageURL, model.enName!) as String;
        
        self.picImageView?.sd_setImageWithURL(NSURL(string: picURL), placeholderImage: UIImage(named: "iconfont-myself"));
        self.titleLabel?.text = model.title!
        
        
    }
    
    
    
    
    
    
    
}
