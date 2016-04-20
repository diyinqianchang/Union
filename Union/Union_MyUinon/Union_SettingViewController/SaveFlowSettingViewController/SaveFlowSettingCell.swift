//
//  SaveFlowSettingCell.swift
//  Union
//
//  Created by 万联 on 16/4/20.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class SaveFlowSettingCell: UITableViewCell {
    
    
    
    var titleLable:UILabel?
    var stateImgView:UIImageView?
    
    var isClicked:Bool = false{
    
        willSet{
        
            if self.isClicked != newValue{
            
                self.isClicked = newValue;
            }
        
        }
        didSet{
        
            if isClicked{
            
                self.stateImgView?.image = UIImage(named: "stateImageisYes");
            
            }else{
            
                self.stateImgView?.image = UIImage(named: "stateImageisNo");
             
            }
        
        }
    
    
    
    
    }
    var titleStr:String = ""{
    
        willSet{
        
            if self.titleStr != newValue{
                self.titleStr = newValue;
            }
        
        }
        didSet{
            self.titleLable?.text = self.titleStr;
        }
    
    
    }
    
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        self.titleLable = UILabel();
        self.contentView.addSubview(self.titleLable!);
        
        self.stateImgView = UIImageView(image: UIImage(named: "stateImageisNo"));
        self.contentView.addSubview(self.stateImgView!);
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        
        self.titleLable?.frame = CGRectMake(20, 0, CGRectGetWidth(self.frame) - 80, CGRectGetHeight(self.frame));
        
        self.stateImgView?.frame = CGRectMake(CGRectGetWidth(self.frame) - 50, 0, 32, 32);
        
        self.stateImgView?.center = CGPointMake(self.stateImgView!.center.x, CGRectGetHeight(self.frame) / 2);
        
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
