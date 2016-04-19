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
            self.gearPowered?.url = NSURL(string:NSString(format: self.urlStr, self.page!) as String);
            self.gearPowered?.bottomUrl = NSURL(string:NSString(format: self.urlStr, self.page!) as String);
            
            self.loadData();
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
    
    lazy var tableArray:NSMutableArray = {
      
        let tableArr = NSMutableArray();
        return tableArr;
        
    }();
    var gearPowered:GearPowered?
    lazy var loadingView:LoadingView = {
    
        let loadView:LoadingView = LoadingView(frame: self.frame);
        
        loadView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3);
        loadView.loadingColor = MAINCOLOR;
        loadView.hidden = true;
        return loadView;
    
    }();
    var page:NSInteger? //页数
    lazy var videoArray:NSMutableArray={
    
        let array = NSMutableArray();
        return array;
    
    }() //视频详情数组
    var selectedCellIndex:NSInteger?//选中的cell
    var lastSelectCellIndex:NSInteger? //上一次选中的cell
    lazy var reloadImageView:UIImageView = {
    
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("reloadImageViewTapAction:"));
        
        let imageV:UIImageView = UIImageView(frame: CGRectMake(0,0,200,200));
        imageV.center = CGPointMake(SCREEN_WIDTH / 2,(SCREEN_HEIGHT - 64) / 2);
        imageV.image = UIImage(named: "reloadImage")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate);
        imageV.tintColor = UIColor.lightGrayColor();
        imageV.backgroundColor = UIColor.clearColor();
        imageV.userInteractionEnabled = true;
        imageV.hidden = true;
        imageV.addGestureRecognizer(tap);
        return imageV;
    }();
    
    lazy var videoPlayerVc:VideoPlayerViewController = {
     
        let playerVc = VideoPlayerViewController();
        return playerVc;
    
    }();
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        self.rootVc = UIViewController();
        self.urlStr = String();
        super.init(frame: frame, style: style);
        self.delegate = self;
        self.dataSource = self;
        self.registerClass(VideoListTableViewCell.classForCoder(), forCellReuseIdentifier: "cell");
        
        self.selectedCellIndex = -1;
        self.lastSelectCellIndex = -1;
        self.page = 1;
        
        self.gearPowered = GearPowered();
        self.gearPowered?.mainScrollView = self;
        self.gearPowered?.isAuxiliaryGear = true;
        self.gearPowered?.delegate = self;
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData(){
    
        self.superview?.addSubview(self.loadingView);
        self.superview?.insertSubview(self.loadingView, aboveSubview: self);
        self.loadingView.hidden = false;
        
        self.addSubview(self.reloadImageView);
        self.reloadImageView.hidden = true;
        
        self.separatorStyle = .None;
        
        AFNetWorkingTool.getDataFromNet((NSString(format: self.urlStr, self.page!) as String), params: NSDictionary(), success: {[weak self] (responseObject) -> Void in
            
            self?.tableArray.removeAllObjects();
            self?.reloadData();
            
            if responseObject != nil{
            
                self?.separatorStyle = .SingleLine;
                self?.NSJSONSerializationWithData(responseObject);
            
            }else{
            
                self?.reloadImageView.hidden = false;
            
            
            }
            self?.loadingView.hidden = true;
            
            
            }) { (error) -> Void in
                
                self.tableArray.removeAllObjects();
                self.reloadData();
                self.reloadImageView.hidden = false;
                self.loadingView.hidden = true;
        }
        
    }
    
    internal func netWorkingGetVideoDetails(vid vid:String,title:String){
    
        self.loadingView.hidden = false;
        
        AFNetWorkingTool.getDataFromNet((NSString(format: kUnion_VideoDetailsURL, vid) as String), params: NSDictionary(), success: {[weak self] (responseObject) -> Void in
            
//            print(responseObject);
            
            if responseObject != nil{
                
                self?.JSONSerializationVideoDetailsWithData(responseObject);
                self?.playVideoToVPVC((self?.videoArray)!, videoTitle: title);
                self?.loadingView.hidden = true;
            }
            
            }) {[weak self] (error) -> Void in
                
                UIView.addNotifier(text: "加载失败 快看看网络去哪了", dismissAutomatically: true);
                self?.loadingView.hidden = true;
                
        }
        
    
    }
    
    func NSJSONSerializationWithData(data:AnyObject?){
    
        if data != nil{
        
//            print(data!);
        
        }
    
    }
    
    func JSONSerializationVideoDetailsWithData(data:AnyObject?){
        
        if data != nil{
        
            self.videoArray.removeAllObjects();
//            print("heheh===>" + "\(data!)");
            let resultDic:NSDictionary = (data as! NSDictionary).objectForKey("result") as! NSDictionary;
            let itemsDic:NSDictionary = resultDic.objectForKey("items") as! NSDictionary;
            
            for(_,key) in itemsDic.allKeys.enumerate(){
            
                let itemDic:NSDictionary = itemsDic.objectForKey(key) as! NSDictionary;
                
                let videoModel:VideoDetailsModel = VideoDetailsModel();
                videoModel.setValuesForKeysWithDictionary(itemDic as! [String : AnyObject]);
                
                print(videoModel.transcode?.duration!);
                self.videoArray.addObject(videoModel);
            }
            
            self.videoArray.sortUsingComparator({(model1, model2) -> NSComparisonResult in
                
                if ((model1 as! VideoDetailsModel).definition! as NSString).integerValue > ((model2 as! VideoDetailsModel).definition! as NSString).integerValue{
                    return NSComparisonResult.OrderedDescending;
                }else{
                    return NSComparisonResult.OrderedAscending;
                }
            })
            
//            self.videoArray.forEach({ (model1) -> () in
//                print("\((model1 as! VideoDetailsModel).definition!)");
//            })
           
            
        
        }
    
    
    }
    
    func playVideoToVPVC(videoArray:NSMutableArray,videoTitle:String){
    
        if videoArray.count > 0{
            
            self.videoPlayerVc.videoArr = videoArray;
            self.videoPlayerVc.videoTitle = videoTitle;
            self.rootVc.presentViewController(self.videoPlayerVc, animated: true, completion: { () -> Void in
                
            });
        
        }else{
        
            UIView.addNotifier(text: "视频不存在了..其他视频一样精彩", dismissAutomatically: true);
          
        }
    
    }
    
    
}
extension Union_VideoListTableView:UITableViewDelegate,UITableViewDataSource,GearPowerDelegate{

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath);
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90;
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableArray.count;
    }
    
    //重新加载
    func reloadImageViewTapAction(tap:UITapGestureRecognizer){
    
        self.loadData();
    
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.gearPowered?.scrollViewDidScroll(scrollView);
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.gearPowered?.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate);
    }
    
    
    //GearPowerDelegate
    func didLoadData(data: AnyObject?) {
        
        self.page = 1;
        self.tableArray.removeAllObjects();
        self.NSJSONSerializationWithData(data);
    }
    func didBottomLoadData(data: AnyObject?) {
        self.NSJSONSerializationWithData(data);
    }
    func settingBottomLoadDataURL() -> NSURL {
        self.page!++
        return NSURL(string:NSString(format: self.urlStr, self.page!) as String)!;
    }


}
