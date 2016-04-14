//
//  ClearCacheSettingViewController.swift
//  Union
//
//  Created by 万联 on 16/4/11.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class ClearCacheSettingViewController: UIViewController {

    
   
    var dataCache:DataCache?
    let dataArr:Array<String> = ["英雄资料缓存","物品资料缓存","图片资料","资讯缓存"];
    var clearBtn:UIButton?
    var clearDict:NSMutableDictionary?
    lazy var mainTableView:UITableView={
        let tableView:UITableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Grouped);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.registerClass(ClearCacheSettingCell.classForCoder(), forCellReuseIdentifier: "cell");
        return tableView;
    
    }();
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.dataCache = DataCache.shareInstance;
        self.clearDict = NSMutableDictionary();
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "清空缓存设置";
        self.view.addSubview(self.mainTableView);
        self.addTableFootView();
        
    }
    
    func addTableFootView(){
    
        let footerView:UIView = UIView(frame: CGRectMake(0,0,SCREEN_WIDTH,64));
        footerView.backgroundColor = UIColor.clearColor();
        self.clearBtn = UIButton(type: .Custom);
        self.clearBtn?.frame = CGRectMake(20, 10, SCREEN_WIDTH - 40, 44);
        self.clearBtn?.backgroundColor = RGB(250, g: 85, b: 88);
        self.clearBtn?.clipsToBounds = true;
        self.clearBtn?.layer.cornerRadius = 5.0;
        self.clearBtn?.setTitle("确认", forState: .Normal);
        self.clearBtn?.setTitleColor(UIColor.whiteColor(), forState: .Normal);
        self.clearBtn?.addTarget(self, action: Selector("clearButtonAction:"), forControlEvents: .TouchUpInside);
        footerView.addSubview(self.clearBtn!);
        self.mainTableView.tableFooterView = footerView;
    
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    func clearButtonAction(btn:UIButton){
        
        /**
        *  方式按钮重复点击
        */
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: Selector("clearButtonAction:"), object: nil);
        
        if (self.clearDict?.valueForKey("HeroCell") as! ClearCacheSettingCell).isClear {
            self.dataCache?.removeClassifyCache("Hero");
            (self.clearDict?.valueForKey("HeroCell") as! ClearCacheSettingCell).detailTitleLabel?.text = "0.00KB";
        }
        if (self.clearDict?.valueForKey("EquipCell") as! ClearCacheSettingCell).isClear {
            self.dataCache?.removeClassifyCache("Equip");
            (self.clearDict?.valueForKey("EquipCell") as! ClearCacheSettingCell).detailTitleLabel?.text = "0.00KB";
        }
        if (self.clearDict?.valueForKey("ImageCell") as! ClearCacheSettingCell).isClear {
            SDImageCache.sharedImageCache().clearMemory();
            SDImageCache.sharedImageCache().clearDisk();
            (self.clearDict?.valueForKey("ImageCell") as! ClearCacheSettingCell).detailTitleLabel?.text = "0.00KB";
        }
        if (self.clearDict?.valueForKey("NewsCell") as! ClearCacheSettingCell).isClear {
            self.dataCache?.removeClassifyCache("News");
            (self.clearDict?.valueForKey("NewsCell") as! ClearCacheSettingCell).detailTitleLabel?.text = "0.00KB";
        }
        

        let hud:MBProgressHUD = MBProgressHUD(view: self.view);
        self.view.addSubview(hud);
        hud.customView = UIImageView(image: UIImage(named: "37x-Checkmark"));
        hud.mode = MBProgressHUDMode.CustomView;
        hud.delegate = self;
        hud.labelText = "成功清空缓存";
        hud.show(true);
        hud.hide(true, afterDelay: 2.0);
    }

}


extension ClearCacheSettingViewController:UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate{
    
    func hudWasHidden(var hud: MBProgressHUD!) {
        hud.removeFromSuperview();
        hud = nil;
        self.navigationController?.popViewControllerAnimated(true);
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 48;
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ClearCacheSettingCell;
        cell.titleLable?.text = self.dataArr[indexPath.row];
        switch indexPath.row{
        case 0:
            cell.detailTitleLabel?.text = self.dataCache?.getKBorMBorGBWith(self.heroSize());
            cell.isClear = false;
            self.clearDict?.setObject(cell, forKey: "HeroCell");
            break;
        case 1:
            cell.detailTitleLabel?.text = self.dataCache?.getKBorMBorGBWith(self.equipSize());
            cell.isClear = false;
            self.clearDict?.setObject(cell, forKey: "EquipCell");
            break;
        case 2:
            cell.detailTitleLabel?.text = self.dataCache?.getKBorMBorGBWith(self.imageSize());
            cell.isClear = true;
            self.clearDict?.setObject(cell, forKey: "ImageCell");
            break;
        case 3:
            cell.detailTitleLabel?.text = self.dataCache?.getKBorMBorGBWith(self.newsSize());
            cell.isClear = false;
            self.clearDict?.setObject(cell, forKey: "NewsCell");
            break;
        default:
            break;
        }
        return cell;
    }
    
    func heroSize()->CGFloat{
        
        return CGFloat((self.dataCache?.getCacheSizeWith("Hero"))!);
        
    }
    func equipSize()->CGFloat{
        return CGFloat((self.dataCache?.getCacheSizeWith("Equip"))!)
    }
    func imageSize()->CGFloat{
        
        return CGFloat(SDImageCache.sharedImageCache().getSize());
        
    }
    func newsSize()->CGFloat{
        
        return CGFloat((self.dataCache?.getCacheSizeWith("News"))!)
    }
    func getAllCacheSizeString()->String{
        
        let allSize:CGFloat = self.newsSize() + self.imageSize() + self.equipSize() + self.heroSize();
        return (self.dataCache?.getKBorMBorGBWith(allSize))!;
        
    }

}






