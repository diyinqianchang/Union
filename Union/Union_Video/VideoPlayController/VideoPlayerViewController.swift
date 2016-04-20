//
//  VideoPlayerViewController.swift
//  Union
//
//  Created by 万联 on 16/4/14.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit

class VideoPlayerViewController: UIViewController {
    
    var videoTitle:String = ""{
      
        willSet{
            if self.videoTitle != newValue{
                self.videoTitle = newValue;
            }
        }
        didSet{
             print("=====>\(self.videoTitle)");
            self.topTitleLabel?.text = self.videoTitle;
        }
    }
    var videoArr:NSMutableArray = []{
    
        willSet{
            if self.videoArr != newValue{
                self.moviePlayer.contentURL = nil;
                self.nowPlayTime = 0;
                self.videoArr = newValue;
                
                print("----->\(self.videoArr)");
                
            }
        }
        didSet{
            if self.videoArr.count > 0{
            
                if self.definitionIndex > videoArr.count - 1{
                
                    self.definitionIndex = videoArr.count - 1;
                
                }
                self.topDefinitionListView?.subviews.forEach({ (view) -> () in
                    if view.isKindOfClass(UIButton.classForCoder()){
                        view.hidden = true;
                    }
                })
                for(i,_) in self.videoArr.enumerate(){
                    print(i);
                    let btn = self.topDefinitionListView?.subviews[i] as! UIButton;
                    btn.hidden = false;
                }
                self.loadingView?.hidden = false;
                self.moviePlayer.contentURL = self.getNetworkUrl();
                self.addNotification();
                 //缓冲
                self.moviePlayer.prepareToPlay();
                self.moviePlayer.play();
            }

        }
    
    }
    //视屏播放控制请
    lazy var moviePlayer:MPMoviePlayerController = {
        
        let player = MPMoviePlayerController.init();
        
        player.view.frame = CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height);
        
        print(player.view.frame);
        
        player.view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth,UIViewAutoresizing.FlexibleHeight];
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"));
          tap.delegate = self;
        player.view.addGestureRecognizer(tap);
        
        let doubleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleDoubleTap:"));
           doubleTap.numberOfTapsRequired = 2;
        
        player.view.addGestureRecognizer(doubleTap);
        //长按
        let longPress:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("handleLongPress:"));
        longPress.minimumPressDuration = 2;
        player.view.addGestureRecognizer(longPress);
        
        return player;
    
    }();
    
    lazy var timer:NSTimer? = {
        let timer = NSTimer(timeInterval: 1.0, target: self, selector: Selector("playTimerAction:"), userInfo: nil, repeats: true);
        let runLoop = NSRunLoop.currentRunLoop();
        runLoop.addTimer(timer, forMode: NSDefaultRunLoopMode);
        return timer;
    }()
    
    var loadingView:LoadingView?
    
    var topView:UIView? //顶部控制视图
    var topBackButton:UIButton? //顶部返回按钮
    var topTitleLabel:UILabel?  //顶部标题Label
    var topDefinitionButton:UIButton? //顶部清晰度切换按钮
    var topDefinitionListView:UIView? //顶部清晰度列表视图
    var playButton:UIButton?          //播放按钮
    var slider:UISlider?              //播放进度条滑块
    var progressView:UIProgressView?  //缓冲进度条视图
    var playTimeLabel:UILabel?        //播放时间Label;
    var videoDurationLabel:UILabel?   //视屏时长
    
    
    var bottomView:UIView?            //底部控制视图
    
    var volumeView:UIView?           //音量视图
    var volumeSlider:UISlider?         //侧边音量滑块
    var systemVolumeSlider:UISlider? //系统音量滑块
    var volumeImgV:UIImageView?      //音量图标
    
    
    var promptView:UIView?        //缩进快进视图
    var promptValueLable:UILabel?  //提示滑动的值
    var promptTimeLable:UILabel?   //提示时间Label
    
    var startPoint:CGPoint?       //触摸起始点
    var endPoint:CGPoint?         //触摸结束点
    var changeTime:NSInteger = 0      //改变的时间
    var nowPlayTime:Double?       //当前播放时间
    var moveDirection:NSInteger?  //触摸移动方向
    var definitionIndex:NSInteger = 0{
    
        willSet{
            
            if self.definitionIndex != newValue{
                self.definitionIndex = newValue;
            }
        
        }didSet{
            
            if self.videoArr.count != 0{
            
                if self.videoArr.count - 1 >= self.definitionIndex{
                
                    self.topDefinitionListView?.hidden = true;
                    self.topDefinitionListView?.alpha = 0.0;
                    
                    var title:String?
                    switch self.definitionIndex{
                    
                    case 0:
                        title = "标清";
                        break;
                    case 1:
                        title = "高清";
                        break;
                    case 2:
                        title = "超清";
                        break;
                    default:
                        break;
                    }
                    self.topDefinitionButton?.setTitle(title!, forState: .Normal);
                    
                    self.moviePlayer.contentURL = self.getNetworkUrl();
                    self.moviePlayer.prepareToPlay();
                    self.moviePlayer.play();
                
                }
            
            
            }
            
        
        
        }
    
    
    
    } //视频清晰度下标
    
    
    var isDismiss:Bool?      //是否退出
    
    
    
    func loadTopView(){
    
        self.topView = UIView(frame: CGRectMake(0,0,CGRectGetWidth(self.view.frame),64));
        self.topView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6);
        self.view.addSubview(self.topView!);
        
        //返回按钮
        self.topBackButton = UIButton(type: UIButtonType.Custom);
        self.topBackButton?.backgroundColor = UIColor.clearColor();
        self.topBackButton?.tintColor = UIColor.whiteColor();
        self.topBackButton?.setImage(UIImage(named: "iconfont-fanhui")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState:.Normal);
        self.topBackButton?.frame = CGRectMake(0, 20, 60, 44);
        self.topBackButton?.addTarget(self, action: Selector("backButtonAction:"), forControlEvents: .TouchUpInside);
        self.topView?.addSubview(self.topBackButton!);
        
        //初始化清晰度按钮
        self.topDefinitionButton = UIButton(type: .Custom);
        self.topDefinitionButton?.frame = CGRectMake(CGRectGetWidth(self.topView!.frame) - 70, 27, 60, 30);
        self.topDefinitionButton?.layer.borderWidth = 1.0;
        self.topDefinitionButton?.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.7).CGColor;
        self.topDefinitionButton?.layer.cornerRadius = 5.0;
        self.topDefinitionButton?.layer.masksToBounds = true;
        self.topDefinitionButton?.addTarget(self, action: Selector("DefinitionButtonAction:"), forControlEvents: .TouchUpInside);
        self.topDefinitionButton?.titleLabel?.font = UIFont.systemFontOfSize(14.0);
        self.topDefinitionButton?.setTitle("标清", forState: .Normal); // 默认标清
        self.topDefinitionButton?.setTitleColor(UIColor.lightGrayColor(), forState: .Normal);
        self.topView?.addSubview(self.topDefinitionButton!);
        
        //初始化清晰度列表视图
        self.topDefinitionListView = UIView(frame: CGRectMake(0,0,100,150));
        self.topDefinitionListView?.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) / 2);
        self.topDefinitionListView?.backgroundColor = UIColor.blackColor();
        self.topDefinitionListView?.hidden = true;
        self.topDefinitionListView?.alpha = 0;    //默认隐藏
        self.view.addSubview(self.topDefinitionListView!);
        
        do{
            let BDButton = UIButton(type: UIButtonType.Custom);
            BDButton.frame = CGRectMake(0, 10, CGRectGetWidth(self.topDefinitionListView!.frame), 40);
            BDButton.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6);
            BDButton.setTitle("标清", forState: .Normal);
            BDButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal);
            BDButton.addTarget(self, action: Selector("BDButtonAction:"), forControlEvents: .TouchUpInside);
            self.topDefinitionListView?.addSubview(BDButton);
            
            let HDButton = UIButton(type: UIButtonType.Custom);
            HDButton.frame = CGRectMake(0, 60, CGRectGetWidth(self.topDefinitionListView!.frame), 40);
            HDButton.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6);
            HDButton.setTitle("高清", forState: .Normal);
            HDButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal);
            HDButton.addTarget(self, action: Selector("HDButtonAction:"), forControlEvents: .TouchUpInside);
            self.topDefinitionListView?.addSubview(HDButton);

            let FHDButton = UIButton(type: UIButtonType.Custom);
            FHDButton.frame = CGRectMake(0, 110, CGRectGetWidth(self.topDefinitionListView!.frame), 40);
            FHDButton.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6);
            FHDButton.setTitle("超清", forState: .Normal);
            FHDButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal);
            FHDButton.addTarget(self, action: Selector("FHDButtonAction:"), forControlEvents: .TouchUpInside);
            self.topDefinitionListView?.addSubview(FHDButton);
        }
        
        
        
        //初始化标题
        self.topTitleLabel = UILabel(frame: CGRectMake(65,20,CGRectGetWidth(self.topView!.frame) - 135,44));
        self.topTitleLabel?.textColor = UIColor.whiteColor();
        self.topTitleLabel?.textAlignment = .Center;
        self.topTitleLabel?.font = UIFont.systemFontOfSize(16);
        self.topView?.addSubview(self.topTitleLabel!);
    
    
    }
    
    func loadBottomView(){
    
        self.bottomView = UIView(frame: CGRectMake(0,CGRectGetHeight(self.view.frame) - 60,CGRectGetWidth(self.view.frame),60));
        self.bottomView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6);
        self.view.addSubview(self.bottomView!);
        
        self.playButton = UIButton(type: .Custom);
        self.playButton?.backgroundColor = UIColor.clearColor();
        self.playButton?.tintColor = UIColor.whiteColor();
        self.playButton?.setImage(UIImage(named: "iconfont-zanting")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: .Normal);
        self.playButton?.setImage(UIImage(named: "iconfont-bofang"), forState:.Selected);
        self.playButton?.frame = CGRectMake(5, 5, 50, 50);
        self.playButton?.addTarget(self, action: Selector("playButtonAction:"), forControlEvents: .TouchUpInside);
        self.bottomView?.addSubview(self.playButton!);
        
        //进度条
        self.progressView = UIProgressView(progressViewStyle: .Default);
        self.progressView?.frame = CGRectMake(70, 29, CGRectGetWidth(self.view.frame) - 100, 10);
        self.progressView?.trackTintColor = UIColor.blackColor();  //进度条颜色
        self.progressView?.progressTintColor = UIColor.lightGrayColor();
        self.progressView?.userInteractionEnabled = false;
        self.bottomView?.addSubview(self.progressView!);
        
        //初始化播放进度滑块
        self.slider = UISlider(frame: CGRectMake(68,15,CGRectGetWidth(self.view.frame) - 96,30));
        self.slider?.minimumTrackTintColor = MAINCOLOR;
        self.slider?.maximumTrackTintColor = UIColor.clearColor();
        self.slider?.tintColor = UIColor.whiteColor();
        self.slider?.minimumValue = 0.0;
        self.slider?.setThumbImage(UIImage(named: "iconfont-dian")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal);
        self.slider?.addTarget(self, action: Selector("SliderAction:"), forControlEvents: .ValueChanged);
        self.bottomView?.addSubview(self.slider!);
        
        //初始化播放时间
        self.playTimeLabel = UILabel(frame: CGRectMake(CGRectGetWidth(self.view.frame) - 150,30,60,30));
        self.playTimeLabel?.text = "00:00:00";
        self.playTimeLabel?.textColor = UIColor.whiteColor();
        self.playTimeLabel?.textAlignment = .Center;
        self.playTimeLabel?.font = UIFont.systemFontOfSize(12);
        self.bottomView?.addSubview(self.playTimeLabel!);
        
        
        //初始化视频时长
        self.videoDurationLabel = UILabel(frame: CGRectMake(CGRectGetWidth(self.view.frame) - 90,30,70,30));
        self.videoDurationLabel?.text = " - 00:00:00";
        self.videoDurationLabel?.textColor = UIColor.whiteColor();
        self.videoDurationLabel?.textAlignment = .Left;
        self.videoDurationLabel?.font = UIFont.systemFontOfSize(12);
        self.bottomView?.addSubview(self.videoDurationLabel!);
    }
    
    func loadVolumeView(){
    
        self.volumeView = UIView(frame: CGRectMake(CGRectGetWidth(self.view.frame) - 40,0,40,160));
        self.volumeView?.center = CGPointMake(self.volumeView!.center.x, CGRectGetHeight(self.view.frame) / 2);
        self.volumeView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6);
        self.view.addSubview(self.volumeView!);
        
        //声音滑块
        self.volumeSlider = UISlider(frame: CGRectMake(-40,60,120,20));
        self.volumeSlider?.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2 * 3));
        self.volumeSlider?.minimumTrackTintColor = MAINCOLOR;
        self.volumeSlider?.maximumTrackTintColor = UIColor.lightGrayColor();
        self.volumeSlider?.tintColor = UIColor.whiteColor();
        self.volumeSlider?.maximumValue = 1.0;
        self.volumeSlider?.minimumValue = 0.0;
        self.volumeSlider?.setThumbImage(UIImage(named: "iconfont-dian")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: .Normal);
        self.volumeSlider?.addTarget(self, action: Selector("VolumeSliderAction:"), forControlEvents: .ValueChanged);
        self.volumeView?.addSubview(self.volumeSlider!);
        
        //音标视图
        self.volumeImgV = UIImageView(frame: CGRectMake(10,135,20,20));
        self.volumeImgV?.tintColor = UIColor.whiteColor();
        self.volumeImgV?.image = UIImage(named: "iconfont-yinliangxiao")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate);
        self.volumeView?.addSubview(self.volumeImgV!);
        
        //获取系统音量
        let systemVolumeView = MPVolumeView();
        systemVolumeView.center = CGPointMake(-1000, -1000);
        systemVolumeView.hidden = false;
        for (_,view) in systemVolumeView.subviews.enumerate(){
            if  view.classForCoder.description() == "MPVolumeSlider"{
                self.systemVolumeSlider = view as? UISlider;
                break;
            }
        
        }
        print("系统音量\(self.systemVolumeSlider!.value)");
        //同步系统音量
        self.volumeSlider?.value = self.systemVolumeSlider!.value;
    
    }
    
    func loadPromptView(){
    
        self.promptView = UIView(frame: CGRectMake(0,0,240,180));
        self.promptView?.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) / 2);
        self.promptView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6);
        self.promptView?.layer.cornerRadius = 8;
        self.promptView?.hidden = true;
        self.view.addSubview(self.promptView!);
        
        self.promptValueLable = UILabel(frame: CGRectMake(0,50,CGRectGetWidth(self.promptView!.frame),60));
        self.promptValueLable?.text = "+00:00:15";
        self.promptValueLable?.textAlignment = .Center;
        self.promptValueLable?.textColor = UIColor.whiteColor();
        self.promptValueLable?.font = UIFont.boldSystemFontOfSize(40);
        self.promptView?.addSubview(self.promptValueLable!);
        
        self.promptTimeLable = UILabel(frame: CGRectMake(0,CGRectGetHeight(self.promptView!.frame) - 50,CGRectGetWidth(self.promptView!.frame),40));
        self.promptTimeLable?.textColor = UIColor.lightGrayColor();
        self.promptTimeLable?.text = "00:00:00/00:05:30";
        self.promptTimeLable?.textAlignment = .Center;
        self.promptView?.addSubview(self.promptTimeLable!);
    
    
    }
    //重新布局
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        
        self.topView?.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.topView!.frame));
        self.topBackButton?.frame = CGRectMake(0, 20, 60, 40);
        self.topDefinitionButton?.frame = CGRectMake(CGRectGetWidth(self.topView!.frame) - 80, 27, 60, 30);
        self.topDefinitionListView?.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) / 2);
        self.topTitleLabel?.frame = CGRectMake(65, 20, CGRectGetWidth(self.topView!.frame)-150, 44);
        
        //底部控制
        self.bottomView?.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 60, CGRectGetWidth(self.view.frame), 60);
        self.playButton?.frame = CGRectMake(5, 5, 50, 50);
        self.progressView?.frame = CGRectMake(70, 29, CGRectGetWidth(self.view.frame) - 100, 10);
        self.slider?.frame = CGRectMake(68, 15, CGRectGetWidth(self.view.frame) - 96, 30);
        self.playTimeLabel?.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 150, 30, 60, 30);
        self.videoDurationLabel?.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 90 , 30 , 70 , 30);
        
        // 音量控制视图布局
        self.volumeView?.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 40 , 0, 40, 160);
        self.volumeView?.center = CGPointMake( self.volumeView!.center.x, CGRectGetHeight(self.view.frame) / 2);
        self.volumeImgV?.frame = CGRectMake(10, 135, 20, 20);
        
        //加载提示布局
        self.promptView?.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2 , CGRectGetHeight(self.view.frame) / 2);
        self.loadingView?.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2 , CGRectGetHeight(self.view.frame) / 2);


    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.isDismiss = false;
        SettingManager.sharedInstance.downloadViewHiddenOrShow(true);
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated);
        
        if self.moviePlayer.isPreparedToPlay == true{
            
            self.moviePlayer.stop();
            
        }else{
         
            self.isDismiss = true;
            
        }
        SettingManager.sharedInstance.downloadViewHiddenOrShow(false);
        
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
         print("0");
        
        
        self.view.addSubview(self.moviePlayer.view);
        self.moviePlayer.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height);
        self.moviePlayer.controlStyle = .None;
        self.moviePlayer.scalingMode = MPMovieScalingMode.AspectFill;
        
       
        
        self.loadTopView();
        self.loadBottomView();
        self.loadVolumeView();
        self.loadPromptView();
        
        
        
        self.loadingView = LoadingView(frame: CGRectMake(0,0,100,100));
        self.loadingView?.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) / 2);
        self.loadingView?.loadingColor = UIColor.whiteColor();
        self.loadingView?.hidden = true;
        self.view.addSubview(self.loadingView!);
        
        


    }
    //界面消失
    func backButtonAction(btn:UIButton){
    
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        };
    
    }
    //播放按钮
    func playButtonAction(btn:UIButton){
    
        if btn.selected{
            self.moviePlayer.play();
        }else{
            self.moviePlayer.pause();
        }
    
    }
    //播放滑块
    func SliderAction(slider:UISlider){
    
        self.moviePlayer.currentPlaybackTime = Double(slider.value);
    
    }
    //音量滑块
    func VolumeSliderAction(slider:UISlider){
    
        if slider.value == 0{
            self.volumeImgV?.image = UIImage(named: "iconfont-yinliangjingyin")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate);
        }else if slider.value >= 0.8{
        
            self.volumeImgV?.image = UIImage(named: "iconfont-yinliangda")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate);
         
        }else{
        
          self.volumeImgV?.image = UIImage(named: "iconfont-yinliangxiao")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate);
        }
        self.systemVolumeSlider?.setValue(slider.value, animated: true);
    
    }
    
    func DefinitionButtonAction(btn:UIButton){
    
        if self.topDefinitionListView?.hidden == true {
        
            self.topDefinitionButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal);
            
            for(i,_) in self.videoArr.enumerate(){
            
                if self.definitionIndex == i{
                
                    (self.topDefinitionListView?.subviews[i] as! UIButton).setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal);
                }else{
                
                    (self.topDefinitionListView?.subviews[i] as! UIButton).setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal);
                
                }
            
            }
            
            self.topDefinitionListView?.hidden = false;
            
            UIView.animateWithDuration(0.3, animations: {[weak self] () -> Void in
                self?.topDefinitionListView?.alpha = 1;
                }, completion: { (finished) -> Void in
                    
            })
        
        }else{
        
            self.topDefinitionButton?.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal);
            UIView.animateWithDuration(0.3, animations: {[weak self] () -> Void in
                self?.topDefinitionListView?.alpha = 0;
                }, completion: { (finished) -> Void in
                    self.topDefinitionListView?.hidden = true;
            })
        
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //标清事件按钮
    func BDButtonAction(btn:UIButton){
    
        self.definitionIndex = 0;
    
    }
    //MARK:超清事件
    func HDButtonAction(btn:UIButton){
       
        self.definitionIndex = 1;
    }
    func FHDButtonAction(btn:UIButton){
        
        self.definitionIndex = 2;
    }
    
    
    deinit{
        
        self.timer!.invalidate();
        self.timer = nil;
        NSNotificationCenter.defaultCenter().removeObserver(self);
    
    }
    

}
extension VideoPlayerViewController:UIGestureRecognizerDelegate{
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
    
    //MARK:触摸事件
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.bringSubviewToFront(self.promptView!);
        let touch:UITouch = (touches as NSSet).anyObject() as! UITouch;
        self.startPoint = touch.locationInView(self.view);
        
        self.endPoint = self.startPoint;
        self.moveDirection = 0;
        
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let endTouch:UITouch = (touches as NSSet).anyObject() as! UITouch;
        self.endPoint = endTouch.locationInView(self.view);
        
        if self.moveDirection == 1 || self.moveDirection == 0{
        
            if self.startPoint!.x - self.endPoint!.x > 10 || self.startPoint!.x - self.endPoint!.x < -10{
                self.moveDirection = 1
            }
            if self.moveDirection == 1{
            
                self.promptView?.hidden = false;
                if self.startPoint?.x < self.endPoint?.x{
                    self.changeTime = 2 + self.changeTime;
                }else if self.startPoint?.x > self.endPoint?.x{
                    self.changeTime = self.changeTime - 2;
                }
                self.promptValueLable?.text = NSString(format: "%@%@", self.changeTime > 0 ? "+" : "-",self.getStringWithTime(Double(self.changeTime))) as String;
            }
            
        
        }
        
        if self.moveDirection == 2 || self.moveDirection == 0{
        
            if (self.startPoint?.y)! - (self.endPoint?.y)! > 10 || (self.startPoint?.y)! - (self.endPoint?.y)! < -10{
            
                self.moveDirection = 2;
            
            }
            if self.moveDirection == 2{
            
                if self.startPoint!.y > self.endPoint!.y{
                    
                    self.volumeSlider?.value += 0.02;
                }else if self.startPoint!.y < self.endPoint!.y{
                    
                    self.volumeSlider?.value -= 0.02;
                }
                
                self.VolumeSliderAction(self.volumeSlider!);
            
            }
        
        }
        
        if self.moveDirection != 0{
        
            self.startPoint = self.endPoint;
        
        }
        
    }
    
    //MARK: 触控结束
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.changeTimeHandele();
    }
    
    //MARK:========改变播放时间
    func changeTimeHandele(){
    
        if self.changeTime != 0{
        
            self.slider?.value += Float(self.changeTime);
            self.SliderAction(self.slider!);
        
        }
        self.moveDirection = 0;
        self.changeTime = 0;
        self.promptView?.hidden = true;
    
    
    }
    
    
    //时间格式装换
    func getStringWithTime(var time:Double)->String{
        
        
        if time.isNaN{
           return "00:00:00";
        }
        
        if time < 0{
            time  = 0 - time;
        }
        
//        print(time);
        
        var timeString:String?
        
        var MM:Int = 0;
        var HH:Int = 0;
        if 59 < time{
        
            MM = Int(time / 60);
            if 3599 < time{
            
                HH = Int(time / 3600);
            }
            
        }
//         print("\(MM)==>\(HH)");
        
        let SS:Int = Int(floor(time - Double(MM * 60)));
        
        timeString = NSString(format: "%.2d:%.2d:%.2d",HH, MM > 59 ? MM - 60 : MM,SS) as String;
        
//        print(timeString!);
        
        return timeString!;
    
    
    }
    
    
    func getNetworkUrl()->NSURL{
    
        let model:VideoDetailsModel = self.videoArr[self.definitionIndex] as! VideoDetailsModel;
        let urlArr = model.transcode?.urls!;
        var urlStr:NSString = urlArr![0] as! NSString;
        
      urlStr
         = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!;
        let url = NSURL(string: urlStr as String);
//        print("heheh  \(url)")
        return url!;
    
    
    }
    
    
    func addNotification(){
    
        let notificationCenter = NSNotificationCenter.defaultCenter();
        notificationCenter.addObserver(self, selector: Selector("mediaPlayerPlaybackStateChange:"), name: MPMoviePlayerPlaybackStateDidChangeNotification, object: self.moviePlayer);
        //媒体播放完成或手动退出
        notificationCenter.addObserver(self, selector: Selector("mediaPlayerPlaybackFinished:"), name: MPMoviePlayerPlaybackDidFinishNotification, object: self.moviePlayer);
        //确定媒体播放时长后
        notificationCenter.addObserver(self, selector: Selector("mediaPlayerPlaybackDuration:"), name: MPMovieDurationAvailableNotification, object: self.moviePlayer);
        //媒体网络加载状态改变
        notificationCenter.addObserver(self, selector: Selector("mediaPlayerLoadStateDidChange:"), name: MPMoviePlayerLoadStateDidChangeNotification, object: self.moviePlayer);
        
        notificationCenter.addObserver(self, selector: Selector("systemVolumeChanged:"), name: "AVSystemController_SystemVolumeDidChangeNotification", object:nil);
        
    }
    
    
        func mediaPlayerPlaybackStateChange(notice:NSNotification){
        
            switch self.moviePlayer.playbackState{
            
            case MPMoviePlaybackState.Playing:
                print("正在播放")
                print(self.moviePlayer.view.frame);
                self.playButton?.selected = false;
                //启动定时器
                self.timer!.fireDate = NSDate();
                self.moviePlayer.currentPlaybackTime = self.nowPlayTime!;
                
                if self.loadingView?.hidden == false{
                    self.loadingView?.hidden = true;
                }
                
                break;
            case MPMoviePlaybackState.Paused:
                print("暂停");
                self.playButton?.selected = true;
                self.timer!.fireDate = NSDate.distantFuture();
                if self.moviePlayer.currentPlaybackTime >= self.moviePlayer.playableDuration{
                
                    self.loadingView?.hidden = false;
                
                }
                break;
            case MPMoviePlaybackState.Stopped:
                print("停止");
                self.playButton?.selected = true;
                self.timer!.fireDate = NSDate.distantFuture();
                break;
            case MPMoviePlaybackState.Interrupted:
                print("中断");
                self.playButton?.selected = true;
                self.timer!.fireDate = NSDate.distantFuture();
                break;
            case MPMoviePlaybackState.SeekingForward:
                print("前进");
                break;
            case MPMoviePlaybackState.SeekingBackward:
                print("后退");
                break;
            default:
                print(self.moviePlayer.playbackState);
                break;
            
            }
        }
    
    
        func mediaPlayerPlaybackFinished(notice:NSNotification){
        
          self.dismissViewControllerAnimated(true) { () -> Void in
            
            };
        
        }
    
        func mediaPlayerPlaybackDuration(notice:NSNotification){
        
            self.videoDurationLabel?.text = NSString(format: "- %@", self.getStringWithTime(Double(self.moviePlayer.duration))) as String;
            
            self.slider?.maximumValue = Float(self.moviePlayer.duration);
        
        }
    
    
        func mediaPlayerLoadStateDidChange(notice:NSNotification){
            
            switch self.moviePlayer.loadState{
            
                case MPMovieLoadState.Unknown:      //未知状态
                    print("======未知")
                    break;
                case MPMovieLoadState.Playable:    //可播状态
                    print("kebo")
                    self.loadingView?.hidden = true;
                    if self.isDismiss == true{
                        self.moviePlayer.pause();
                        self.moviePlayer.stop();
                    }
                    break;
                case MPMovieLoadState.PlaythroughOK:  //加载完成
                    
                    self.loadingView?.hidden = true;
                    
                    break;
                case MPMovieLoadState.Stalled:  //正在加载
                    self.loadingView?.hidden = false;
                    break;
                
                default:
                    break;
            
            
            }
        
        
        }
    
        func systemVolumeChanged(notice:NSNotification){
        
            self.volumeSlider?.value = self.systemVolumeSlider!.value;
            self.VolumeSliderAction(self.volumeSlider!)
        
        }
    

    func playTimerAction(timer:NSTimer){
    
        self.playTimeLabel?.text = NSString(format: "%@", self.getStringWithTime(Double(self.moviePlayer.currentPlaybackTime))) as String;
        
        self.promptTimeLable?.text = NSString(format: "%@/%@", self.getStringWithTime(Double(self.moviePlayer.currentPlaybackTime)),self.getStringWithTime(Double(self.moviePlayer.duration))) as String;
        
        self.slider?.value = Float(self.moviePlayer.currentPlaybackTime);
        
        self.nowPlayTime = self.moviePlayer.currentPlaybackTime;
        
        let loadProgress = self.moviePlayer.playableDuration / self.moviePlayer.duration;
        
        self.progressView?.setProgress(Float(loadProgress), animated: true);
    
    
    }
    
    
    
    
    //单击 隐藏控制器的边框
    func handleTap(tap:UIGestureRecognizer){
        //提示视图隐藏判断 (由于点击手势可能会截获touchEnded响应 所以要在这里判断做出操作)
        if self.promptView?.hidden == true{
        
            if self.topView?.frame.origin.y >= 0{
            
                self.hiddenControllerView()
                UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide);
            }else{
            
                self.showControlView();
                UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide);
            
            }
            
        }else{
        
            self.changeTimeHandele();
        
        }
    
    }
    //双击 横竖屏的变换
    func handleDoubleTap(doubelTap:UIGestureRecognizer){
    
        if UIDevice.currentDevice().orientation == UIDeviceOrientation.Portrait{
        
            UIDevice.currentDevice().setValue(NSNumber(integer:UIDeviceOrientation.Portrait.rawValue), forKey: "orientation");
            UIDevice.currentDevice().setValue(NSNumber(integer:UIDeviceOrientation.LandscapeLeft.rawValue), forKey: "orientation");
        }else{
            
            UIDevice.currentDevice().setValue(NSNumber(integer: Int(UIDeviceOrientation.Portrait.rawValue)), forKey: "orientation");
            UIDevice.currentDevice().setValue(NSNumber(integer: Int(UIDeviceOrientation.LandscapeLeft.rawValue)), forKey: "orientation");
        
        }
        
    
    }
    //长按 播放速率
    func handleLongPress(longPress:UILongPressGestureRecognizer){
    
        self.moviePlayer.currentPlaybackRate = 0.2;
        
        if longPress.state == UIGestureRecognizerState.Ended{
        
            self.moviePlayer.currentPlaybackRate = 1.0;
        
        }
    
    }
    
    
    
    //MARK:隐藏或者显示视图
    func showControlView(){
    
    
        UIView.animateWithDuration(0.5, animations: {[weak self] () -> Void in
            
            self?.bottomView?.frame = CGRectMake(0, CGRectGetHeight((self?.moviePlayer.view.frame)!) - 60, CGRectGetWidth((self?.bottomView!.frame)!), 60);
            self?.topView?.frame = CGRectMake(0 , 0 , CGRectGetWidth((self?.topView!.frame)!), CGRectGetHeight((self?.topView!.frame)!));
            self?.showVolumeControlView();
            }) { (finished) -> Void in
        }
    }
    func showVolumeControlView(){
    
        UIView.animateWithDuration(0.5, animations: {[weak self] () -> Void in
            
            self?.volumeView?.frame = CGRectMake(CGRectGetWidth((self?.moviePlayer.view.frame)!) -  40, (self?.volumeView!.frame.origin.y)!, CGRectGetWidth((self?.volumeView!.frame)!), CGRectGetHeight((self?.volumeView!.frame)!))
            
            
            }) { (finished) -> Void in
                
        }

    
    }
    func hiddenControllerView(){
    
        UIView.animateWithDuration(0.5, animations: {[weak self] () -> Void in
            
            self?.topView?.frame = CGRectMake(0, -64, CGRectGetWidth((self?.topView!.frame)!), CGRectGetHeight((self?.topView!.frame)!));
            self?.bottomView?.frame = CGRectMake(0, CGRectGetHeight((self?.moviePlayer.view.frame)!), CGRectGetWidth((self?.bottomView!.frame)!), 60);
//            self?.topView?.frame.origin = CGPointMake(0, -64);
            self?.hiddenVolumeControlView();
            }) { (finished) -> Void in
                
        }
    
    }
    func hiddenVolumeControlView(){
    
        UIView.animateWithDuration(0.4, animations: {[weak self] () -> Void in
            
            self?.volumeView?.frame = CGRectMake(CGRectGetWidth((self?.moviePlayer.view.frame)!), (self?.volumeView!.frame.origin.y)!, CGRectGetWidth((self?.volumeView!.frame)!), CGRectGetHeight((self?.volumeView!.frame)!))
            
            
            }) { (finished) -> Void in
                
        }
        
    }
    

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent;
    }

    override func shouldAutorotate() -> Bool {
        
        return true;
    }




}
