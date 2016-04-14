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
    
    var videoTitle:String{
      
        get{
            return self.videoTitle;
        }
        set{
        
        }
    }
    var videoArr:NSMutableArray{
    
        get{
            return self.videoArr;
        }
        set{

        }
    
    }
    //视屏播放控制请
    var moviePlay:MPMoviePlayerController?
//    var mo:AVPlayerViewController?
    var timer:NSTimer?
    var loadingView:LoadingView?
    
    var topView:UIView? //顶部控制视图
    var topBackButton:UIButton? //顶部返回按钮
    var topTitleLabel:UILabel?  //顶部标题Label
    var topDefinitionButton:UIButton? //顶部清晰度切换按钮
    var topDefinitionListView:UIView? //顶部清晰度列表视图
    var palyButton:UIButton?          //播放按钮
    var slider:UISlider?              //播放进度条滑块
    var progressView:UIProgressView?  //缓冲进度条视图
    var playTimeLabel:UILabel?        //播放时间Label;
    var videoDurationLabel:UILabel?   //视屏时长
    
    
    var bottomView:UIView? //底部控制视图
    
    var volumeView:UIView?  //音量视图
    var volumeSlider:UIView? //侧边音量滑块
    var systemVolumeSlider:UISlider? //系统音量滑块
    var volumeImgV:UIImageView?  //音量图标
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
