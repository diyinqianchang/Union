//
//  SaveFlowSettingViewController.swift
//  Union
//
//  Created by 万联 on 16/4/20.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class SaveFlowSettingViewController: UIViewController {
    
    
    var dataArray:Array<String>?
    var mainTableView:UITableView?
    var confirmBtn:UIButton?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "图片自动加载设置";
        
        self.dataArray = ["所有网络","仅WiFi网络","关闭图片加载"];
        
        self.mainTableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Plain);
        self.mainTableView?.delegate = self;
        self.mainTableView?.dataSource = self;
        self.mainTableView?.registerClass(SaveFlowSettingCell.classForCoder(), forCellReuseIdentifier: "cell");
        self.view.addSubview(self.mainTableView!);
        

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
extension SaveFlowSettingViewController:UITableViewDelegate,UITableViewDataSource{

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SaveFlowSettingCell;
        
        cell.titleStr = self.dataArray![indexPath.row];
        
        let defaults =  NSUserDefaults.standardUserDefaults();
        
        let value:NSNumber? = defaults.objectForKey("setting_saveflow_selectedindexpath") as! NSNumber?;
        
        if value != nil{
        
            if value?.integerValue == indexPath.row{
                cell.isClicked = true;
            }else{
                cell.isClicked = false;
            }
        }else{
        
            if indexPath.row == 0{
            
                cell.isClicked = true;
            
            }else{
            
                cell.isClicked = false;
              
            }
            
        
        }
        
        
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 48;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.dataArray?.count)!;
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        for(_,indexPathItem) in (self.mainTableView?.indexPathsForVisibleRows?.enumerate())!{
        
            let cell = tableView.cellForRowAtIndexPath(indexPathItem) as! SaveFlowSettingCell;
            
            cell.isClicked = false;
        
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SaveFlowSettingCell;
        
        cell.isClicked = true;
        
        let defaults =  NSUserDefaults.standardUserDefaults();
        
        defaults.setObject(indexPath.row, forKey: "setting_saveflow_selectedindexpath");
        
        defaults.synchronize();
        
        
    }





}
