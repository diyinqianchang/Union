//
//  TabView.swift
//  Union
//
//  Created by 张国林 on 16/4/7.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

typealias TabIndex_Block = (selecteIndex:NSInteger)->Void

class TabView: UIView {
    var scrollView:UIScrollView?
    lazy var lineView :UIView = {
    
        let lineView = UIView();
        lineView.backgroundColor = MAINCOLOR;
        return lineView;
    }();
    
    var selectIndex:NSInteger{
    
        willSet{
            if self.selectIndex != newValue{
                
                self.selectIndex = newValue;
            }
        }
        didSet{
            if self.buttonArray.count != 0{
                let button:UIButton = (self.buttonArray.objectAtIndex(selectIndex)) as! UIButton;
                self.buttonClickStyle(button);
                for btn in self.buttonArray{
                    if btn as! UIButton != button{
                        self.buttonDefaultStyle(btn as! UIButton)
                    }else{
                        self.tabIndex_Block!(selecteIndex:self.selectIndex);
                    }
                }
                self.lineViewMobile(button.frame.origin.x);
            }
        }
    
    }
    var SCROLL_WIDTH:CGFloat!
    var SCROLL_HEIGHT:CGFloat!
    var tabIndex_Block:TabIndex_Block?
    
    var dataArray:Array<String>{
    
        willSet{
            
            if(self.dataArray != newValue){
            
                self.dataArray = newValue;
            
            }
        }
        didSet{
        
            if(self.selectIndex > self.dataArray.count){
                self.selectIndex = self.dataArray.count - 1;
            }
            self.removeAllViews();
            self.loadButton();
        
        }
    
    }
    
    lazy var buttonArray:NSMutableArray = {
    
        let muArray = NSMutableArray();
        return muArray;
    
    }();
    

    override init(frame: CGRect) {
        self.dataArray = Array<String>();
        self.selectIndex = 0;
        super.init(frame: frame);
       
        self.scrollView = UIScrollView(frame: CGRectMake(0,0,frame.size.width,frame.size.height));
        self.scrollView?.backgroundColor = RGB(245, g: 245, b: 245);
        self.scrollView?.contentSize = CGSizeMake(frame.size.width,frame.size.height);
        self.scrollView?.showsHorizontalScrollIndicator = false;
        self.scrollView?.pagingEnabled = false;
        self.addSubview(self.scrollView!);
        SCROLL_WIDTH = CGRectGetWidth(self.scrollView!.frame);
        SCROLL_HEIGHT = CGRectGetHeight(self.scrollView!.frame);
        self.scrollView?.addSubview(self.lineView);
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        
        self.scrollView?.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
       
        let count = self.dataArray.count;
        let button_width = SCREEN_WIDTH / CGFloat((count <= 6 ? count:6));
        
    
        for(var i = 0;i<self.buttonArray.count;i++){
        
            let button = self.buttonArray[i] as! UIButton;
            button.frame = CGRectMake(button_width * CGFloat(i),self.scrollView!.frame.origin.y , button_width , SCROLL_HEIGHT);
        
        }
        
        self.scrollView?.contentSize = CGSizeMake(button_width * CGFloat(count) , SCROLL_HEIGHT);
        
        self.lineView.frame = CGRectMake(button_width * CGFloat(self.selectIndex) , SCROLL_HEIGHT - 3 , button_width, 3);
        
        
        
    }
    
    func loadButton(){
    
    
        let count:NSInteger = self.dataArray.count;
        
        let button_width = SCREEN_WIDTH / CGFloat((count <= 6 ? count:6));
        
        for(var i = 0;i<count;i++){
        
            self.initButton(CGRectMake(button_width * CGFloat(i), self.scrollView!.frame.origin.y, button_width, SCROLL_HEIGHT), title: self.dataArray[i]);
        
        }
        
        self.scrollView?.contentSize = CGSizeMake(button_width * CGFloat(count) , SCROLL_HEIGHT);
        
        self.lineView.frame = CGRectMake(button_width * CGFloat(self.selectIndex) , SCROLL_HEIGHT - 3 , button_width, 3);
    }
    
    func initButton(frame:CGRect,title:String){
    
        let button = UIButton(type: .Custom);
        button.frame = frame;
        button.autoresizesSubviews = true;
        button.setTitle(title, forState: .Normal);
        button.titleLabel?.font = UIFont.systemFontOfSize(14);
        button.backgroundColor = RGB(255, g: 255, b: 255);
        
        
        button.addTarget(self, action: Selector("buttonAction:"), forControlEvents: .TouchUpInside);
        self.scrollView?.insertSubview(button, belowSubview: self.lineView);
        
        
        //用一个数组来存储按钮，为了能够在时刻记住按钮的状态
        self.buttonArray.addObject(button);
        
        if self.buttonArray.indexOfObject(button) == self.selectIndex{
            self.buttonClickStyle(button);
        }else{
        
            self.buttonDefaultStyle(button);
        }
    
    
    }
    
    func buttonAction(sender:UIButton){
    
        self.buttonClickStyle(sender);
        self.selectIndex = self.buttonArray.indexOfObject(sender);
        
        for button in self.buttonArray{
        
            if button as! UIButton != sender{
                self.buttonDefaultStyle(button as! UIButton)
            }else{
            
                self.tabIndex_Block!(selecteIndex:self.selectIndex);
            
            }
        }
        self.lineViewMobile(sender.frame.origin.x);
        
    
    }
    
    
    func lineViewMobile(x:CGFloat){
    
        UIView.beginAnimations("lineViewMobile", context: nil);
        UIView.setAnimationDuration(0.2);
        self.lineView.frame = CGRectMake(x , SCROLL_HEIGHT - 3 , CGRectGetWidth(self.lineView.frame) , CGRectGetHeight(self.lineView.frame));
        UIView.commitAnimations();
    
    
    }
    
    
    
    
    
    func buttonDefaultStyle(button:UIButton){
    
        button.setTitleColor(UIColor.lightGrayColor(), forState: .Normal);
    }
    
    func buttonClickStyle(button:UIButton){
        
        button.setTitleColor(MAINCOLOR, forState: .Normal);
        
    }
    
    
    /**
     *删除所有button
     */
    
    func removeAllViews(){
    
        
        for(_,item) in self.subviews.enumerate(){
            
            if item.isKindOfClass(UIButton.self){
                
                item.removeFromSuperview();
            }
        
        }
        
    }



    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
