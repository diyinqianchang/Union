//
//  ClearCacheSettingCell.swift
//  Union
//
//  Created by 万联 on 16/4/12.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class ClearCacheSettingCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var titleLable:UILabel?
    var detailTitleLabel:UILabel?
    var stateSwitch:UISwitch?
    
    var isClear:Bool{
    
        willSet{
        
            if self.isClear != newValue{
                self.isClear = newValue;
            }
        }
        didSet{
            self.stateSwitch?.on = self.isClear;
        }
    
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        self.isClear = false;
        
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        self.titleLable = UILabel();
        self.titleLable?.textColor = UIColor.blackColor();
        self.contentView.addSubview(self.titleLable!);
        
        self.detailTitleLabel = UILabel();
        self.detailTitleLabel?.textColor = UIColor.grayColor();
        self.detailTitleLabel?.textAlignment = .Right;
        self.detailTitleLabel?.font = UIFont.systemFontOfSize(16);
        self.contentView.addSubview(self.detailTitleLabel!);
        
        self.stateSwitch = UISwitch();
        self.stateSwitch?.on = true;
        self.stateSwitch?.onTintColor = MAINCOLOR;
        self.stateSwitch?.addTarget(self, action: Selector("switchViewAction:"), forControlEvents: UIControlEvents.ValueChanged);
        self.contentView.addSubview(self.stateSwitch!);
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        let rect = self.frame;
        self.titleLable?.frame = CGRectMake(20, 0, rect.size.width - 10 - 160 - 30, rect.size.height);
        self.detailTitleLabel?.frame = CGRectMake(CGRectGetMaxX(self.titleLable!.frame) + 10, 0, 80,rect.size.height)
        self.stateSwitch?.frame = CGRectMake(CGRectGetMaxX(self.detailTitleLabel!.frame) + 10, 0, 80, rect.size.height);
        self.stateSwitch?.center = CGPointMake(self.stateSwitch!.center.x,rect.size.height / 2);
    }
    
    func switchViewAction(sw:UISwitch){
    
        self.isClear = sw.on;
    
    }
    
    
    

}
