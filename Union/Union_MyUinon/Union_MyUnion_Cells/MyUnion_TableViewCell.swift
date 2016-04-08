//
//  MyUnion_TableViewCell.swift
//  Union
//
//  Created by 万联 on 16/4/8.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class MyUnion_TableViewCell: UITableViewCell {

    var titleStr:String{
    
        willSet{
        
            if self.titleStr != newValue{
            
                self.titleStr = newValue;
            }
        
        
        }
        
        didSet{
        
            self.titleLabel?.text = self.titleStr;
        
        }
    
    
    }
    var detailStr:String{
    
        willSet{
            
            if self.detailStr != newValue{
                
                self.detailStr = newValue;
            }
            
            
        }
        
        didSet{
            
            self.detailTitleLabel?.text = self.detailStr;
            
        }

    
    }
    
    var titleLabel:UILabel?
    var detailTitleLabel:UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        self.titleStr = String();
        self.detailStr = String();
        
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        self.titleLabel = UILabel();
        self.titleLabel?.textColor = UIColor.grayColor();
        self.addSubview(self.titleLabel!);
        
        self.detailTitleLabel = UILabel();
        self.detailTitleLabel?.textAlignment = .Right;
        self.detailTitleLabel?.font = UIFont.systemFontOfSize(14);
        self.detailTitleLabel?.textColor = UIColor.lightGrayColor();
        self.addSubview(self.detailTitleLabel!);
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews();
        
        self.titleLabel?.frame = CGRectMake(20, 0, CGRectGetWidth(self.frame)-10-100-30, CGRectGetHeight(self.frame));
        
        self.detailTitleLabel?.frame = CGRectMake(CGRectGetWidth(self.frame) - 20 - 100 - 30, 0,100, CGRectGetHeight(self.frame));
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    deinit{
    
        print("释放")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
            }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
