//
//  GearPowered.swift
//  Union
//
//  Created by 万联 on 16/4/11.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

@objc protocol GearPowerDelegate:NSObjectProtocol{

    func didLoadData(data:AnyObject);
    optional func settingBottomLoadDataURL() -> NSURL;
    optional func didBottomLoadData(data:AnyObject);
}

class GearPowered: NSObject {

    var url:NSURL?
    var bottomUrl:NSURL?
    weak var delegate:GearPowerDelegate?
    var isLoading:Bool?
    var isLoadingVerification:Bool = false
    var GPLView:GPLoadingView?
    var GPBLView:GPBottomLoadingView?
    var height:CGFloat?
    
    var topOrDown:NSInteger? //上拉或下拉 (0为上拉 1为下拉)
    
    var mainScrollView:UIScrollView{
    
        willSet{
            
            if self.mainScrollView != newValue{
                self.mainScrollView = newValue;
            }
        }
        didSet{
            
            self.mainScrollView.addSubview(self.GPLView!);
            self.mainScrollView.addSubview(self.GPBLView!);
            self.isLoading = false;
        }
    
    }
    var isAuxiliaryGear:Bool{
       
        willSet{
            if self.isAuxiliaryGear != newValue{
                
            self.isAuxiliaryGear = newValue;
                
            }
        }
        didSet{
         
            self.GPLView?.isAuxiliaryGear = self.isAuxiliaryGear;
           
        }
    
    }
    
    override init() {
        
        self.mainScrollView = UIScrollView();
        self.isAuxiliaryGear = false;
        super.init()
        self.GPLView = GPLoadingView(frame: CGRectMake(0,0,CGRectGetWidth(UIScreen.mainScreen().bounds),0));
        self.GPLView?.isAuxiliaryGear = false;
        
        self.GPBLView = GPBottomLoadingView(frame: CGRectMake(0,0,CGRectGetWidth(UIScreen.mainScreen().bounds),0));
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView){
      
        self.height = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.frame.size.height : scrollView.contentSize.height;
        
        let GPBLViewHeight = scrollView.contentOffset.y + self.height! - scrollView.contentSize.height;
        // 假设偏移表格高度的20%进行下拉刷新
        // 假设偏移表格高度的15%进行上拉刷新
    
        if self.isLoading == false{
            
            if -scrollView.contentOffset.y > CGRectGetHeight((self.GPLView?.frame)!){
                self.GPLView?.willLoadView();
            }
            if (-scrollView.contentOffset.y / scrollView.frame.size.height > 0.2){
                self.topOrDown = 1;
                self.isLoading = true;
            }
        }
        //判断是否为上拉操作
        if GPBLViewHeight > CGRectGetHeight((self.GPBLView?.frame)!){
           
            if self.bottomUrl != nil {self.GPBLView?.willLoadView()}
            if ((self.height! - scrollView.contentSize.height + scrollView.contentOffset.y) / self.height! > 0.15){
               
                if self.bottomUrl != nil{
                    self.topOrDown = 0;
                    self.isLoading = true;
                }
            
            }
          
        }
        self.GPLView?.frame = CGRectMake(scrollView.frame.origin.x ,  scrollView.contentOffset.y , CGRectGetWidth(scrollView.frame) , scrollView.contentOffset.y < 0 ? -scrollView.contentOffset.y : 0 );
        if (self.bottomUrl != nil){
        
            self.GPBLView?.frame = CGRectMake(scrollView.frame.origin.x , scrollView.contentSize.height  , CGRectGetWidth(scrollView.frame) , GPBLViewHeight > 0 ? GPBLViewHeight : 0 );
            
        }
        
        
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool){
    
        if self.isLoading == true {
         
            if self.isLoadingVerification == false{
              
                self.isLoadingVerification = true;
                switch(Int(self.topOrDown!)){
                case 0:
                    do{
                        if (self.delegate != nil && self.delegate!.respondsToSelector(Selector("settingBottomLoadDataURL"))){
                            
                            self.bottomUrl = self.delegate?.settingBottomLoadDataURL!()
                        }
                        if self.bottomUrl != nil{
                          
                            self.scrollViewBottomLoadingStyle(scrollView.frame.size.height - self.height!);
                            self.GPBLView?.loadingView();
                            self.loadingData(self.bottomUrl!)
                        }
                    }
                    break;
                case 1:
                    do{
                        self.scrollViewLoadingStyle();
                        self.GPLView?.loadingView();
                        self.loadingData(self.url!);
                    }
                    break;
                default:
                    break;
                }
            
            }
            
        
        }
    
    }
    
    func scrollViewLoadingStyle(){
        
      self.mainScrollView.contentInset = UIEdgeInsetsMake( 100 , 0 , 0 , 0 );
        
    }
    
    func scrollViewDidLoadStyle(){
        
        self.mainScrollView.contentInset = UIEdgeInsetsMake( 0 , 0 , 0 , 0 );
        
        self.isLoadingVerification = false;//设置加载验证状态
        
    }

    
    func scrollViewBottomLoadingStyle(contentHeight:CGFloat){
    
        self.mainScrollView.contentInset = UIEdgeInsetsMake(0, 0, contentHeight + 60, 0);
    
    }
    
    //滑动视图底部加载结束样式
    
    func scrollViewDidBottomLoadStyle(){
    
        self.mainScrollView.contentInset = UIEdgeInsetsMake( 0 , 0 , 0 , 0 );
        self.isLoadingVerification = false;//设置加载验证状态
    
    }

    
    func loadingData(url:NSURL){
    
        if self.url != nil{
         
            
            
            AFNetWorkingTool.getDataFromNet(url.absoluteString, params: NSDictionary(), success: {(responseObject) -> Void in
                
                  GCDQueue.mainQueue.excute({[weak self] () -> Void in
                    
                    switch (Int((self?.topOrDown)!)) {
                    case 0:
                        do{
                            self?.GPBLView?.didLoadView();
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)),dispatch_get_main_queue(), { () -> Void in
                                
                                if (self?.delegate != nil && self!.delegate!.respondsToSelector("didBottomLoadData:")) {
                                    self?.delegate?.didBottomLoadData!(responseObject!);
                                }
                                
                            });
                        }
                        break;
                    case 1:
                        do{
                            if (self?.delegate != nil && self!.delegate!.respondsToSelector("didLoadData:")){
                            
                                self?.delegate?.didLoadData(responseObject!);
                            
                            }
                            self?.GPLView?.didLoadView();
                        
                        }
                        break;
                    default:
                        break;
                    }
                    
                    
                    }, afterDelayWithNanoseconds: Int64(1 * NSEC_PER_SEC))
                
                
                }, failure: { (error) -> Void in
                    print(error);
                    
                    GCDQueue.executeInMainQueue({[weak self] () -> Void in
                        
                        switch (Int((self?.topOrDown)!)){
                        case 0:
                            do{
                                let lxplay = LXPlaySound();
                                    lxplay.play();
                                self?.GPBLView?.errorLoadView();
                            }
                            break;
                        case 1:
                            do{
                                let lxplay = LXPlaySound();
                                lxplay.play();
                                self?.GPLView?.errorLoadView();
                            }
                            break;
                        default:
                            break;
                        
                        }
                        
                        }, afterDelaySeconds: 1.0)
                    
            })
            
            self.GPLView?.didLoadBlock = {[weak self]() -> Void in
               
                self?.scrollViewDidLoadStyle();
                self?.isLoading = false;
            
            }
            self.GPBLView?.didLoadAnimationBlock={[weak self]() -> Void in
              
                self?.scrollViewDidBottomLoadStyle();
                self?.isLoading = false;
            }
        
        }
    
    }
    
    

}
