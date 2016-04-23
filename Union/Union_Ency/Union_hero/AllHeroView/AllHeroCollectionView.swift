//
//  AllHeroCollectionView.swift
//  Union
//
//  Created by 万联 on 16/4/23.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

//MARK: 没有做筛选

typealias AllHeroView_Block = (heroName:String) -> Void


class AllHeroCollectionView: UICollectionView {

    var dataArray:NSMutableArray = NSMutableArray();
    var showArray:NSMutableArray = NSMutableArray();
    
    var allHeroView_Block:AllHeroView_Block?
    
    lazy var relaodImg:ReloadImageView = {
    
        let reload:ReloadImageView = ReloadImageView(frame: CGRectMake(0, 0, 200, 200));
        return reload;
    }();
    
    
    
    
    lazy var loadingView:LoadingView = {
    
        let loadView:LoadingView = LoadingView(frame: CGRectMake(0,0,CGRectGetWidth(self.frame),CGRectGetHeight(self.frame)));
        loadView.backgroundColor = UIColor.blackColor();
        loadView.loadingColor = MAINCOLOR;
        loadView.hidden = true;
        return loadView;
    }()
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout);
        
        self.backgroundColor = UIColor.whiteColor();
        
        self.dataSource = self;
        self.delegate = self;
        self.registerClass(AllHeroCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "CELL");
        
        self.addSubview(self.loadingView);
        self.addSubview(self.relaodImg);
        
        self.relaodImg.reloadImgBlock = {[weak self]()->Void in
            self?.loadData();
        }
        
        self.loadData();
        
        
    }
    
    func loadData(){
    
        let caCheData = DataCache.shareInstance.getDataForDocument(dataName: "AllHeroData", ClassifyName: "Hero");
        
        if caCheData != nil{
        
            self.JSONAnalyticalWithData(caCheData);
        
        }else{
        
            self.loadingView.hidden = false;
            
        }
        
        self.relaodImg.hidden = true;
        
        let url : String = NSString(format: kUnion_Ency_HeroListURL, "all") as String
        
        AFNetWorkingTool.getDataFromNet(url, params: NSDictionary(), success: {[weak self] (responseObject) -> Void in
            
            if responseObject != nil{
            
                self?.JSONAnalyticalWithData(responseObject!);
            
                DataCache.shareInstance.saveDataForDocument(responseObject!, DataName: "AllHeroData", Classify: "Hero");
                
            }
            
            
            }) {[weak self] (error) -> Void in
                
                
                if self?.dataArray.count > 0{
                    
                    UIView.addNotifier(text: "加载失败,快看看网络去哪儿了", dismissAutomatically: true);
                
                }else{
                
                    self?.relaodImg.hidden = false;
                    self?.loadingView.hidden = true;
                }
                
                
        }
    
    
    
    }
    
    func JSONAnalyticalWithData(data:AnyObject?){
    
        if data != nil{
        
            print(data!);
            self.dataArray.removeAllObjects();
            
            let dataArr:NSArray = (data as! NSDictionary).valueForKey("all") as! NSArray;
            
            dataArr.forEach({ (itemDict) -> () in
                
                let dict = itemDict as! NSDictionary;
                
                let model = ListHeroMode();
                model.setValuesForKeysWithDictionary(dict as! [String : AnyObject]);
                self.dataArray.addObject(model)
                
            })
            
            self.showArray = self.dataArray.mutableCopy() as! NSMutableArray;
            
            self.reloadData();
        
        
        }
    
    
    
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    

}
extension AllHeroCollectionView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.showArray.count;
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CELL", forIndexPath: indexPath) as! AllHeroCollectionViewCell;
        
        let model = self.showArray[indexPath.row] as! ListHeroMode;
        cell.fillCellWithModel(model);
        return cell;
        
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // 点击跳转
         let model = self.showArray[indexPath.row] as! ListHeroMode;
        
         self.allHeroView_Block!(heroName:model.enName!);
        
        
        
    }



}
