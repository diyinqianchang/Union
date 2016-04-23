//
//  ContextMenuCell.swift
//  Union
//
//  Created by 万联 on 16/4/23.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit





class ContextMenuCell: UITableViewCell,LXContextMenuCell{

    @IBOutlet weak var menuTitleLabel: UILabel!
    @IBOutlet weak var menuImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .None;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowColor = RGB(181, g: 181, b: 181).CGColor;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        self.tintColor = MAINCOLOR;
        
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    func animatedIcon() ->UIView{
    
        return self.menuImageView;
    
    }
    func animatedContent() ->UIView{
    
        return self.menuTitleLabel;
    
    }
    
    
}
