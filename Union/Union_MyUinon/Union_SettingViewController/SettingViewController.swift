//
//  SettingViewController.swift
//  Union
//
//  Created by 万联 on 16/4/11.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    var mainTableView:UITableView?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置";
        self.mainTableView = UITableView(frame: self.view.frame, style: .Grouped);
        self.mainTableView?.delegate = self;
        self.mainTableView?.dataSource = self;
        self.mainTableView?.registerClass(SettingViewCell.classForCoder(), forCellReuseIdentifier: "cell");
        self.view.addSubview(self.mainTableView!);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    

    

}
extension SettingViewController:UITableViewDelegate,UITableViewDataSource{

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 3;
        }else{
            return 1;
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 48;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SettingViewCell;
        switch(indexPath.section){
        case 0:
            do{
                switch(indexPath.row){
                case 0:
                    do{
                        cell.titleLabel?.text = "消息推送";
                    }
                    break;
                case 1:
                    do{
                        cell.titleLabel?.text = "省流量";
                        cell.detailLabel?.text = "资讯图片自动加载设置";
                    }
                    break;
                case 2:
                    do{
                        cell.titleLabel?.text = "清除缓存"; //cell.detailLabel.
                    }
                    break;
                default:
                    break;
                }
                cell.style = SettingCellStyle.SettingCellStyleLabel;
            }
            break;
        case 1:
            do{
                cell.titleLabel?.text = "隐藏缓存气泡";
                cell.style = SettingCellStyle.SettingCellStyleSwitch;
                let defaults = NSUserDefaults.standardUserDefaults();
                if defaults.objectForKey("settingDownloadviewHiddenOrShow") != nil{
                    let str = defaults.objectForKey("settingDownloadviewHiddenOrShow")!
                    print(str);
                    cell.isOpen = (defaults.objectForKey("settingDownloadviewHiddenOrShow")?.boolValue)!
                }
                cell.selectionStyle = .None;
            }
            break;
        default:
            break;
        
        }
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
        
        if indexPath.section == 0{
            switch(indexPath.row){
            case 0:
                do{
                
                }
                break;
            case 1:
                do{
                    let saveImgLoadVc:SaveFlowSettingViewController = SaveFlowSettingViewController();
                    self.navigationController?.pushViewController(saveImgLoadVc, animated: true);
                }
                break;
            case 2:
                do{
                    let clearCacheVc = ClearCacheSettingViewController();
                    self.navigationController?.pushViewController(clearCacheVc, animated: true);
                }
                break;
            default:
                break;
            }
        }
    }
}
