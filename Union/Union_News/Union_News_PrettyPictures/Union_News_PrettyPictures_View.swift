//
//  Union_News_PrettyPictures_View.swift
//  Union
//
//  Created by 万联 on 16/4/20.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit


typealias PrettyPictures_View_Block = (galleryId:String)->Void

class Union_News_PrettyPictures_View: UIView {

    var urlString:String = ""{
    
        willSet{
        
            if self.urlString != newValue{
            
                self.urlString = newValue;
                
            }
        
        }
        didSet{
            self.loadData();
            
            self.gearPowered?.url = NSURL(string: NSString(format: self.urlString, self.page!) as String);
            self.gearPowered?.bottomUrl = NSURL(string: NSString(format: self.urlString, self.page!) as String);
        
        }
    
    
    }
    
    var mainCollectionView:UICollectionView?
    var dataArray:NSMutableArray = NSMutableArray();
    var imageArray:NSMutableArray?
    var gearPowered:GearPowered?
    var loadingView:LoadingView?
    lazy var reloadImageView:ReloadImageView = {
    
        let reloadImg:ReloadImageView = ReloadImageView(frame: CGRectMake(0, 0, 200, 200));
        reloadImg.reloadImgBlock = {[weak self]() -> Void in
        
            self?.loadData();
        
        }
        
        return reloadImg;
    
    }()
    var page:NSInteger?
    
    var prettyPictures_View_Block:PrettyPictures_View_Block?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame);
        
//        let layOut:UICollectionViewFlowLayout = UICollectionViewFlowLayout();
//        layOut.minimumInteritemSpacing = 5;
//        layOut.minimumLineSpacing = 10;
        
        let layOut:WaterFlowLayout = WaterFlowLayout()
        
        self.mainCollectionView = UICollectionView(frame: CGRectMake(0,0,self.frame.width,self.frame.height), collectionViewLayout: layOut);
        self.mainCollectionView?.backgroundColor = UIColor.whiteColor();
        self.mainCollectionView?.delegate = self;
        self.mainCollectionView?.dataSource = self;
        self.mainCollectionView?.alwaysBounceVertical = true;
        
        self.addSubview(self.mainCollectionView!);
        
        self.mainCollectionView?.registerClass(PrettyPictureCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "CELL");
        self.page = 1;
        
        self.gearPowered = GearPowered();
        self.gearPowered?.mainScrollView = self.mainCollectionView!;
        self.gearPowered?.isAuxiliaryGear = true;
        self.gearPowered?.delegate = self;
        
        
        self.loadingView = LoadingView(frame: CGRectMake(0,0,CGRectGetWidth(self.frame),CGRectGetHeight(self.frame)));
        self.loadingView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3);
        self.loadingView?.loadingColor = UIColor.whiteColor();
        self.addSubview(self.loadingView!);
        
    }
    
    
    func loadData(){
    
        self.loadingView?.hidden = false;
        
        self.reloadImageView.hidden = true;
        
        let url = NSString(format: self.urlString, self.page!) as String;
        
        AFNetWorkingTool.getDataFromNet(url, params: NSDictionary(), success: {[weak self] (responseObject) -> Void in
            
            self?.reloadImageView.hidden = true;
            self?.dataArray.removeAllObjects();
            self?.mainCollectionView!.reloadData();
            
            if responseObject != nil{
            
                self?.JSONSerializationWithData(responseObject!);
            
            }else{
            
                self?.reloadImageView.hidden = false;
            
            }
            self?.loadingView?.hidden = true;
            
            
            }) {[weak self] (error) -> Void in
                
                self?.dataArray.removeAllObjects();
                
                self?.mainCollectionView?.reloadData();
                
                self?.reloadImageView.hidden = false;
                
                self?.loadingView?.hidden = true;
                
        }
    
    
    }
    
    
    
    func JSONSerializationWithData(data:AnyObject?){
    
        if data != nil{
        
            print(data!);
            
            let tempArray:NSArray = (data as! NSDictionary).objectForKey("data") as! NSArray
            
            for (_,dict) in tempArray.enumerate(){
            
                let model:PrettyPicturesModel = PrettyPicturesModel();
                
                model.setValuesForKeysWithDictionary(dict as! [String : AnyObject]);
               
                self.dataArray.addObject(model);
                
            }
//            print(self.dataArray);
            self.mainCollectionView!.reloadData();
        
        
        }
    
    
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
extension Union_News_PrettyPictures_View:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,GearPowerDelegate{

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if self.dataArray.count != 0{
            
        let model:PrettyPicturesModel = self.dataArray[indexPath.item] as! PrettyPicturesModel;
        let width = (model.coverWidth! as NSString).floatValue
        let height = (model.coverHeight! as NSString).floatValue
            
            return CGSizeMake((SCREEN_WIDTH - 20) / 2, CGFloat(height) / CGFloat(width) * (SCREEN_WIDTH - 20) / 2.0 );
            
        }else{
        
            return CGSizeZero;
        
        }
        
        
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataArray.count;
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(5, 5, 5, 5);
        
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CELL", forIndexPath: indexPath) as! PrettyPictureCollectionViewCell;
        
        cell.model = self.dataArray[indexPath.item] as! PrettyPicturesModel;
//        print("234");
        return cell;
        
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
       
        return true;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let model = self.dataArray[indexPath.item] as! PrettyPicturesModel;
        
        self.prettyPictures_View_Block!(galleryId: model.galleryId!);
        
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        self.gearPowered?.scrollViewDidScroll(scrollView);
        
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
        
      self.page!++ ;
      return  NSURL(string: NSString(format: self.urlString,self.page!) as String)!
        
    }




}















