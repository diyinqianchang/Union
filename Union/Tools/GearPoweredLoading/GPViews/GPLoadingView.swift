//
//  GPLoadingView.swift
//  Union
//
//  Created by 万联 on 16/4/11.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit


typealias DidLoadAnimationBlock = ()->Void;

class GPLoadingView: UIView {

    var didLoadBlock:DidLoadAnimationBlock?
    
    var topView:UIView?
    var mainGear:UIImageView?
    var topGear:UIImageView?
    var leftGear:UIImageView?
    var downGear:UIImageView?
    var rightGear:UIImageView?
    
    var leftView:UIView?
    var rightView:UIView?
    var errorView:UIView?
    
    var isLoading:Bool = false;
    var isAuxiliaryGear:Bool = false;
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = RGB(37, g: 77, b: 138);
        self.clipsToBounds = true;
        
        self.errorView = UIView(frame: CGRectMake(0,0,10,10));
        self.errorView?.center = CGPointMake(-10, -10);
        self.errorView?.clipsToBounds = true;
        self.backgroundColor = UIColor.clearColor();
        self.addSubview(self.errorView!);
        
        self.leftView = UIView();
        self.leftView?.backgroundColor = RGB(94, g: 136, b: 233);
        self.addSubview(self.leftView!);
        
        self.rightView = UIView();
        self.rightView?.backgroundColor = RGB(94, g: 136, b: 233);
        self.addSubview(self.rightView!);
        
        
        self.mainGear = UIImageView(frame: CGRectMake(0,0,70,70));
        self.mainGear?.tintColor = RGB(99, g: 141, b: 237);
        self.mainGear?.image = UIImage(named: "maingear");
        self.mainGear?.clipsToBounds = true;
        self.mainGear?.layer.cornerRadius = 35;
        self.addSubview(self.mainGear!);
        
        self.leftGear = UIImageView(frame: CGRectMake(0,0,140,140));
        self.leftGear?.tintColor = RGB(99, g: 141, b: 237);
        self.leftGear?.image = UIImage(named: "othergear");
        self.leftGear?.clipsToBounds = true;
        self.leftGear?.layer.cornerRadius = 70;
        self.addSubview(self.leftGear!);
        
        self.downGear = UIImageView(frame: CGRectMake(0,0,110,110));
        self.downGear?.tintColor = RGB(99, g: 141, b: 237);
        self.downGear?.image = UIImage(named: "othergear");
        self.downGear?.clipsToBounds = true;
        self.downGear?.layer.cornerRadius = 55;
        self.addSubview(self.downGear!);
        
        self.topGear = UIImageView(frame: CGRectMake(0,0,110,110));
        self.topGear?.tintColor = RGB(99, g: 141, b: 237);
        self.topGear?.image = UIImage(named: "othergear");
        self.topGear?.clipsToBounds = true;
        self.topGear?.layer.cornerRadius = 55;
        self.addSubview(self.topGear!);
        
        
        self.rightGear = UIImageView(frame: CGRectMake(0,0,140,140));
        self.topGear?.tintColor = UIColor(red: 94/255.0, green: 136/255.0, blue: 232/255.0, alpha: 0.6);
        self.topGear?.image = UIImage(named: "othergear");
        self.topGear?.clipsToBounds = true;
        self.topGear?.layer.cornerRadius = 70;
        self.addSubview(self.topGear!);
        
        self.topView = UIView(frame: CGRectMake(0,-5,CGRectGetWidth(self.frame),5));
        self.topView?.dropShow(offset: CGSizeMake(0,5), radius: 5, color: UIColor.darkGrayColor(), opacity: 0.8);
        self.addSubview(self.topView!);
        
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
       self.leftView?.frame = CGRectMake(10, 0, 10, self.frame.size.height);
        
        //设置右视图位置
        
        self.rightView?.frame = CGRectMake( CGRectGetWidth(self.frame) - 20, 0, 10, self.frame.size.height);
        
        let  mainx = self.frame.size.width / 2;
        let mainy = self.frame.size.height / 2;
        if self.isLoading == false{
        
            self.moveAuxiliaryGear(mainx, mainy: mainy);
        
        }else{
            if self.isAuxiliaryGear == true{
                self.moveAuxiliaryGear(mainx, mainy: mainy);
            }
        }
        

    }
    
    func moveAuxiliaryGear(mainx:CGFloat,mainy:CGFloat){
    
        let downx = mainx - 55 - 11;
        let downy = mainy + 55 - 3;
        self.downGear?.center = CGPointMake(downx, downy);
    
        let leftx = (downx - 55) + 5;
        let lefty = downy - 140 + 35 - 2;
        self.leftGear?.center = CGPointMake(leftx, lefty);
        //设置上齿轮位置
        let topx = self.frame.size.width / 2 + 55 + 11;
        let topy =  self.frame.size.height / 2 - 55 + 3;
        self.topGear?.center = CGPointMake( topx , topy);
        //设置右齿轮位置
        let rightx = topx + 70 + 14;
        let righty = mainy + 32;
        self.rightGear?.center = CGPointMake( rightx , righty );
    }
    func willLoadView(){
        if self.isLoading == false{
            //旋转齿轮
            self.mainGear!.transform = CGAffineTransformRotate(self.mainGear!.transform, CGFloat(-M_PI_4 / 20.0 * 2.0));
            self.downGear!.transform = CGAffineTransformRotate(self.downGear!.transform,  CGFloat(M_PI_4 / 36.0 * 2.0));
            self.leftGear!.transform = CGAffineTransformRotate(self.leftGear!.transform, CGFloat(-M_PI_4 / 36.0 * 2.0));
            self.topGear!.transform = CGAffineTransformRotate(self.topGear!.transform,  CGFloat(M_PI_4 / 36.0 * 2.0));
            self.rightGear!.transform = CGAffineTransformRotate(self.rightGear!.transform, CGFloat(-M_PI_4 / 36.0 * 2.0));
        }
    }
    
    func loadingView(){
    
        //更新正在加载状态
        
        self.isLoading = true;
        
        //旋转角度归0
        
        self.mainGear!.transform = CGAffineTransformMakeRotation(0);
        
        self.downGear!.transform = CGAffineTransformMakeRotation(0);
        
        self.leftGear!.transform = CGAffineTransformMakeRotation(0);
        
        self.topGear!.transform = CGAffineTransformMakeRotation(0);
        
        self.rightGear!.transform = CGAffineTransformMakeRotation(0);
        
        //运行齿轮
        self.runGear();
        
    
    }
    
    func runGear(){
        if self.isAuxiliaryGear == false{
        
        }else{
            self.runLeftGear();
            self.runTopGear();
            self.runRightGear();
            self.runDownGear();
        }
    
    }
    
    func runMainGear(){
        self.mainGear?.layer.addAnimation(self.rotationGear(Float(M_PI * 1.8)), forKey: "Rotation");
    }
    func runLeftGear(){
        self.leftGear?.layer.addAnimation(self.rotationGear(Float(M_PI * 1.0)), forKey: "Rotation");
    }
    func runTopGear(){
        self.topGear?.layer.addAnimation(self.rotationGear(Float(-M_PI * 1.0)), forKey: "Rotation");
    }
    func runRightGear(){
        self.rightGear?.layer.addAnimation(self.rotationGear(Float(M_PI * 1.0)), forKey: "Rotation");
    }
    func runDownGear(){
        self.downGear?.layer.addAnimation(self.rotationGear(Float(-M_PI * 1.8)), forKey: "Rotation");
    }
    
    func takeBackAuxiliaryGear(){
    
        self.downGear!.transform = CGAffineTransformMakeRotation(0);
        
        self.leftGear!.transform = CGAffineTransformMakeRotation(0);
        
        self.topGear!.transform = CGAffineTransformMakeRotation(0);
        
        self.rightGear!.transform = CGAffineTransformMakeRotation(0);
        
        UIView.beginAnimations("takeBackAuxiliaryGear", context: nil);
        
        UIView.setAnimationDuration(2.0);
        
        //收回下齿轮
        
        self.downGear?.frame = CGRectMake( 0 - CGRectGetWidth(self.downGear!.frame)  , CGRectGetHeight(self.frame)  , CGRectGetWidth(self.downGear!.frame), CGRectGetHeight(self.downGear!.frame));
        
        //收回左齿轮
        
        self.leftGear?.frame = CGRectMake( 0 - CGRectGetWidth(self.leftGear!.frame) / 2.0  , 0 - CGRectGetHeight(self.leftGear!.frame) , CGRectGetWidth(self.leftGear!.frame), CGRectGetHeight(self.leftGear!.frame));
        
        //收回上齿轮
        
        self.topGear?.frame = CGRectMake( self.topGear!.frame.origin.x + 50 , 0 - CGRectGetHeight(self.topGear!.frame)  , CGRectGetWidth(self.topGear!.frame), CGRectGetHeight(self.topGear!.frame));
        
        //收回右齿轮
        
        self.rightGear?.frame = CGRectMake( CGRectGetWidth(self.frame) , CGRectGetHeight(self.frame) + CGRectGetHeight(self.rightGear!.frame) , CGRectGetWidth(self.rightGear!.frame), CGRectGetHeight(self.rightGear!.frame));
        UIView.commitAnimations();
    }
    
    func removeLoadingAnimations(){
    //删除原加载动画
        self.mainGear?.layer.removeAnimationForKey("Rotation");
        self.leftGear?.layer.removeAnimationForKey("Rotation");
        self.topGear?.layer.removeAnimationForKey("Rotation");
        self.downGear?.layer.removeAnimationForKey("Rotation");
        self.rightGear?.layer.removeAnimationForKey("Rotation");
    
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
    
    /**
     *加载完毕
     */
    func didLoadView(){
        
        if self.isLoading{
            self.removeLoadingAnimations();
        }
        UIView.animateWithDuration(0.2, animations: { [weak self]() -> Void in
            self?.mainGear?.transform = CGAffineTransformScale(self!.mainGear!.transform, 1.2, 1.2);
            }) {[weak self] (finished) -> Void in
                
                if finished {
                
                    self?.didLoadBlock!();
                    self?.mainGear?.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    self?.isLoading = false;
                    self?.mainGear?.transform = CGAffineTransformMakeRotation(0);
                    self?.downGear?.transform = CGAffineTransformMakeRotation(0);
                    self?.leftGear?.transform = CGAffineTransformMakeRotation(0);
                    self?.topGear?.transform = CGAffineTransformMakeRotation(0);
                    self?.rightGear?.transform = CGAffineTransformMakeRotation(0);
                }
                
        }
    
    }
    
    func errorLoadView(){
       
        self.removeLoadingAnimations();
        let erroranim = CAKeyframeAnimation();
        erroranim.keyPath = "transform.rotation";
        erroranim.values = [self.angleToRandian(-7.0),self.angleToRandian(7.0),self.angleToRandian(-7.0)];
        erroranim.repeatCount = 20;
        erroranim.duration = 0.1;
        self.mainGear?.layer.addAnimation(erroranim, forKey: "errorAnimation");
        UIView.animateWithDuration(1.0, animations: {[weak self] () -> Void in
            
            self?.errorView?.center = CGPointMake(-20,-20);
            
            }) { (finished) -> Void in
                
                if finished{
                    self.didLoadView();
                    self.errorView?.center = CGPointMake(-10,-10);
                }
                
        }
        
    }
    func angleToRandian(x:Double)->Double{
       
        return  x / 180.0 * M_PI;
    }
    
    func pauseAnimation(){
    
        let pauseTime = self.layer.convertTime(CACurrentMediaTime(), fromLayer: nil);
        self.layer.timeOffset = pauseTime;
        self.layer.speed = 0.0;
    
    }
    func resumeAnimation(){
        
        let pauseTime = self.layer.timeOffset;
        let startTime = CACurrentMediaTime() - pauseTime;
        self.layer.timeOffset = 0.0;
        self.layer.beginTime = startTime;
        self.layer.speed = 1.0;
    
    }



}
