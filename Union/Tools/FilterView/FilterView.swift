//
//  FilterView.swift
//  Union
//
//  Created by 万联 on 16/4/22.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

protocol FilterViewDelegate:NSObjectProtocol{

    
    func selectedScreeningConditions(condition:String,type:String);

}

class FilterView: UIView {

    var dataArray:NSArray =  NSArray(){
    
        willSet{
        
            if self.dataArray != newValue{
            
                self.dataArray = newValue;
            }
        
        }
        didSet{
            
            if self.dataArray.count > 0{
            
                let itemWidth = CGRectGetWidth(self.frame) / CGFloat((self.dataArray.count > 4 ? 4 : self.dataArray.count))
                let itemIndex = 0;
                
                for (_,model) in self.dataArray.enumerate(){
                
                    let fmItem = FilterMenuItem(frame: CGRectMake(itemWidth * CGFloat(itemIndex),0,itemWidth,CGRectGetHeight(self.frame)));
                    fmItem.itemModel(model as! FilterMenuModel);
                    fmItem.itemIndex = itemIndex;
                    fmItem.selectecColor = MAINCOLOR;
                    self.addSubview(fmItem);
                    
                    self.itemArray?.addObject(fmItem);
                    
                    fmItem.selectedItemBlock = {[weak self](itemIndex)->Void in
                    
                        var itemIsSelected = false;
                        
                        for (index,item) in (self?.itemArray!.enumerate())!{
                        
                            let tempItem = item as! FilterMenuItem
                            
                            if index != itemIndex{
                    
                                tempItem.isSelected = false;
                            }
                            
                            if tempItem.isSelected{
                            
                                itemIsSelected = true;
                            
                            }
                        }
                        
                        if itemIsSelected{
                        
                            self?.frame = CGRectMake((self?.frame.origin.x)!, (self?.frame.origin.y)!, CGRectGetWidth((self?.frame)!), SCREEN_HEIGHT - (self?.frame.origin.y)!);
                            UIView.animateWithDuration(0.3, animations: { () -> Void in
                                self?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5);
                            })
                        
                        
                        }else{
                        
                            //没有Item为选中状态
                            
//                            UIView.
                        
                        
                        }
                        
                        
                    
                    
                    }
                
                
                }
            
            
            }
        
        
        }
    
    
    }
    weak var delegate:FilterViewDelegate?
    
    var itemArray:NSMutableArray?
    var originalHeight:CGFloat?
    
    override init(var frame: CGRect) {
        
        if frame.size.height < 40{
        
            frame.size.height = 40
        }
        super.init(frame: frame);
        
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0);
        self.originalHeight = self.frame.size.height;
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   
}
