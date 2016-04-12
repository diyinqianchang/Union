
//
//  GPBottomLoadingView.swift
//  Union
//
//  Created by 万联 on 16/4/11.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit


typealias GPBottomDidLoadAnimationBlock = ()->Void;

class GPBottomLoadingView: UIView {

    var didLoadAnimationBlock:GPBottomDidLoadAnimationBlock?
    
    var mainGear :UIImageView?
    var errorLabelView:UIView?
    var errorLabel:UILabel?
    
    var scale:CGFloat = 0.2;
    var isLoading:Bool = false;
    var isErrorAnimation:Bool = false;
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.clearColor();
        self.clipsToBounds = true;
        
        self.errorLabelView = UIView(frame: CGRectMake(-100,15,100,30));
        self.errorLabelView?.clipsToBounds = true;
        self.errorLabelView?.backgroundColor = UIColor.clearColor();
        self.addSubview(self.errorLabelView!);
        
        self.errorLabel = UILabel(frame: CGRectMake(0,0,100,30));
        self.errorLabel?.text = "加载失败";
        self.errorLabel?.textAlignment = .Center;
        self.errorLabel?.textColor = UIColor.lightGrayColor();
        self.errorLabelView?.addSubview(self.errorLabel!);
        
        self.mainGear = UIImageView(frame: CGRectMake(0,0,40,40));
        self.mainGear?.tintColor = RGB(99, g: 141, b: 237);
        self.mainGear?.image = UIImage(named: "maingear")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate);
        self.mainGear?.clipsToBounds = true;
        self.addSubview(self.mainGear!);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        if self.isErrorAnimation == false{
        
            if self.isLoading == false{
                
                let mainHeight = CGRectGetHeight(self.frame) < 40 ? CGRectGetHeight(self.frame) : 40;
                self.mainGear?.frame = CGRectMake(10, 10, mainHeight, mainHeight);
            
            }
        
        }
        
        let mainx = self.frame.size.width / 2;
        let mainy = self.frame.size.height / 2;
        self.mainGear?.center = CGPointMake( mainx , mainy );
        //设置错误标签视图位置
        self.errorLabelView?.center = CGPointMake( self.errorLabelView!.frame.origin.x + 50 , mainy);

    }
    
    
    
    
    //即将开始加载视图
    
    func willLoadView(){}
    
    //正在加载视图
    
    func loadingView(){
    
    
        self.isLoading = true;
        self.mainGear?.transform = CGAffineTransformMakeRotation(0);
        self.mainGear?.layer.addAnimation(self.rotationGear(Float(M_PI * 2.0)), forKey: "Rotation");
    
    }
    
    //已加载完毕视图
    
    func didLoadView(){
    
        if self.isLoading{
        
            self.mainGear?.layer.removeAnimationForKey("Rotation");
            UIView.animateWithDuration(0.2, animations: {[weak self] () -> Void in
                
                self?.mainGear?.frame = CGRectMake(0, 0, 50, 50);
                let mainx = self!.frame.size.width / 2;
                let mainy = self!.frame.size.height / 2;
                self!.mainGear?.center = CGPointMake( mainx , mainy );
                }, completion: {[weak self] (finished) -> Void in
                    
                    UIView.animateWithDuration(0.2, animations: {[weak self] () -> Void in
                        self?.mainGear?.frame = CGRectMake(0, 0, 0, 0);
                        let mainx = self!.frame.size.width / 2;
                        let mainy = self!.frame.size.height / 2;
                        self!.mainGear?.center = CGPointMake( mainx , mainy );

                        }, completion: {[weak self] (finished) -> Void in
                            self?.didLoadAnimationBlock!();
                            self?.isLoading = false;
                        })

                    
            })
        
        }
    
    }
    
    //错误加载视图
    
    func errorLoadView(){
       
        if self.isLoading{
           
            self.isErrorAnimation = true;
            self.mainGear?.layer.removeAnimationForKey("Rotation");
            self.mainGear?.layer.addAnimation(self.rotationGear(Float(M_PI * 7.0)), forKey: "Rotation");
            UIView.animateWithDuration(1.0, animations: {[weak self] () -> Void in
                self?.errorLabelView?.center = CGPointMake(CGRectGetWidth(self!.frame) / 2, CGRectGetHeight(self!.frame) / 2);
                
                self?.mainGear?.center = CGPointMake(CGRectGetWidth(self!.frame) + 20, CGRectGetHeight(self!.frame) / 2);
                }, completion: {[weak self] (finished) -> Void in
                    
                    GCDQueue.mainQueue.excute({ () -> Void in
                        self?.didLoadAnimationBlock!();
                        self?.isLoading = false;
                        self?.errorLabelView?.center = CGPointMake(-50,self!.frame.size.height / 2)
                        self?.mainGear?.layer.removeAnimationForKey("Rotation");
                        self?.isErrorAnimation = false;
                        }, afterDelayWithNanoseconds: Int64(1 * NSEC_PER_SEC))
                    
                    
            })
        
        }
    
    }
    
   private func angleToRandian(x:Double)->Double{
        
        return  x / 180.0 * M_PI;
    }

    
   private func rotationGear(degree:Float)->CABasicAnimation{
        
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
