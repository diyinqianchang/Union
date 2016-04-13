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

    var urlStr:String?
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
    override init(frame: CGRect, style: UITableViewStyle) {
        self.rootVc = UIViewController();
        super.init(frame: frame, style: style);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    internal func netWorkingGetVideoDetails(vid vid:String,title:String){
    
    
    }
    
    
}
