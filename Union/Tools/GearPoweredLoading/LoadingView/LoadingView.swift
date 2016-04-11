//
//  LoadingView.swift
//  Union
//
//  Created by 万联 on 16/4/11.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    var mainGear:UIImageView?
    
    var loadingColor:UIColor{
    
        willSet{
            if self.loadingColor != newValue {
                self.loadingColor = newValue
            }
        }
        didSet{
            
            self.mainGear?.tintColor = self.loadingColor
        }
    
    }
    var viewHidden:Bool{
    
        willSet{
            if self.viewHidden != newValue {
                self.viewHidden = newValue
            }
        }
        didSet{
        
            if viewHidden{
            
                self.hiddenView();
            
             }else{
                self.showView();
            }
        
        }
    
    }
    
    override init(var frame: CGRect) {
        if frame.size.width < 70 || frame.size.height < 70{
            frame.size.height = 70;
            frame.size.width = 70;
        }
        self.loadingColor = UIColor.whiteColor();
        self.viewHidden = Bool();
        super.init(frame: frame);
        self.mainGear = UIImageView(frame: CGRectMake(0,0,70,70));
        self.mainGear?.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
        self.mainGear?.image = UIImage(named: "maingear");
        self.mainGear?.layer.cornerRadius = 35;
        self.mainGear?.clipsToBounds = true;
        self.addSubview(self.mainGear!);
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    
    func showView(){
    
        self.mainGear?.layer.addAnimation(self.rotationGear(Float(M_PI * 2.0)), forKey: "Rotation");
    
    }
    
    func hiddenView(){
     
        self.mainGear?.layer.removeAnimationForKey("Rotation");
    }
    
    
    func rotationGear(degree:Float)->CABasicAnimation{
    
        let rotationAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z");
//        CAMediaTimingFunction
        rotationAnimation.toValue = NSNumber(float: degree);
        rotationAnimation.duration = 2;
        rotationAnimation.repeatCount = 100000;
        rotationAnimation.cumulative = false;
        rotationAnimation.removedOnCompletion = false;
        rotationAnimation.fillMode = kCAFillModeForwards;
        return rotationAnimation;
    
    }

}
