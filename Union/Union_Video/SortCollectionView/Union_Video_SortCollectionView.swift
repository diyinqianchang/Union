//
//  Union_Video_SortCollectionView.swift
//  Union
//
//  Created by 万联 on 16/4/22.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

typealias VideoSortSearchBlock = (videoName:String)->Void

typealias VideoSortCellClickBlock = (tag:String,name:String)->Void;


class Union_Video_SortCollectionView: UICollectionView {
    
    
    var itemClickBlock:VideoSortCellClickBlock?
    
    
    var sortSearchBlock:VideoSortSearchBlock?

    var dataArray:NSMutableArray = NSMutableArray()
    var headerArray:NSMutableArray = NSMutableArray()
    
    
    var gearPowered:GearPowered?
    var loadingView:LoadingView?
    lazy var reloadImg:ReloadImageView = {
    
        let reload:ReloadImageView = ReloadImageView(frame: CGRectMake(0,0,200,200));
        
        reload.reloadImgBlock = {[weak self]() -> Void in
        
            self?.loadData();
        
        }
        
        return reload;
    
    
    }()
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        super.init(frame: frame, collectionViewLayout: layout);
        
        self.backgroundColor = UIColor.whiteColor();
        self.delegate = self;
        self.dataSource = self;
        
        self.registerClass(SortCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "CELL");
        self.registerClass(SortCollectionViewReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header");
        
        
        self.gearPowered = GearPowered();
        self.gearPowered?.mainScrollView = self;
        self.gearPowered?.isAuxiliaryGear = true;
        self.gearPowered?.delegate = self;
        self.gearPowered?.url = NSURL(string: kUnion_Video_SortURL);
        
        self.loadingView = LoadingView(frame: CGRectMake(0,0,CGRectGetWidth(self.frame),CGRectGetHeight(self.frame)));
        self.loadingView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3);
        self.loadingView?.loadingColor = UIColor.whiteColor();
        self.loadingView?.hidden = true;
        self.addSubview(self.loadingView!);
        
        self.loadData();
        
        
    }
    
    func loadData(){
    
        let caCheData = DataCache.shareInstance.getDataForDocument(dataName: "VideoSortData", ClassifyName: "Video");
     
        if caCheData != nil{
        
            self.loadingView?.hidden = false;
        
        }else{
        
            self.NSJSONSerializationWithData(caCheData);
        }
        
        self.reloadImg.hidden = true;
        
        AFNetWorkingTool.getDataFromNet(kUnion_Video_SortURL, params: NSDictionary(), success: {[weak self] (responseObject) -> Void in
            
            if responseObject != nil{
            
                self?.NSJSONSerializationWithData(responseObject);
                DataCache.shareInstance.saveDataForDocument(responseObject, DataName: "VideoSortData", Classify: "Video");
            
            }else{
               self?.reloadImg.hidden = false;
            }
              self?.loadingView?.hidden = true;
            
            }) {[weak self] (error) -> Void in
                
                if self?.dataArray.count > 0{
                
                    UIView.addNotifier(text: "加载失败 快看看网络去哪了", dismissAutomatically: true);
                }else{
                 
                    self?.reloadImg.hidden = false;
                    self?.loadingView?.hidden = true;
                    
                }
        }
        
        
        
    
    }
    
    func NSJSONSerializationWithData(data:AnyObject?){
        
//        print(data!);
    
        if data != nil{
        
            self.dataArray.removeAllObjects();
            self.headerArray.removeAllObjects();
            
            let dataArr:NSMutableArray = data as! NSMutableArray;
            
            for (_,dict) in dataArr.enumerate(){
            
                let subArray:NSMutableArray = (dict as! NSDictionary).objectForKey("subCategory") as! NSMutableArray;
                self.headerArray.addObject((dict as! NSDictionary).objectForKey("name")!)
                
                let itemArray = NSMutableArray();
                for (_,subDict) in subArray.enumerate(){
                
                    let model = SortModel();
                    model.setValuesForKeysWithDictionary(subDict as! [String:AnyObject]);
                    itemArray.addObject(model);
                }
            
                self.dataArray.addObject(itemArray);
            
            
            }
            
            self.reloadData();
        }
    
    
    }
    
    
    
    
    
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   

}


extension Union_Video_SortCollectionView:GearPowerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return self.dataArray.count;
        
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.dataArray.count == 0 {
        
            return 0;
        
        }
//        print("=====>\(self.dataArray[section].count)");
        return self.dataArray[section].count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CELL", forIndexPath: indexPath) as! SortCollectionViewCell;
        
        let model = (self.dataArray[indexPath.section] as! NSArray)[indexPath.row] as! SortModel
        
        cell.fillCellWithModel(model)
        return cell;
        
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0{
            
            return CGSizeMake(SCREEN_WIDTH, 80)
            
        }else{
        
            return CGSizeMake(SCREEN_WIDTH, 30);
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let VRC:SortCollectionViewReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! SortCollectionViewReusableView;
        if indexPath.section == 0{
        
            VRC.reusableViewSearchBlock = {[weak self](videoName:String) -> Void in
            
                self?.sortSearchBlock!(videoName: videoName);
                print("搜索词条\(videoName)");
            
            }
            VRC.textField?.hidden = false;
      
            
        }else{
        
            VRC.textField?.hidden = true;
        
        }
        VRC.myHeaderLabel?.text = self.headerArray[indexPath.section] as? String;
        return VRC
        
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let model:SortModel = (self.dataArray[indexPath.section] as! NSArray)[indexPath.row] as! SortModel;
        
        self.itemClickBlock!(tag:model.tag!,name: model.name!);
        
        
    }
    
    
    

    //MARK:===============GearPowerDelegate========================
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.gearPowered?.scrollViewDidScroll(scrollView);
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.gearPowered?.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate);
    }

    func didLoadData(data: AnyObject?) {
        
        self.NSJSONSerializationWithData(data);
        
    }
//    func didBottomLoadData(data: AnyObject?) {
//        
//    }
//    func settingBottomLoadDataURL() -> NSURL {
//        
//    }
    
    
    
    


}


