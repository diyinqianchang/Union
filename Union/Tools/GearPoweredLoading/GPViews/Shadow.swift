//
//  Shadow.swift
//  Union
//
//  Created by 万联 on 16/4/11.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import Foundation

extension UIView{
    
    

    func dropShow(offset offset:CGSize,radius:CGFloat,color:UIColor,opacity:Float){
    
        let path = CGPathCreateMutable();
        CGPathAddRect(path, nil, self.bounds);
        self.layer.shadowPath = path;
        CGPathCloseSubpath(path);
        
        self.layer.shadowColor = color.CGColor;
        self.layer.shadowOffset = offset;
        self.layer.shadowRadius = radius;
        self.layer.shadowOpacity = opacity;
        self.clipsToBounds = false;
    
    }


}