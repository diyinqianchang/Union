//
//  PrettyPictureCollectionViewCell.swift
//  Union
//
//  Created by 万联 on 16/4/20.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class PrettyPictureCollectionViewCell: UICollectionViewCell,MBProgressHUDDelegate {
    
    
    var coverImageView:UIImageView?
    var titleLable:UILabel?
    var picsumLable:UILabel?
    var model:PrettyPicturesModel{
    
        willSet{
        
            if self.model != newValue{
                self.model = newValue;
            }
        
        }
        didSet{
        
            self.picsumLable?.text = NSString(format: "共%@张", self.model.picsum!) as String;
            
            self.titleLable?.text = self.model.title?.removeSensitiveWordsWithArray(["手机盒子"]);
            
            if SettingManager.sharedInstance.loadImageAccordingToTheSetType(){
            
                self.promptLable?.hidden = true;
                self.roundProgressView?.progress = 0.0;
                self.HUD?.show(true);
                
                self.coverImageView?.sd_setImageWithURL(NSURL(string: self.model.coverUrl!), placeholderImage: UIImage(named: ""), options: SDWebImageOptions.CacheMemoryOnly, progress: {[weak self] (receiveSize, expectedSize) -> Void in
                    
                    let progressFloat = Float(receiveSize) / Float(expectedSize);
                    
                    self?.roundProgressView?.progress = progressFloat;
                    
                    }, completed: {[weak self] (image, error, cachType, imageURL) -> Void in
                        self?.HUD?.hidden;
                })
            
            }else{
            
                self.promptLable?.hidden = false;
            
            }
        
        }
    
    
    }
    
    
    private var HUD:MBProgressHUD?
    private var roundProgressView:MBRoundProgressView?
    private var promptLable:UILabel?
    
    
    
    override init(frame: CGRect) {
        self.model = PrettyPicturesModel();
        super.init(frame: frame);
        
        self.coverImageView = UIImageView();
        self.contentView.addSubview(self.coverImageView!);
        
        self.titleLable = UILabel();
        self.titleLable?.font = UIFont.systemFontOfSize(14.0);
        self.titleLable?.textColor = UIColor.blackColor();
        self.titleLable?.backgroundColor = UIColor.whiteColor();
        self.titleLable?.textAlignment = .Left;
        self.titleLable?.numberOfLines = 0;
        self.contentView.addSubview(self.titleLable!);
        
        self.picsumLable = UILabel();
        self.picsumLable?.backgroundColor = UIColor.blackColor();
        self.picsumLable?.alpha = 0.7;
        self.picsumLable?.textAlignment = .Right;
        self.picsumLable?.textColor = UIColor.whiteColor();
        self.picsumLable?.font = UIFont.systemFontOfSize(14);
        self.contentView.addSubview(self.picsumLable!);
        
        self.promptLable = UILabel();
        self.promptLable?.text = "我是图~";
        self.promptLable?.font = UIFont.boldSystemFontOfSize(22);
        self.promptLable?.textColor = UIColor.lightGrayColor();
        self.promptLable?.hidden = true;
        self.contentView.addSubview(self.promptLable!);
        
        
        self.roundProgressView = MBRoundProgressView(frame: CGRectMake(0,0,40,40));
        self.roundProgressView?.progressTintColor = UIColor.lightGrayColor();
        
        self.HUD = MBProgressHUD(view: self);
        self.addSubview(self.HUD!);
        self.HUD?.color = UIColor.clearColor();
        self.HUD?.customView = self.roundProgressView!;
        
        
        
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        self.coverImageView?.frame = CGRectMake(0, 0, self.frame.width, self.frame.height - 50);
        self.titleLable?.frame = CGRectMake(0, self.frame.height - 50, self.coverImageView!.frame.width, 50);
        
        self.picsumLable?.frame = CGRectMake(0, self.frame.size.height - 50 - 18, self.coverImageView!.frame.size.width, 18);
        
        self.promptLable?.frame = CGRectMake(0, 0, 80,30);
        
        self.promptLable?.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.coverImageView!.frame) / 2);
    }
    
    func hudWasHidden(var hud: MBProgressHUD!) {
        hud.removeFromSuperview();
        hud = nil;
    }
    
    
}
