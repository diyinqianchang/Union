//
//  SettingViewCell.swift
//  Union
//
//  Created by 万联 on 16/4/11.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

enum SettingCellStyle{

    case SettingCellStyleLabel
    case SettingCellStyleSwitch

}


class SettingViewCell: UITableViewCell {

    var titleLabel:UILabel?
    var detailLabel:UILabel?
    var stateSwitch:UISwitch?
    var isOpen:Bool{
        willSet{
            if self.isOpen != newValue{
                self.isOpen = newValue;
            }
        }
        didSet{
            self.stateSwitch?.on = self.isOpen;
        }
    }
    var style:SettingCellStyle{
    
        willSet{
        
            if self.style != newValue{ self.style = newValue }
        }
        didSet{
        
            if self.style == SettingCellStyle.SettingCellStyleLabel{
                self.stateSwitch?.hidden = true;
                self.detailLabel?.hidden = false;
                self.accessoryType = .DisclosureIndicator;
            }else{
                self.stateSwitch?.hidden = false;
                self.detailLabel?.hidden = true;
                self.accessoryType = .None;
            }
        }
    
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        self.isOpen = Bool();
        self.style = SettingCellStyle.SettingCellStyleLabel;
        
        
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        self.titleLabel = UILabel();
        self.titleLabel?.textColor = UIColor.grayColor();
        self.addSubview(self.titleLabel!);
        
        self.detailLabel = UILabel();
        self.detailLabel?.textAlignment = .Right;
        self.detailLabel?.font = UIFont.systemFontOfSize(14);
        self.detailLabel?.textColor = UIColor.lightGrayColor();
        self.addSubview(self.detailLabel!);
        
        self.stateSwitch = UISwitch();
        self.stateSwitch?.on = false;
        self.stateSwitch?.onTintColor = MAINCOLOR;
        self.stateSwitch?.addTarget(self, action: Selector("stateSwitchAction:"), forControlEvents: .ValueChanged);
        self.addSubview(self.stateSwitch!);
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        self.titleLabel?.frame = CGRectMake(20, 0, CGRectGetWidth(self.frame) - 10 - 150 - 30, CGRectGetHeight(self.frame));
        self.detailLabel?.frame = CGRectMake(CGRectGetWidth(self.frame) - 20 - 150 - 30, 0, 150, CGRectGetHeight(self.frame));
        self.stateSwitch?.frame = CGRectMake(CGRectGetWidth(self.frame) - 80, 0, 80, CGRectGetHeight(self.frame));
        self.stateSwitch?.center = CGPointMake(self.stateSwitch!.center.x, CGRectGetHeight(self.frame) / 2);
    }
    
    
    func stateSwitchAction(sw:UISwitch){
    
        let defaults = NSUserDefaults.standardUserDefaults();
        
        defaults.setObject(NSString(format: "%d", sw.on), forKey: "settingDownloadviewHiddenOrShow");
        defaults.synchronize();
        
        SettingManager.sharedInstance.downloadViewHiddenOrShow(sw.on);
    
    }

}
















