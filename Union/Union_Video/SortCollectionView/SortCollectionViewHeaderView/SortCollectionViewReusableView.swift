//
//  SortCollectionViewReusableView.swift
//  Union
//
//  Created by 万联 on 16/4/22.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

typealias VideoReusableViewSearchBlock = (videoName:String) ->Void;

class SortCollectionViewReusableView: UICollectionReusableView {
    
    var reusableViewSearchBlock:VideoReusableViewSearchBlock?
    var myHeaderLabel:UILabel?
//    var button:UIButton?
    var textField:UITextField?
    
    
    var lineView:UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.backgroundColor = UIColor.whiteColor();
        
        self.myHeaderLabel = UILabel();
        self.myHeaderLabel?.textColor = UIColor.lightGrayColor();
        self.myHeaderLabel?.font = UIFont.systemFontOfSize(15);
        self.addSubview(self.myHeaderLabel!);

        self.textField = UITextField();
        self.textField?.placeholder = "请输入关键字";
        self.textField?.textAlignment = .Center;
        self.textField?.borderStyle = .RoundedRect;
        self.textField?.delegate = self;
        self.textField?.returnKeyType = UIReturnKeyType.Default;
        self.textField?.adjustsFontSizeToFitWidth = true;
        self.textField?.clearsOnBeginEditing = true;
        self.textField?.clearButtonMode = .Always;
        self.addSubview(self.textField!);
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        
        self.myHeaderLabel?.frame = CGRectMake(10, self.frame.size.height - 25, self.frame.size.width - 20, 20);
        
        self.textField?.frame = CGRectMake(10, 10, self.frame.size.width - 20, 30);
        
    }
    
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 2);
        CGContextSetRGBStrokeColor(context, 240/255.0, 240/255.0, 240/255.0, 1.0);
        CGContextMoveToPoint(context, 10, self.myHeaderLabel!.frame.origin.y - 2);
        CGContextAddLineToPoint(context, rect.size.width - 10, self.myHeaderLabel!.frame.origin.y - 2)
        CGContextStrokePath(context);
        
        
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension SortCollectionViewReusableView:UITextFieldDelegate{

    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField.text != ""{
            self.reusableViewSearchBlock!(videoName:textField.text!);
            textField.text = "";
        }
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }




}
