//
//  UIView+AlertView.swift
//  Union
//
//  Created by 万联 on 16/4/14.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import Foundation

let NOTIFIER_LABEL_FONT = UIFont(name: "HelveticaNeue-Light", size: 18);
let NOTIFIER_CANCEL_FONT = UIFont(name: "HelveticaNeue", size: 13);
let kTagAlertView:NSInteger = 19940;
let xPadding:CGFloat = 18.0;
let kLabelHeight:CGFloat = 45.0;
let kCancelButtonHeight:CGFloat = 30.0;
let kSeparatorHeight:CGFloat = 1.0;
let kHeightFromBottom:CGFloat = 70;
let kMaxWidth:CGFloat = 290.0;

extension UIView{
    static func addNotifier(text text:String,dismissAutomatically shouldDismiss:Bool){
    
        let screenBounds = APPDELEGATE.window!.bounds;
        let height = kLabelHeight;
        let width = CGFloat.max;
        
        //计算文本的Rect 获取宽度
        let notifierRect = (text as NSString).boundingRectWithSize(CGSizeMake(width,height), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:NOTIFIER_LABEL_FONT!], context: nil);
        //获取宽度  与设定最大值相比 去最小值
        let notifierWidth = min(CGRectGetWidth(notifierRect) + 2 * xPadding, kMaxWidth);
        
        // x 轴的距离
        let xOffset = (CGRectGetWidth(screenBounds) - notifierWidth) / 2;
        var notifierHeight = kLabelHeight;
        //如果非自动消失、 需要添加 消失按钮 这样一来 需要重新计算高度
        if(!shouldDismiss){
            notifierHeight += (kCancelButtonHeight + kSeparatorHeight);
        }
        //y抽上的距离
        let yOffset = CGRectGetHeight(screenBounds) - notifierHeight - kHeightFromBottom;
        
        let finalFrame = CGRectMake(xOffset, yOffset, notifierWidth, notifierHeight);
        
        var notifierView:UIView? = self.checkIfNotifierExistsAlready();
        
        if notifierView != nil {
        
            self.updateNotifierWithAnimation(notifierView: notifierView!, text: text, completion: { (finished) -> Void in
                
                var atLastFrams = finalFrame;
                atLastFrams.origin.y = finalFrame.origin.y + 8;
                notifierView?.frame = atLastFrams;
                
                //获取标签 并跟新
                var textLabel:UILabel?;
                for (_,subView) in (notifierView?.subviews.enumerate())!{
                    
                    if subView.isKindOfClass(UILabel.classForCoder()){
                      
                        textLabel = subView as? UILabel;
                    }
                    if subView.isKindOfClass(UIImageView.classForCoder()) || subView.isKindOfClass(UIButton.classForCoder()){
                    
                        subView.removeFromSuperview();
                       
                    }
                
                }
                textLabel?.text = text;
                textLabel?.frame = CGRectMake(xPadding, 0, notifierWidth - 2 * xPadding, kLabelHeight);
                
                if !shouldDismiss{
                    let separatorImageView:UIImageView = UIImageView(frame: CGRectMake(0,CGRectGetHeight(textLabel!.frame),CGRectGetWidth((notifierView?.frame)!),kSeparatorHeight));
                    separatorImageView.backgroundColor = MAINCOLOR;
                    notifierView?.addSubview(separatorImageView);
                    
                    //添加取消按钮
                    let buttonCancel = UIButton(type: UIButtonType.Custom);
                    buttonCancel.frame = CGRectMake(0, CGRectGetMaxY(separatorImageView.frame), CGRectGetWidth((notifierView?.frame)!), kCancelButtonHeight);
                    buttonCancel.backgroundColor = UIColor.redColor();
                    buttonCancel.addTarget(self, action: Selector("buttonCancelClicked:"), forControlEvents: UIControlEvents.TouchUpInside);
                    buttonCancel.setTitle("确认", forState: .Normal);
                    buttonCancel.titleLabel?.font = NOTIFIER_CANCEL_FONT;
                    notifierView?.addSubview(buttonCancel);
                }
                UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    notifierView?.alpha = 1;
                    notifierView?.frame = finalFrame;
                    }, completion: { (finished) -> Void in
                        
                })
                
            });
            
            if shouldDismiss {
                self.performSelector(Selector("dismissLXNotifier"), withObject: nil, afterDelay: 2.0);
            }
        
        }else{
           
            notifierView = UIView(frame: CGRectMake(xOffset, CGRectGetHeight(screenBounds), notifierWidth, notifierHeight));
            notifierView?.backgroundColor = UIColor.redColor();
            notifierView?.tag = kTagAlertView;
            notifierView?.clipsToBounds = true;
            notifierView?.layer.cornerRadius = 5.0;
            APPDELEGATE.window?.addSubview(notifierView!);
            APPDELEGATE.window?.bringSubviewToFront(notifierView!);
            
            let notifierViewTap = UITapGestureRecognizer(target: self, action: Selector("notifierViewTapAction:"));
            notifierView?.addGestureRecognizer(notifierViewTap);
            
            //创建标签
            let textLabel = UILabel(frame: CGRectMake(xPadding,0,notifierWidth - 2 * xPadding,kLabelHeight));
            textLabel.adjustsFontSizeToFitWidth = true;
            textLabel.backgroundColor = UIColor.clearColor();
            textLabel.textAlignment = .Center;
            textLabel.textColor = UIColor.whiteColor();
            textLabel.font = NOTIFIER_LABEL_FONT;
            textLabel.text = text;
            textLabel.minimumScaleFactor = 0.7;
            notifierView?.addSubview(textLabel);
            
            if shouldDismiss {
               self.performSelector(Selector("dismissLXNotifier"), withObject: nil, afterDelay: 2.0);
            }else{
                
                let separatorImageView:UIImageView = UIImageView(frame: CGRectMake(0,CGRectGetHeight(textLabel.frame),CGRectGetWidth((notifierView?.frame)!),kSeparatorHeight));
                separatorImageView.backgroundColor = MAINCOLOR;
                notifierView?.addSubview(separatorImageView);
                
                //添加取消按钮
                let buttonCancel = UIButton(type: UIButtonType.Custom);
                buttonCancel.frame = CGRectMake(0, CGRectGetMaxY(separatorImageView.frame), CGRectGetWidth((notifierView?.frame)!), kCancelButtonHeight);
                buttonCancel.backgroundColor = UIColor.redColor();
                buttonCancel.addTarget(self, action: Selector("buttonCancelClicked:"), forControlEvents: UIControlEvents.TouchUpInside);
                buttonCancel.setTitle("确认", forState: .Normal);
                buttonCancel.titleLabel?.font = NOTIFIER_CANCEL_FONT;
                notifierView?.addSubview(buttonCancel);

            
            }
            self.startEntryAnimation(notifierView: notifierView!, withFinalFrame: finalFrame);
        
        }
        
    
    }
    //视图是否已存在
    static func checkIfNotifierExistsAlready()->UIView?{
        
       NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: Selector("dismissLXNotifier"), object: nil)
        
        var notifier:UIView?
        APPDELEGATE.window?.subviews.forEach({ (subView) -> () in
            if subView.tag == kTagAlertView && subView.isKindOfClass(UIView.classForCoder()){
            
                notifier = subView;
            }
        })
         return notifier

    }
    static func dismissLXNotifier(){
        
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: Selector("dismissLXNotifier"), object: nil);
        var notifier:UIView?
        APPDELEGATE.window?.subviews.forEach({ (subView) -> () in
            if subView.tag == kTagAlertView && subView.isKindOfClass(UIView.classForCoder()){
                notifier = subView;
            }
        })
        defer{
            
            if notifier != nil{
            
             self.startExitAnimation(notifier!);
            }
        }
    
    }
    //消失视图
    static func buttonCancelClicked(btn:UIButton){
    
        self.dismissLXNotifier();
     
    }
    static func notifierViewTapAction(tap:UITapGestureRecognizer){
    
        self.dismissLXNotifier();
    
    }
//MARK:===========================动画部分=================================
    static func updateNotifierWithAnimation(notifierView notifierView:UIView,text:String,completion:(finished:Bool)->Void){
    
        var finaleFrame = notifierView.frame;
        finaleFrame.origin.y = finaleFrame.origin.y + 8;
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            
            notifierView.alpha = 0;
            notifierView.frame = finaleFrame;
            
            }) { (finished) -> Void in
                completion(finished: finished);
        }
    
    
    }
    static func startEntryAnimation(notifierView notifierView:UIView,var withFinalFrame finalFrame:CGRect){
        let finalYOffset = finalFrame.origin.y;
        finalFrame.origin.y = finalFrame.origin.y - 15;
        
        let transform:CATransform3D = self.transform(-0.1, angel: 45);
        notifierView.layer.zPosition = 400;
        notifierView.layer.transform = transform;
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            notifierView.frame = finalFrame;
            let transform = self.transform(0.1, angel: 15);
            notifierView.layer.zPosition = 400;
            notifierView.layer.transform = transform;
            }) { (finished) -> Void in
              UIView.animateWithDuration(0.4, animations: { () -> Void in
                var atLastFrame = finalFrame;
                atLastFrame.origin.y = finalYOffset;
                notifierView.frame = atLastFrame;
                let transform = self.transform(0.0, angel: 90);
                notifierView.layer.zPosition = 400;
                notifierView.layer.transform = transform;
                }, completion: { (finished) -> Void in
                    
              })
        }
        
    
    }
    static func startExitAnimation(notifierView:UIView){
    
        let screenBounds = APPDELEGATE.window?.bounds;
        var notifierFrame = notifierView.frame;
        let finalYOffset = notifierFrame.origin.y - 12;
        notifierFrame.origin.y = finalYOffset;
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                notifierView.frame = notifierFrame;
                let transform = self.transform(0.1, angel: 30);
                notifierView.layer.zPosition = 400;
                notifierView.layer.transform = transform;
            
            }) { (finished) -> Void in
                
                UIView.animateWithDuration(0.15, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    var atLastFrame = notifierFrame;
                    atLastFrame.origin.y = CGRectGetHeight(screenBounds!);
                    notifierView.frame = atLastFrame;
                    let transform = self.transform(-1.0, angel: 90);
                    notifierView.layer.zPosition = 400;
                    notifierView.layer.transform = transform;
                    
                    }, completion: { (finished) -> Void in
                        
                        notifierView.removeFromSuperview();
                        self.removeNotifierView(notifierView);
                })
                
        }
        
    }
    static func removeNotifierView(var notifierView:UIView?){
        
       notifierView = nil;
    }
    static func transform(XAxisValue:CGFloat,angel angelValue:CGFloat)->CATransform3D{
    
        var tansform = CATransform3DIdentity;
        tansform.m34 = 1.0 / -1000.0;
        tansform = CATransform3DRotate(tansform, angelValue * CGFloat(M_PI / 180.0), XAxisValue, 0.0, 0.0);
        return tansform;
    
    }



}