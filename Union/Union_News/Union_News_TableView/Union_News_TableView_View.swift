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
//        self.gearPowered?.delegate = self;
        
        self.loadingView = LoadingView(frame: CGRectMake(0,0,CGRectGetWidth(self.frame),CGRectGetHeight(self.frame)));
        self.loadingView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3);
        self.loadingView?.loadingColor = UIColor.whiteColor();
        self.loadingView?.viewHidden = true;
        self.addSubview(self.loadingView!);
        
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

//             let dict = responseObject as! NSDictionary
//
//
//            let dataArr:NSArray = dict["data"] as! NSArray;
////            print(dataArr.count);
//
//            for(_,dictData) in dataArr.enumerate() {
//                let model:Union_News_TableView_Model = Union_News_TableView_Model();
//                model.setValuesForKeysWithDictionary(dictData as! [String : AnyObject]);
//                self?.dataArray.addObject(model);
//            }
            self?.dataArray.removeAllObjects();
            self?.tableView?.reloadData();
            self?.JSONSerializationWithData(responseObject);
            DataCache.shareInstance.saveDataForDocument(responseObject, DataName:"NewsListData" + ((NSString(format: "%ld", (self?.scrollPage)!)) as String) as String, Classify: "News");
           
            self?.loadingView?.hidden = true;
            
            }) { (error) -> Void in
                
               
                
                print("error=="+"\(error)");
        }

        
    
    }
    
    func JSONSerializationWithData(data:AnyObject?){
    
        if data != nil{
            
            let dict = data as! NSDictionary
            let dataArr:NSArray = dict["data"] as! NSArray;
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
extension Union_News_TableView_View:UITableViewDelegate,UITableViewDataSource{

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