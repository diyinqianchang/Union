//
//  Pictures_Sroll_CollectionViewCell.swift
//  Union
//
//  Created by 万联 on 16/4/21.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class Pictures_Sroll_CollectionViewCell: UICollectionViewCell {
    
    var model:Pictures_Sreoll_Model = Pictures_Sreoll_Model(){
    
        willSet{
        
            if self.model != newValue{
                self.model = newValue;
            }
        
        
        }
        didSet{
        
            self.cellScrollView?.zoomScale = 1;
            let url = NSURL(string: self.model.url!)
            self.roundProgressView?.progress = 0.0;
            
            self.HUD?.show(true);
            
            self.imageView?.sd_setImageWithURL(url!, placeholderImage: UIImage(named: "imagedefault"), options: SDWebImageOptions.CacheMemoryOnly, progress: {[weak self] (receive, exprect) -> Void in
                
                
                let progress = Float(receive) / Float(exprect);
                
                self?.roundProgressView?.progress = progress;
                
                
                
                }, completed: {[weak self] (image, error, cachType, imageURL) -> Void in
                    self?.hudWasHidden(self?.HUD);
            })
            
            let width = self.model.fileWidth;
            let height = self.model.fileHeight;
            
            self.imageView?.frame = CGRectMake(0, 0, self.cellScrollView!.frame.size.width, self.cellScrollView!.frame.size.width / (CGFloat(width!) / CGFloat(height!)));
            self.cellScrollView?.contentSize = CGSizeMake(CGRectGetWidth(self.imageView!.frame), CGRectGetHeight(self.imageView!.frame));
            self.imageView?.center = CGPointMake(CGRectGetWidth(self.cellScrollView!.frame) / 2 , CGRectGetHeight(self.cellScrollView!.frame) / 2 )
            
        
        
        }
    
    
    
    
    
    
    } //图片数据
    var imageView:UIImageView?
    var titleLable:UILabel?
    var cellScrollView:UIScrollView?
    
    var HUD:MBProgressHUD?
    var roundProgressView:MBRoundProgressView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.cellScrollView = UIScrollView(frame: CGRectMake(0,0,frame.width,frame.height));
        self.cellScrollView?.contentSize = CGSizeMake(frame.width, frame.height);
        self.cellScrollView?.maximumZoomScale = 3;
        self.cellScrollView?.minimumZoomScale = 1;
        self.cellScrollView?.delegate = self;
        self.cellScrollView?.zoomScale = 1;
        self.contentView.addSubview(self.cellScrollView!);
        
        
        let imageTap = UITapGestureRecognizer(target: self, action: Selector("imageTapAction"));
        imageTap.numberOfTapsRequired = 2
        imageTap.numberOfTouchesRequired = 1;
        
        self.imageView = UIImageView();
        self.imageView?.userInteractionEnabled = true;
        self.imageView?.addGestureRecognizer(imageTap);
        
        self.cellScrollView?.addSubview(self.imageView!);
        
        
        self.roundProgressView = MBRoundProgressView(frame: CGRectMake(0,0,64,64));
        
        self.HUD = MBProgressHUD(view: self);
        
        self.addSubview(self.HUD!);
        self.HUD?.color = UIColor.clearColor();
        self.HUD?.mode = MBProgressHUDMode.CustomView;
        self.HUD?.delegate = self;
        self.HUD?.customView = self.roundProgressView;
        
        
        
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension Pictures_Sroll_CollectionViewCell:MBProgressHUDDelegate,UIScrollViewDelegate{


    func hudWasHidden(var hud: MBProgressHUD!) {
        
        hud.removeFromSuperview();
        hud = nil;
        
    }
    func imageTapAction(tap:UITapGestureRecognizer){
    
        self.cellScrollView?.zoomScale = 1;
    
    }
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return self.imageView;
    }
    //MARK: 当scrollView缩放的时候频繁相应的方法
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
        let delat_x = scrollView.bounds.size.width > scrollView.contentSize.width ? (scrollView.bounds.size.width - scrollView.contentSize.width) / 2 : 0
        let delat_y = scrollView.bounds.size.height > scrollView.contentSize.height ? (scrollView.bounds.size.height - scrollView.contentSize.height) / 2 : 0
        self.imageView?.center = CGPointMake(scrollView.contentSize.width / 2 + delat_x, scrollView.contentSize.height / 2 + delat_y);
        
    }




}
