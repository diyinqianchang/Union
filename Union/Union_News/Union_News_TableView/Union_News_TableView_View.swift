//
//  Union_News_TableView_View.swift
//  Union
//
//  Created by 万联 on 16/4/8.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

typealias UnionNewsDetailBlock = (string:String,type:String)->Void;

class Union_News_TableView_View: UIView {

    var topicBlock:UnionNewsDetailBlock?
    var detailBlock:UnionNewsDetailBlock?
    var tableView:UITableView?
    var urlString:String{
    
        willSet{
            if self.urlString != newValue{
                self.urlString = newValue;
            }
        }
        didSet{
            
            self.loadData();
            self.tableView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            self.gearPowered?.url = NSURL(string:NSString(format: self.urlString, self.page!) as String);
            self.gearPowered?.bottomUrl = NSURL(string:NSString(format: self.urlString, self.page!) as String);

        }
    
    }      //NSString
    var scrollPage:NSInteger?
    var scrollView:UIScrollView?
    var pageControl:UIPageControl?
    lazy var dataArray:NSMutableArray={
    
        let  dataArray = NSMutableArray();
        return dataArray;
    
    }(); //数据源数组
    
    
    lazy var picArray:NSMutableArray={
        let picArray = NSMutableArray();
        return picArray;
    }();  //图片数组
    
    
    var page:NSInteger?
    
    var gearPowered:GearPowered?
    var loadingView:LoadingView?
    var isBottomLoading:Bool?
    //这个可以优化成一个装文的的视图
    lazy var reloadImageView:UIImageView={
       
        let tap:UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: Selector("reloadImageViewTapAction:"));
        
        let touchImageV:UIImageView = UIImageView(frame: CGRectMake(0,0,200,200));
        touchImageV.center = CGPointMake(CGRectGetWidth(self.frame) / 2 , CGRectGetHeight(self.frame) / 2);
        touchImageV.image = UIImage(named: "reloadImage");
        touchImageV.tintColor = UIColor.lightGrayColor();
        touchImageV.backgroundColor = UIColor.clearColor();
        touchImageV.addGestureRecognizer(tap);
        touchImageV.hidden = true;
        touchImageV.userInteractionEnabled = true;
        self.addSubview(touchImageV);
        return touchImageV;
    }();
    
    var pictureCycleView:PictureCycleView?
    
    override init(frame: CGRect) {
        self.urlString = String();
        super.init(frame: frame);
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, self.frame.size.width, frame.size.height), style: UITableViewStyle.Plain);
        self.tableView?.rowHeight = 80.0;
        self.tableView?.delegate = self;
        self.tableView?.dataSource = self;
        self.addSubview(self.tableView!);
        self.tableView?.registerClass(Union_News_TableViewCell.classForCoder(), forCellReuseIdentifier: "CELL");
        
        self.page = 1;
        self.gearPowered = GearPowered();
        self.gearPowered?.mainScrollView = self.tableView!
        self.gearPowered?.isAuxiliaryGear = true;
        self.gearPowered?.delegate = self;
        
        self.loadingView = LoadingView(frame: CGRectMake(0,0,CGRectGetWidth(self.frame),CGRectGetHeight(self.frame)));
        self.loadingView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3);
        self.loadingView?.loadingColor = UIColor.whiteColor();
        self.loadingView?.hidden = true;
        self.addSubview(self.loadingView!);
        
        self.pictureCycleView = PictureCycleView(frame: CGRectMake(0,0,SCREEN_WIDTH,SCREEN_WIDTH / 7 * 4));
        self.pictureCycleView?.timeInterval = 3;
        self.pictureCycleView?.isPicturePlay = true;
        self.pictureCycleView?.selectPicBlock = {[weak self](model)->Void in
        
            let pid = model.pid!
            self?.detailBlock!(string:pid,type:String());
           
        }
        
    }

    
    
    
    func loadData(){
        
        print(self.urlString);
        
        
        let cacheData = DataCache.shareInstance.getDataForDocument(dataName:NSString(format:"%@%ld","NewsListData",self.scrollPage!) as String, ClassifyName: "News");
        if cacheData is NSNull{
            
            self.loadingView?.hidden = true;
            
        }else{
          
            self.dataArray.removeAllObjects();
            self.tableView?.reloadData();
            self.JSONSerializationWithData(cacheData);
           
        }
        self.isBottomLoading = false;
        
        AFNetWorkingTool.getDataFromNet(NSString(format: self.urlString, self.page!) as String, params:NSDictionary(), success: {[weak self] (responseObject) -> Void in
            
            if responseObject != nil{
                self?.dataArray.removeAllObjects();
                self?.tableView?.reloadData();
                self?.JSONSerializationWithData(responseObject);
                DataCache.shareInstance.saveDataForDocument(responseObject, DataName:"NewsListData" + ((NSString(format: "%ld", (self?.scrollPage)!)) as String) as String, Classify: "News");
                
            
            }else{
               
                if self?.dataArray.count == 0{
                
                    self?.reloadImageView.hidden = false;
                
                }
            
            }
            self?.loadingView?.hidden = true;
            
            }) {[weak self] (error) -> Void in
                
                if self?.dataArray.count == 0{
                    self?.reloadImageView.hidden = false;
                    self?.loadingView?.hidden = true;
                }else{
                   
                }
                
                print("error=="+"\(error)");
        }

        
    
    }
    
    func JSONSerializationWithData(data:AnyObject?){
    
        if data != nil{
            
            let dict = data as! NSDictionary
            
            
            //轮播图数据
            if  ((dict.allKeys) as NSArray).containsObject("headerline"){
                    if dict.objectForKey("headerline") != nil{
                        self.picArray.removeAllObjects();
                        let temPicArr:NSArray = dict.objectForKey("headerline") as! NSArray;
                        
                        temPicArr.forEach({[weak self] (dataDic) -> () in
                            let picDataDict:NSDictionary = (dataDic as! NSDictionary);
                            let picModel:PictureCycleModel = PictureCycleModel();
                            picModel.pid = picDataDict.objectForKey("id") as? String;
                            picModel.photoUrl = picDataDict.objectForKey("photo") as? String;
                            self?.picArray.addObject(picModel);
                            
//                            print(dataDic as! NSDictionary);
                        })
                    
                        self.tableView?.tableHeaderView = self.pictureCycleView!;
                        self.pictureCycleView?.dataArray = self.picArray
                    }else{
                        
                        if self.isBottomLoading == false{
                            
                            self.tableView?.tableHeaderView = nil;
                        }
                    
                   }
                }
            
    
            
            let dataArr:NSArray = dict["data"] as! NSArray; //表格的数据
            for(_,dictData) in dataArr.enumerate() {
            let model:Union_News_TableView_Model = Union_News_TableView_Model();
            model.setValuesForKeysWithDictionary(dictData as! [String : AnyObject]);
            self.dataArray.addObject(model);
           }
           self.tableView?.reloadData();
        
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
extension Union_News_TableView_View:UITableViewDelegate,UITableViewDataSource,GearPowerDelegate{
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        self.gearPowered?.scrollViewDidScroll(scrollView)
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        self.gearPowered?.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate);
    }
    
    func didLoadData(data: AnyObject?) {
        self.page = 1;
        self.dataArray.removeAllObjects();
        self.JSONSerializationWithData(data);
    }
    
    func didBottomLoadData(data: AnyObject?) {
        self.JSONSerializationWithData(data);
    }
    
    func settingBottomLoadDataURL() -> NSURL {
        self.isBottomLoading = true;
        self.page!++
        let url:NSURL = NSURL(string: NSString(format: self.urlString, self.page!) as String)!;
        return url
    }
    
    
    
    func reloadImageViewTapAction(tap:UITapGestureRecognizer){
    
        self.loadData();
    
    }
    
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:Union_News_TableViewCell = tableView.dequeueReusableCellWithIdentifier("CELL", forIndexPath: indexPath) as! Union_News_TableViewCell;
        
        let model:Union_News_TableView_Model = self.dataArray[indexPath.row] as! Union_News_TableView_Model;
        
        cell.fillCellWithModel(model);
        
        
    
        return cell;
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
        
        let model:Union_News_TableView_Model = self.dataArray[indexPath.row] as! Union_News_TableView_Model;
        
        if indexPath.row == 0 && model.type! == "topic"{
        
            let tempArr:NSArray = ((model.destUrl!) as NSString).componentsSeparatedByString("&");
            var topicId = String();
            for(_,tempItem) in tempArr.enumerate(){
            
                if tempItem.hasPrefix("topicId="){
                    
                    topicId = tempItem.substringFromIndex(8);
                }
            }
            self.topicBlock!(string: (NSString(format: News_TopicURL,topicId)) as String, type: model.type!);
        
        }else{
        
          self.detailBlock!(string: model.id!,type: model.type!);
        }
        
        
    }



}