//
//  LXConstraints.swift
//  Union
//
//  Created by 万联 on 16/4/23.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import Foundation

extension UIView{



    func addSubView(view:UIView,insets:UIEdgeInsets){
    
        view.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(view);
        
        self.addConstraint(NSLayoutConstraint(item: view,
                                        attribute: NSLayoutAttribute.Top,
                                        relatedBy: NSLayoutRelation.Equal,
                                        toItem: self,
                                        attribute: NSLayoutAttribute.Top,
                                        multiplier: 1.0,
                                        constant:insets.top))
    
    
       self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: insets.left))
    
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: insets.bottom));
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: insets.right));
    
    
    
    
    }






}