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
//                    let btn = self.topDefinitionListView?.subviews[i] as! UIButton;
//                    btn.hidden = false;
                }
                self.loadingView?.hidden = false;
                self.moviePlayer.contentURL = self.getNetworkUrl();
//                //缓冲
                self.moviePlayer.prepareToPlay();
                self.moviePlayer.play();
            }

        }
    
    }
    //视屏播放控制请
    lazy var moviePlayer:MPMoviePlayerController = {
        
        let player = MPMoviePlayerController();
        player.view.frame = self.view.bounds;
        player.view.autoresizingMask = [.FlexibleWidth,.FlexibleHeight];
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"));
        player.view.addGestureRecognizer(tap);
        
        let doubleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleDoubleTap:"));
           doubleTap.numberOfTapsRequired = 2;
        player.view.addGestureRecognizer(doubleTap);
        //长按
        let longPress:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("andleLongPress:"));
        longPress.minimumPressDuration = 2;
        player.view.addGestureRecognizer(longPress);
        
        return player;
    
    }();
//    var mo:AVPlayerViewController?
    var timer:NSTimer?
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
    var changeTime:NSInteger?      //改变的时间
    var nowPlayTime:CGFloat?       //当前播放时间
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
        
        
        //初始化标题
        self.topTitleLabel = UILabel(frame: CGRectMake(65,20,CGRectGetWidth(self.topView!.frame) - 135,44));
        self.topTitleLabel?.textColor = UIColor.whiteColor();
        self.topTitleLabel?.textAlignment = .Center;
        self.topTitleLabel?.font = UIFont.systemFontOfSize(16);
        self.topTitleLabel?.text = self.videoTitle;
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
        self.progressView?.frame = CGRectMake(70, 29, CGRectGetWidth(self.view.frame), 10);
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
        self.slider?.frame = CGRectMake(68, 15, CGRectGetWidth(self.view.frame) - 96, 10);
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
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.addSubview(self.moviePlayer.view);
        self.moviePlayer.controlStyle = .None;
        self.moviePlayer.scalingMode = .AspectFit;
        
        self.addNotification();
        self.loadTopView();
        self.loadBottomView();
        self.loadVolumeView();
        self.loadPromptView();
        
        self.loadingView = LoadingView(frame: CGRectMake(0,0,100,100));
        self.loadingView?.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) / 2);
        self.loadingView?.loadingColor = UIColor.whiteColor();
        self.loadingView?.hidden = true;
        self.view.addSubview(self.loadingView!);
        
        print("=====>\(self.videoTitle)");
        


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
    
    
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
extension VideoPlayerViewController{
    
    
    func getNetworkUrl()->NSURL{
    
        let model:VideoDetailsModel = self.videoArr[self.definitionIndex] as! VideoDetailsModel;
        let urlArr = model.transcode?.urls!;
        var urlStr:NSString = urlArr![0] as! NSString;
        
      urlStr
         = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!;
        let url = NSURL(string: urlStr as String);
        print("heheh  \(urlStr)")
        return url!;
    
    
    }
    
    
    func addNotification(){
    
    
    
    }

    //单击
    func handleTap(tap:UIGestureRecognizer){
    
    
    }
    //双击
    func handleDoubleTap(doubelTap:UIGestureRecognizer){
    
    
    }
    //长按
    func handleLongPress(longPress:UILongPressGestureRecognizer){
    
    
    }
    






}
