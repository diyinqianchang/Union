//
//  Union_VideoListTableView.swift
//  Union
//
//  Created by 万联 on 16/4/13.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

typealias VideoListSelectedVideoBlock=(videoArr:NSMutableArray,videoTitle:String)->Void;

class Union_VideoListTableView: UITableView {

    var urlStr:String{
    
        willSet{
            if self.urlStr != newValue{
                self.urlStr = newValue;
            }
        }
        didSet{
        
        }
    
    }
    var selectVideoBlick:VideoListSelectedVideoBlock?
    var rootVc:UIViewController{
        willSet{
            if self.rootVc != newValue{
                self.rootVc = newValue;
            }
        }
        didSet{
            
        }
    
    }
    var isShowLoadingView:Bool?
    
    var tableArr:NSMutableArray?
    var gearPowered:GearPowered?
    var loadingView:LoadingView?
    var page:NSInteger? //页数
    var videoArray:NSMutableArray? //视频详情数组
    var selectedCellIndex:NSInteger?//选中的cell
    var lastSelectCellIndex:NSInteger? //上一次选中的cell
    var reloadImageView:UIImageView?
    
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        self.rootVc = UIViewController();
        self.urlStr = String();
        super.init(frame: frame, style: style);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    internal func netWorkingGetVideoDetails(vid vid:String,title:String){
    
    
    }
    
    
}
extension Union_VideoListTableView{




}
