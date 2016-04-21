//
//  Union_News_Pictures_Scroll_ViewController.swift
//  Union
//
//  Created by 万联 on 16/4/21.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class Union_News_Pictures_Scroll_ViewController: UIViewController {
    
    
    var pictureArray:NSMutableArray = NSMutableArray();
    
    var picturesString:String = ""{
    
        willSet{
            if self.picturesString != newValue {
                
                self.picturesString = newValue;
            }
        }
        didSet{
            
            if self.picturesString != ""{
               
              self.loadData();
            }
        
        }
    
    
    }
    var mainCollectionView:UICollectionView?
    var topView:UIView?
    var bottomView:UIView?
    var backButton:UIButton?
    var saveButton:UIButton?
    var titleLabel:UILabel?
    var pageLabel:UILabel?
    var loadingView:LoadingView?
    lazy  var reloadImgV:ReloadImageView={
    
        let reloadImg = ReloadImageView(frame: CGRectMake(0, 0, 200, 200));
        
        return reloadImg;
    
    }()
    var itemIndex:NSInteger?
    var saveImg:UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor();
        
         self.addCollectionView();
        
        self.loadCanHiddenView();
        
    }
    
    func addCollectionView(){
    
        let flowLayout :UICollectionViewFlowLayout = UICollectionViewFlowLayout.init();
        flowLayout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.mainCollectionView = UICollectionView(frame: CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height), collectionViewLayout: flowLayout);
        self.mainCollectionView?.pagingEnabled = true;
        self.mainCollectionView?.backgroundColor = UIColor.blackColor();
        self.mainCollectionView?.minimumZoomScale = 1;
        self.mainCollectionView?.maximumZoomScale = 3;
        self.mainCollectionView?.registerClass(Pictures_Sroll_CollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "CELL");
        self.mainCollectionView?.delegate = self;
        self.mainCollectionView?.dataSource = self;
        self.view.addSubview(self.mainCollectionView!);
    
    
    }
    
    func loadCanHiddenView(){
        
        self.topView = UIView(frame: CGRectMake(0,0,self.view.frame.size.width,64));
        self.topView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5);
        self.view.addSubview(self.topView!);
        
        self.backButton = UIButton(type: UIButtonType.Custom);
        self.backButton?.frame = CGRectMake(0, 20, 80, 44);
        self.backButton?.tintColor = UIColor.whiteColor();
        self.backButton?.setImage(UIImage(named: "iconfont-fanhui")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal);
        self.backButton?.addTarget(self, action: Selector("buttonToNewsView"), forControlEvents: UIControlEvents.TouchUpInside);
        self.topView?.addSubview(self.backButton!);
        
        self.saveButton = UIButton(type: UIButtonType.System);
        self.saveButton?.frame = CGRectMake(SCREEN_WIDTH - 80, 20, 80, 44);
        self.saveButton?.tintColor = UIColor.whiteColor();
        self.saveButton?.setImage(UIImage(named: "iconfont-xiazaiimage")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal);
        self.saveButton?.addTarget(self, action: Selector("saveImageAction"), forControlEvents: .TouchUpInside);
        self.topView?.addSubview(self.saveButton!);
        
        
        self.bottomView = UIView(frame: CGRectMake(0,SCREEN_HEIGHT - 70,SCREEN_WIDTH,70));
        self.bottomView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5);
        self.view.addSubview(self.bottomView!);
        
        self.titleLabel = UILabel(frame: CGRectMake(0,0,CGRectGetWidth(self.bottomView!.frame),30));
        self.titleLabel?.textAlignment = .Center;
        self.titleLabel?.font = UIFont.systemFontOfSize(16);
        self.titleLabel?.textColor = UIColor.whiteColor();
        self.titleLabel?.backgroundColor = UIColor.blackColor();
        self.titleLabel?.alpha = 0.7;
        self.bottomView?.addSubview(self.titleLabel!);
        
        self.pageLabel = UILabel(frame: CGRectMake(0,30,CGRectGetWidth(self.bottomView!.frame),40));
        self.pageLabel?.textAlignment = .Center;
        self.pageLabel?.font = UIFont.systemFontOfSize(17);
        self.pageLabel?.textColor = UIColor.whiteColor();
        self.pageLabel?.alpha = 0.9;
        self.pageLabel?.backgroundColor = UIColor.blackColor();
        self.bottomView?.addSubview(self.pageLabel!);
        
        
    
    
    }
    
    
    //MARK:下载数据
    func loadData(){
    
        self.pictureArray.removeAllObjects();
        self.mainCollectionView?.reloadData();
        
        self.loadingView?.hidden = false;
        self.reloadImgV.hidden = true;
        
        AFNetWorkingTool.getDataFromNet(self.picturesString, params: NSDictionary(), success: {[weak self] (responseObject) -> Void in
            
            self?.reloadImgV.hidden = true;
            
            if responseObject != nil{
                self?.JSONSerializationWithData(responseObject);
            }else{
                self?.reloadImgV.hidden = false;
            }
            }) {[weak self] (error) -> Void in
                
                self?.pictureArray.removeAllObjects();
                self?.mainCollectionView?.reloadData();
                self?.reloadImgV.hidden = false;
                self?.loadingView?.hidden = true;
        }
        
    
    
    
    }
    func JSONSerializationWithData(data:AnyObject?){
    
        print(data!);
        
        if data != nil{
        
            let array:NSArray = (data as! NSDictionary).valueForKey("pictures") as! NSArray;
            
            for (_,dict) in array.enumerate(){
            
//                if i >= 4{
//                
//                    break;
//                
//                }
                
                let model:Pictures_Sreoll_Model = Pictures_Sreoll_Model();
                
                model.setValuesForKeysWithDictionary(dict as! [String : AnyObject]);
                print("\(model.url!)  \(model.picDesc!)  \(model.picId!) \(model.fileHeight!) \(model.fileWidth!)");
                self.pictureArray.addObject(model);
            }
            
            print("hehe");
            
            self.mainCollectionView?.reloadData();
            
            
        }
        
    
    }
    
    
    
    
    
    
    
    
    //MARK:=============================点击按钮
    //返回主界面
    func buttonToNewsView(){
    
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        };
    
    
    }
    //保存图片
    func saveImageAction(){
    
        //传个图片地址，然后在去下载 先看看缓存有没有
        
        
        let model:Pictures_Sreoll_Model = self.pictureArray.objectAtIndex(self.itemIndex!) as! Pictures_Sreoll_Model;
        let url = NSURL(string: model.url!);
        let manager = SDWebImageManager.sharedManager();
        if manager.cachedImageExistsForURL(url!){
            self.saveImg = manager.imageCache.imageFromMemoryCacheForKey(url?.absoluteString);
        }else{
            let data:NSData = NSData(contentsOfURL: url!)!;
            self.saveImg = UIImage(data: data);
            
        }
    }
    
    func saveImageToPhotos(saveImg:UIImage){
    
        UIImageWriteToSavedPhotosAlbum(saveImg, self, Selector("imageDidFinishSaving::"), nil);
    
    
    
    }
    
    func imageDidFinishSaving(image:UIImage,error:NSError?){
    
        var msg:String?
        
        if error != nil{
            msg = "保存图片失败";
        }else{
            msg = "已成功存入相册";
        }
        
        let hud = MBProgressHUD(view: self.view);
        
        self.view.addSubview(hud);
        hud.customView = UIImageView(image: UIImage(named: "37x-Checkmark"));
        hud.mode = .CustomView;
        hud.delegate = self;
        hud.labelText = msg;
        hud.show(true);
        hud.hide(true, afterDelay: 2.0);
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

}
extension Union_News_Pictures_Scroll_ViewController:UICollectionViewDelegate,UICollectionViewDataSource,MBProgressHUDDelegate{


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.pictureArray.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CELL", forIndexPath: indexPath) as! Pictures_Sroll_CollectionViewCell;
        
        
        cell.model = self.pictureArray[indexPath.item] as! Pictures_Sreoll_Model;
        self.titleLabel?.text = cell.model.picDesc!;
        self.pageLabel?.text = NSString(format: "%ld/%ld",indexPath.item + 1,self.pictureArray.count) as String;
        return cell;
    }
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return false;
    }
    
    
    func hudWasHidden(var hud: MBProgressHUD!) {
        hud.removeFromSuperview();
        hud = nil;
    }
    




}
