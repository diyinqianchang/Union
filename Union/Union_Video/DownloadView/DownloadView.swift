//
//  DownloadView.swift
//  Union
//
//  Created by 万联 on 16/4/7.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class DownloadView: UIView {


    lazy var animator:UIDynamicAnimator = {
    
        let animator = UIDynamicAnimator(referenceView: self.superview!);
        animator.delegate = self;
        return animator;
    
    }();
    var backgroundView:UIView?
    var imageView:UIImageView?
    
    var startPoint:CGPoint?
    var endPoint:CGPoint?
    
    override init(frame: CGRect) {
        
        
        super.init(frame: frame);
        
        self.backgroundView = UIView(frame: CGRectMake(0,0,CGRectGetWidth(self.frame),CGRectGetHeight(self.frame)));
        self.backgroundView?.layer.cornerRadius = (self.backgroundView?.frame.size.width)!/2;
        self.backgroundView?.clipsToBounds = true;
        self.backgroundView?.backgroundColor = MAINCOLOR.colorWithAlphaComponent(0.7);
        self.backgroundView?.userInteractionEnabled = false;
        self.addSubview(self.backgroundView!);
        
        
        
        let imageBackgroundView:UIView = UIView(frame: CGRectMake(5, 5, CGRectGetWidth(self.frame) - 10, CGRectGetHeight(self.frame) - 10));
        
        imageBackgroundView.layer.cornerRadius = imageBackgroundView.frame.size.width / 2;
        
        imageBackgroundView.clipsToBounds = true;
        
        imageBackgroundView.backgroundColor = MAINCOLOR.colorWithAlphaComponent(0.8);
        
        imageBackgroundView.userInteractionEnabled = false;
        
        self.addSubview(imageBackgroundView);
        
        self.imageView = UIImageView(image: UIImage(named: "iconfont-xiazai")?.imageWithRenderingMode(
            .AlwaysTemplate) );
        self.imageView?.tintColor = UIColor.whiteColor();
        self.imageView?.center = CGPoint(x: kDownLoadWidth/2, y: kDownLoadWidth/2);
        self.addSubview(self.imageView!);
        
        
        self.layer.cornerRadius = CGFloat(kDownLoadWidth/2);
        
        self.HighlightAnimation();
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let startTouch = (touches as NSSet).anyObject() as! UITouch;
        self.startPoint = startTouch.locationInView(self.superview);
        self.animator.removeAllBehaviors();
        
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let startTouch = (touches as NSSet).anyObject() as! UITouch;
        self.center = startTouch.locationInView(self.superview);
        
    }
    
    
   override  func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
    
       let endTouch = (touches as NSSet).anyObject() as! UITouch;
       self.endPoint = endTouch.locationInView(self.superview);
    
       let errorRange :CGFloat = 5.0;
    
        if(( (self.endPoint?.x)! - (self.startPoint?.x)! >= -errorRange && (self.endPoint?.x)! - (self.startPoint?.x)! <= errorRange ) && ( (self.endPoint?.y)! - (self.startPoint?.y)! >= -errorRange && (self.endPoint?.y)! - (self.startPoint?.y)! <= errorRange )){
        
            let app :AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
            app.openDownloadVC();
        
        }else{
        
            self.center = self.endPoint!;
            
            let superwidth = self.superview!.bounds.size.width;
            let superheight = self.superview!.bounds.size.height;
            
            var endX = self.endPoint!.x;
            
            var endY = self.endPoint!.y;
            
            let topRange = endY;//上距离
            
            let bottomRange = superheight - endY;//下距离
            
            let leftRange = endX;//左距离
            
            let rightRange = superwidth - endX;//右距离
            
            
            //比较上下左右距离 取出最小值
            
            let minRangeTB = topRange > bottomRange ? bottomRange : topRange;//获取上下最小距离
            
            let minRangeLR = leftRange > rightRange ? rightRange : leftRange;//获取左右最小距离
            
            let minRange = minRangeTB > minRangeLR ? minRangeLR : minRangeTB;//获取最小距离
            var minPoint:CGPoint = CGPointZero;
            
            if(minRange == topRange){
            
                endX = endX - kOffSet < 0 ? kOffSet : endX;
                
                endX = endX + kOffSet > superwidth ? superwidth - kOffSet : endX;
                
                minPoint = CGPointMake(endX , 0 + kOffSet);

            
            }else if(minRange == bottomRange){
                
                //下
                
                endX = endX - kOffSet < 0 ? kOffSet : endX;
                
                endX = endX + kOffSet > superwidth ? superwidth - kOffSet : endX;
                
                minPoint = CGPointMake(endX , superheight - kOffSet);
                
            } else if(minRange == leftRange){
                
                //左
                
                endY = endY - kOffSet < 0 ? kOffSet : endY;
                
                endY = endY + kOffSet > superheight ? superheight - kOffSet : endY;
                
                minPoint = CGPointMake(0 + kOffSet , endY);
                
            } else if(minRange == rightRange){
                
                //右
                
                endY = endY - kOffSet < 0 ? kOffSet : endY;
                
                endY = endY + kOffSet > superheight ? superheight - kOffSet : endY;
                
                minPoint = CGPointMake(superwidth - kOffSet , endY);
                
            }
            
            let attachmentBehavior = UIAttachmentBehavior(item: self, attachedToAnchor: minPoint);
            attachmentBehavior.length = 0;
            attachmentBehavior.damping = 0.1;
            attachmentBehavior.frequency = 5;
            self.animator.addBehavior(attachmentBehavior);
            
        }
    }
    
    
    
    func HighlightAnimation(){
        
        UIView.animateWithDuration(1.5, animations: { () -> Void in
            self.backgroundView?.backgroundColor = self.backgroundView?.backgroundColor?.colorWithAlphaComponent(0.1);
            }) { (finished) -> Void in
                self.DarkAnimation();
        }
    }
    
    func DarkAnimation(){
        UIView.animateWithDuration(1.5, animations: { () -> Void in
            self.backgroundView?.backgroundColor = self.backgroundView?.backgroundColor?.colorWithAlphaComponent(0.6);
            }) { (finished) -> Void in
                self.HighlightAnimation();
        }
    }
    deinit{
       print("\(self)释放")
    }
    
}


extension DownloadView:UIDynamicAnimatorDelegate{


    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        
    }


}
