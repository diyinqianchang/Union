//
//  FilterMenuItem.swift
//  Union
//
//  Created by 万联 on 16/4/22.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit


typealias MenuItemBlock = (itemIndex:NSInteger)->Void
typealias ButtonBlock = (buttonTitle:String,type:String) -> Void


class FilterMenuItem: UIView {

    var itemIndex:NSInteger = 0{
    
        willSet{
        
            if self.itemIndex != newValue{
            
                self.itemIndex = newValue;
            }
        
        }
        didSet{
        
        
        }
    
    
    }
    var selectecColor:UIColor = UIColor.clearColor(){
    
        willSet{
        
            if self.selectecColor != newValue{
                self.selectecColor = newValue;
            }
        }
        didSet{
           
            let defaultButton = self.contentView?.viewWithTag(5000) as! UIButton;
            defaultButton.backgroundColor = self.selectecColor;
            defaultButton.selected = true;
        
        }
    
    
    }
    var isSelected:Bool = false{
    
        willSet{
        
            if self.isSelected != newValue{
            
                self.isSelected = newValue;
            }
        
        }
        didSet{
            
            if isSelected{
            
                self.backgroundColor = self.contentView?.backgroundColor;
                UIView.animateWithDuration(0.25, animations: {[weak self] () -> Void in
                    self?.frame = CGRectMake(0, 0, (self?.contentView!.frame.size.width)!, (self?.frame.size.height)! + (self?.contentViewHeight!)!);
                    self?.contentView?.frame = CGRectMake((self?.contentView!.frame.origin.x)!, (self?.contentView!.frame.origin.y)!, (self?.contentView!.frame.size.width)! , (self?.contentViewHeight!)!);
                })
            
            }else{
            
                UIView.animateWithDuration(0.2, animations: {[weak self] () -> Void in
                    
                    
                    self?.frame = CGRectMake((self?.originalX)!, 0, (self?.originalWidth)!, (self?.originalHeight)!)
                    
                    self?.contentView?.frame = CGRectMake((self?.contentView!.frame.origin.x)!, (self?.contentView!.frame.origin.y)!, (self?.contentView!.frame.size.width)! , 0);
                    
                    }, completion: {[weak self] (finished) -> Void in
                        
                        self?.backgroundColor = UIColor.whiteColor();
                })
            
            }
        
        
        }
    
    
    
    }
    var selectedItemBlock:MenuItemBlock?
    var selectedButtonBlock:ButtonBlock?
    
    var originalX:CGFloat?
    var originalWidth:CGFloat?
    var originalHeight:CGFloat?
    
    var titleLabel:UILabel?
    var markImageView:UIImageView?
    var contentView:UIView?
    
    var buttonArray:NSMutableArray = NSMutableArray();
    
    var contentViewHeight:CGFloat?
    var buttonX:CGFloat?
    var buttonY:CGFloat?
    
    var fmModel:FilterMenuModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.originalX = self.frame.origin.x;
        self.originalWidth = self.frame.size.width;
        self.originalHeight = self.frame.size.height;
        
        self.titleLabel = UILabel(frame: CGRectMake(5,0,CGRectGetWidth(self.frame) - 10,CGRectGetHeight(self.frame)));
        self.titleLabel?.textColor = UIColor.grayColor();
        self.titleLabel?.textAlignment = .Center;
        self.titleLabel?.font = UIFont.systemFontOfSize(13);
        self.addSubview(self.titleLabel!);
        
        //MARK ========初始化菜单内容
        
        self.contentView = UIView(frame: CGRectMake(0,CGRectGetHeight(self.frame),SCREEN_WIDTH,0));
        self.contentView?.backgroundColor = RGB(245, g: 245, b: 245);
        self.contentView?.clipsToBounds = true;
        self.addSubview(self.contentView!);
    
        
    }
    
    func itemModel(model:FilterMenuModel){
        
        self.fmModel = model;
    
        self.titleLabel?.text = model.menuTitle!;
        self.contentViewHeight = 0;
        
        if model.menuDic?.count > 0{
        
            self.buttonX = 5;
            self.buttonY = 5;
            
            var keyID = 0;
            
            for (_,key) in model.menuDic!.allKeys.enumerate(){
            
                if key as! String == "defalut"{
                
                    self.buttonY! += CGFloat(5.0);
                    if key as! String  == ""{
                    
                        let lineView:UIView = UIView(frame: CGRectMake(5,self.buttonY!,CGRectGetWidth(self.contentView!.frame) - 10,0.5));
                        lineView.backgroundColor = UIColor.lightGrayColor();
                        self.contentView?.addSubview(lineView);
                    
                    }else{
                    
                        let groupTitle = UILabel(frame: CGRectMake(5,self.buttonY!,CGRectGetWidth(self.contentView!.frame) - 10 , 10));
                        groupTitle.textColor = UIColor.grayColor();
                        groupTitle.font = UIFont.systemFontOfSize(10);
                        groupTitle.text = key as! String;
                        self.contentView?.addSubview(groupTitle);
                    
                    
                    }
                    
                    self.buttonY! += CGFloat(25.0);
                    self.buttonX = 5;
                
                }
                
                let tempArray:NSArray = model.menuDic?.valueForKey(key as! String) as! NSArray;
                
                for(index,title) in tempArray.enumerate(){
                
                    self.loadButton(title as! String, X: self.buttonX!, Y: self.buttonY!, tag: 5000 + keyID * 100 + index);
                    self.buttonX! += (CGRectGetWidth(self.contentView!.frame) - 40) / 4.0 + 10
                    
                    if index % 4 == 0 && index < tempArray.count{
                    
                        self.buttonX = 5;
                        self.buttonY! += CGFloat(40.0);
                    
                    }
                
                }
                
                if tempArray.count > 0{
                
                    self.buttonY! += CGFloat(40.0);
                
                }
                
                keyID++
            
            }
            self.contentViewHeight = self.buttonY! - 5;
        
        
        }else{
        
            self.contentViewHeight = 0;
        }
    
    
    }
    
    func loadButton(title:String,X:CGFloat,Y:CGFloat,tag:NSInteger){
    
        let button = UIButton(type: UIButtonType.Custom);
        button.frame = CGRectMake(X, Y, (CGRectGetWidth(self.contentView!.frame) - 40) / 4, 30);
        button.tag = tag;
        button.titleLabel?.font = UIFont.systemFontOfSize(11.0);
        button.layer.borderWidth = 0.1;
        button.layer.borderColor = UIColor.lightGrayColor().CGColor;
        button.layer.cornerRadius = 3;
        button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal);
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected);
        button.setTitle(title, forState: .Normal);
        button.backgroundColor = UIColor.whiteColor();
        button.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside);
        
        self.contentView?.addSubview(button);
        self.buttonArray.addObject(button);
    }
    
    func buttonAction(btn:UIButton){
    
        if btn.tag == 5000{
            self.titleLabel?.textColor = UIColor.grayColor();
            self.titleLabel?.text = self.fmModel?.menuTitle!
        }else{
        
            self.titleLabel?.textColor = self.selectecColor;
            self.titleLabel?.text = btn.titleLabel?.text;
        
        }
        
        for (_,btnItem) in self.buttonArray.enumerate(){
        
            if (btnItem as! UIButton) !== btn{
            
                (btnItem as! UIButton).selected = false;
                (btnItem as! UIButton).backgroundColor = UIColor.whiteColor();
            
            }else{
            
                btn.selected = true;
                btn.backgroundColor = self.selectecColor;
            
            }
        
        
        }
        
        self.selectedButtonBlock!(buttonTitle: (btn.titleLabel?.text)!,type: self.fmModel!.menuTitle!);
    
    
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if self.isSelected == true{
        
            self.isSelected = false;
        
        }else{
        
            self.isSelected = true;
        
        }
        self.selectedItemBlock!(itemIndex: self.itemIndex)
        
        
        
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
