//
//  PictureCycleView.swift
//  Union
//
//  Created by 万联 on 16/4/12.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

typealias PictureCycle_SelectedPicBlock = (model:PictureCycleModel)->Void

class PictureCycleView: UIView {
    
    
    var dataArray:NSMutableArray{
    
        willSet{
            if self.dataArray != newValue{
                self.dataArray = newValue;
            }
        }
        didSet{
            self.pageControl?.numberOfPages = self.dataArray.count;
            self.pageControl?.currentPage = 0;
            self.nowIndex = 0;
        }
    
    }
    var nowIndex:NSInteger{
    
        willSet{
            if self.nowIndex != newValue{
                self.nowIndex = newValue;
            }
        }
        didSet{
            self.nowItem?.model = self.dataArray.objectAtIndex(nowIndex) as! PictureCycleModel;
            self.lastItem?.model = self.dataArray.objectAtIndex(self.getLastItemIndex()) as! PictureCycleModel;
            self.nextItem?.model = self.dataArray.objectAtIndex(self.getNextItemIndex()) as! PictureCycleModel;
            self.pageControl?.currentPage = nowIndex;
        }
    
    }
    var timeInterval:NSTimeInterval{
    
        willSet{
            if self.timeInterval != newValue{
                self.timeInterval = newValue;
            }
        }
        didSet{
          
            GCDQueue.executeInMainQueue({ () -> Void in
                
                if self.timer != nil{
                    
                    self.timer?.invalidate();
                    self.timer = nil;
                    
                }else{
                  
                    self.timer = NSTimer(timeInterval: self.timeInterval, target: self, selector: Selector("timerAction:"), userInfo: nil, repeats: true);
                    let runLoop = NSRunLoop.currentRunLoop();
                    runLoop.addTimer(self.timer!, forMode: NSDefaultRunLoopMode);
                    
                    self.timer?.fireDate = NSDate.distantFuture();
                    
                    if self.isPicturePlay{
                        self.isPicturePlay = true;
                    }else{
                        self.isPicturePlay = false;
                    }
                }
                
                }, afterDelaySeconds: Double(self.timeInterval))
            
        }
    
    }
    var isPicturePlay:Bool{
    
        willSet{
            if self.isPicturePlay != newValue{
                
                self.isPicturePlay = newValue;
            }
        }
        didSet{
           
            if isPicturePlay{
                
                self.timer?.fireDate = NSDate();
                
            }else{
                self.timer?.fireDate = NSDate.distantFuture();
            }
        
        }
        
    
    }
    var selectPicBlock:PictureCycle_SelectedPicBlock?
    var myScrollView:PictureCycleScrollView?
    var lastItem :PictureCycleItem?
    var nowItem:PictureCycleItem?
    var nextItem:PictureCycleItem?
    var pageControl:UIPageControl?
    
    
    var timer:NSTimer?
    
    override init(frame: CGRect) {
        
        self.dataArray = NSMutableArray();
        
        self.nowIndex = 0;
        self.timeInterval = 0;
        self.isPicturePlay = false;
        
        super.init(frame: frame);
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("tapAction:"));
        
        self.myScrollView = PictureCycleScrollView();
        self.myScrollView?.delegate = self;
        self.myScrollView?.pagingEnabled = true;
        self.myScrollView?.bounces = false;
        self.myScrollView?.showsHorizontalScrollIndicator = false;
        self.myScrollView?.addGestureRecognizer(tap);
        self.addSubview(self.myScrollView!);
        
        self.lastItem = PictureCycleItem(frame:CGRectZero);
        self.myScrollView?.addSubview(self.lastItem!);
        
        self.nowItem = PictureCycleItem(frame:CGRectZero);
        self.myScrollView?.addSubview(self.nowItem!);
        
        self.nextItem = PictureCycleItem(frame:CGRectZero);
        self.myScrollView?.addSubview(self.nextItem!);
        
        self.pageControl = UIPageControl();
        self.addSubview(self.pageControl!);
    
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        
        super.layoutSubviews();
        
    
        self.myScrollView?.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
        self.lastItem?.frame = CGRectMake(0, 0,  CGRectGetWidth(self.myScrollView!.frame), CGRectGetHeight(self.myScrollView!.frame));
        
        self.nowItem?.frame = CGRectMake(CGRectGetWidth(self.myScrollView!.frame),0,CGRectGetWidth(self.myScrollView!.frame), CGRectGetHeight(self.myScrollView!.frame));
        
        self.nextItem?.frame = CGRectMake(CGRectGetWidth(self.myScrollView!.frame) * 2,0,CGRectGetWidth(self.myScrollView!.frame),CGRectGetHeight(self.myScrollView!.frame));
        
        self.pageControl?.frame = CGRectMake(0,CGRectGetHeight(self.frame) - 20, CGRectGetWidth(self.frame), 20);
        
        self.myScrollView?.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * 3, CGRectGetHeight(self.frame));
        
        self.myScrollView?.contentOffset = CGPointMake( CGRectGetWidth(self.myScrollView!.frame), 0);
        
    }
    func getLastItemIndex() -> NSInteger{
    
        var tempIndex = self.nowIndex;
        tempIndex--;
        if tempIndex < 0{
            tempIndex = self.dataArray.count - 1;
        }
        return tempIndex;
    }
    
    func getNextItemIndex() -> NSInteger{
        
        var tempIndex = self.nowIndex;
        tempIndex++
        if tempIndex > self.dataArray.count - 1{
            tempIndex = 0;
        }
        return tempIndex;
    }
    func playLastItem(){
    
        self.nowIndex = self.getLastItemIndex();
    
    }
    
    func playNextItem(){
        
        self.nowIndex = self.getNextItemIndex();
    }

    

}

extension PictureCycleView:UIScrollViewDelegate{

    func scrollViewDidEndScrollingHandele() {
        
        let page = (self.myScrollView?.contentOffset.x)! / CGRectGetWidth(self.frame);
        switch(page){
        case 0:
            self.playLastItem()
            break;
        case 2:
            self.playNextItem()
            break;
        default:
            break;
        }
        
        self.myScrollView?.setContentOffset(CGPointMake(self.myScrollView!.frame.size.width, 0), animated: false);
        
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    //滚动视图减速完成，滚动将停止时，调用该方法。一次有效滑动，只执行一次。
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingHandele();
    }
    //当滚动视图动画完成后，调用该方法，如果没有动画，那么该方法将不被调用
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingHandele();
    }
    //tap事件
    func tapAction(tap:UITapGestureRecognizer){
    
        if selectPicBlock != nil{
        
            self.selectPicBlock!(model: self.dataArray.objectAtIndex(self.nowIndex) as! PictureCycleModel);
        
        }
    
    }
    //定时器时间
    func timerAction(t:NSTimer){
       
        let point = CGPointMake(self.myScrollView!.contentOffset.x + self.myScrollView!.frame.width,0);
        self.myScrollView?.setContentOffset(point, animated: true);
//        print("2323");
    }


}
