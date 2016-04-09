//
//  MyUnion_UserTableViewCell.swift
//  Union
//
//  Created by 万联 on 16/4/8.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class MyUnion_UserTableViewCell: UITableViewCell {

    
    var summonerModel:SummonerModel?
    var picImageView:UIImageView?
    var userNameLabel:UILabel?
    var serverFullNameLabel:UILabel?  //服务器
    
    var tierDescLabel:UILabel?
    var levelLabel:UILabel?
    
    var zdlLabel:UILabel?
    var zdlImageView:UIImageView?
    var zdlView:UIView?
    
    var summonerName:String?
    var serverName:String?
    
    var promptLabel:UILabel?

    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        self.backgroundColor = MAINCOLOR;
        self.clipsToBounds = true;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
        self.selectionStyle = .None;
        
        self.picImageView = UIImageView(frame: CGRectMake(15,10,60,60));
        self.picImageView?.image = UIImage(named: "poluoimage_gray");
        self.picImageView?.layer.cornerRadius = 30;
        self.picImageView?.clipsToBounds = true;
        self.picImageView?.backgroundColor = UIColor.whiteColor();
        self.contentView.addSubview(self.picImageView!);
        
        //等级
       
        let levelView:UIView = UIView(frame: CGRectMake(58,55,20,20));
        levelView.layer.cornerRadius  = 10;
        levelView.backgroundColor = MAINCOLOR;
        self.contentView.addSubview(levelView);
   
    

        self.levelLabel = UILabel(frame: CGRectMake(2,2,16,16));
        self.levelLabel?.font = UIFont.systemFontOfSize(12);
        self.levelLabel?.textColor = UIColor.whiteColor();
        self.levelLabel?.backgroundColor = UIColor.clearColor();
        self.levelLabel?.textAlignment = .Center;
        levelView.addSubview(self.levelLabel!);
        
        //用户名
        self.userNameLabel = UILabel(frame: CGRectMake(80,20,CGRectGetWidth(self.frame)-160,30));
        self.userNameLabel?.textColor = UIColor.whiteColor();
        self.userNameLabel?.font = UIFont.systemFontOfSize(18);
        self.contentView.addSubview(self.userNameLabel!);
        
        self.serverFullNameLabel = UILabel(frame: CGRectMake(80,50,70,30));
        self.serverFullNameLabel?.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.8);
        self.serverFullNameLabel?.font = UIFont.systemFontOfSize(14);
        self.contentView.addSubview(self.serverFullNameLabel!);
        
        
        self.tierDescLabel = UILabel(frame: CGRectMake(155,50,60,30));
        self.tierDescLabel?.textColor = UIColor.whiteColor();
        self.tierDescLabel?.font = UIFont.systemFontOfSize(14);
        self.contentView.addSubview(self.tierDescLabel!);
        
        self.zdlView = UIView(frame: CGRectMake(CGRectGetWidth(self.frame)-100,0,240,240));
        self.zdlView?.backgroundColor = UIColor.whiteColor();
        self.zdlView?.layer.cornerRadius = 120;
        self.zdlView?.center = CGPointMake(CGRectGetWidth(self.frame)+10, CGRectGetHeight(self.frame)/2);
        self.contentView.addSubview(self.zdlView!);
    
        
        self.zdlImageView = UIImageView(frame: CGRectMake(20, 80, 80, 80));
        self.zdlImageView?.tintColor = MAINCOLOR;
        self.zdlImageView?.image = UIImage(named: "iconfont-zhandouli")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate);
        self.zdlImageView?.backgroundColor = UIColor.clearColor();
        self.zdlImageView?.alpha = 0.1;
        
        self.zdlView?.addSubview(self.zdlImageView!);
        
        
        self.zdlLabel = UILabel(frame: CGRectMake(0,90,105,60));
        self.zdlLabel?.textColor = MAINCOLOR;
        self.zdlLabel?.textAlignment = .Center;
        self.zdlLabel?.font = UIFont(name: "HelveticaNeue-UltraLight", size: 34);
        self.zdlView?.addSubview(self.zdlLabel!);
        
        self.promptLabel = UILabel(frame: CGRectMake(80,30,CGRectGetWidth(self.frame)-160,30));
        self.promptLabel?.textColor = UIColor.whiteColor();
        self.promptLabel?.font = UIFont.boldSystemFontOfSize(20);
        self.promptLabel?.text = "赶快添加召唤师吧";
        
        self.contentView.addSubview(self.promptLabel!);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("AddSuccess:"), name: "AddSuccess", object: nil);
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        
        if SCREEN_WIDTH > 320 && SCREEN_HEIGHT < 414 {
        
            self.zdlImageView?.superview?.center = CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) / 2);
            self.zdlImageView?.frame = CGRectMake(30, 80, 80 , 80);
            
            self.zdlLabel?.frame = CGRectMake(5, 90, 120 , 60);
            
            self.zdlLabel?.font = UIFont(name:"HelveticaNeue-UltraLight",size:40);
            
        }else if SCREEN_HEIGHT >= 414{
            
            self.zdlImageView?.superview?.center = CGPointMake(CGRectGetWidth(self.frame)-20, CGRectGetHeight(self.frame) / 2);
            self.zdlImageView?.frame = CGRectMake(30, 80, 80 , 80);
            
            self.zdlLabel?.frame = CGRectMake(5, 90, 130 , 60);
            
            self.zdlLabel?.font = UIFont(name:"HelveticaNeue-UltraLight",size:46);
        }
        
    }
    
    func AddSuccess(notice:NSNotification){
    
        self.loadData();
    
    }
    
    func loadData(){
        
        let defaults = NSUserDefaults.standardUserDefaults();
        let summonerStr = defaults.stringForKey("SummonerName");
        let serverNameStr = defaults.stringForKey("ServerName");
        
        if summonerStr != nil && serverNameStr != nil{
        
            self.zdlView?.center = CGPointMake(CGRectGetWidth(self.frame) + 20, CGRectGetHeight(self.frame) / 2);
            
            //隐藏提示标签
            
            self.promptLabel?.hidden = true;
            
            //显示控件
            self.showViews();
            
            if self.summonerName == nil && self.serverName == nil{
                self.summonerName = "";
                self.serverName = "";
            }
            
            if !(self.summonerName == summonerName) || !(self.serverName == serverNameStr){
            
                self.zdlView?.center = CGPointMake(CGRectGetWidth(self.frame) + 20, CGRectGetHeight(self.frame) / 2);
                self.summonerName = summonerStr;
                self.serverName = serverNameStr;
                
                //查询数据库
                
                if self.summonerModel != nil{
                
                
                }

            
            }
        
        }else{
        
            self.promptLabel?.hidden = false;
            self.zdlView?.center = CGPointMake(CGRectGetWidth(self.frame) + 100, CGRectGetHeight(self.frame) / 2);
            self.hiddenViews();
        
        
        }
    
    
    }
    
    func showViews(){
    
        self.hiddenViews();
        
        self.picImageView?.sd_setImageWithURL(NSURL(string: (NSString(format: kUnion_MyUnion_URL, (self.summonerModel?.icon)!) as String)))
        self.serverFullNameLabel?.hidden = false;
        self.userNameLabel?.hidden = false;
        self.tierDescLabel?.hidden = false;
        self.levelLabel?.hidden = false;
        self.zdlLabel?.hidden = false;
        
        
    
    }
    func hiddenViews(){
    
        self.picImageView?.image = UIImage(named:"poluoimage_gray");
        
        self.serverFullNameLabel?.hidden = true;
        
        self.userNameLabel?.hidden = true;
        
        self.tierDescLabel?.hidden = true;
        
        self.levelLabel?.hidden = true;
        
        self.zdlLabel?.hidden = true;
        
    
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
