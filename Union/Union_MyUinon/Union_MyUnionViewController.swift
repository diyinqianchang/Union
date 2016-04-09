//
//  Union_MyUnionViewController.swift
//  Union
//
//  Created by 万联 on 16/4/7.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class Union_MyUnionViewController: UIViewController {

    
    
    
    var myTableView:UITableView?
    lazy var dictArr:NSDictionary={
    
        let dictArr = ["1":["召唤师列表",""],"2":["设置",""],
            "3":[["常见问题",""],["意见反馈",""],
                ["评分",""],["关于",""]]]
        return dictArr;
    }();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let model = SummonerModel();
//        
//        let manager = SummonerDataBaseManager.sharedInstance;
//        
//        manager.getModelProperties(model);
        
        
            self.myTableView = UITableView(frame: CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - 113), style: .Grouped);
            self.myTableView?.backgroundColor = RGB(245, g: 245, b: 245);
            self.myTableView?.registerClass(MyUnion_TableViewCell.classForCoder(), forCellReuseIdentifier: "cell");
            self.myTableView?.registerClass(MyUnion_UserTableViewCell.classForCoder(), forCellReuseIdentifier:"Cell");
            self.myTableView?.delegate = self;
            self.myTableView?.dataSource = self;
            self.view.addSubview(self.myTableView!);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
//类的扩展
extension Union_MyUnionViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4;
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch(section){
        
            case 0:
                
                return 1;
//                break;
            case 1:
                return 1;
//                break;
            case 2:
                return 1;
//                break;
            case 3:
                return 4;
//                break;
            default:
                return 0 ;
//                break;
        
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
        
            let Cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MyUnion_UserTableViewCell ;
            
            return Cell;
        
        
        }else{
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MyUnion_TableViewCell;
    
            let index = NSString(format: "%ld", indexPath.section);
        
            let dataArr = self.dictArr[index];
            
            if indexPath.section != 3{
                
                cell.titleLabel?.text = dataArr![0] as? String;
                
            }else{
            
                let section3Data = dataArr![indexPath.row] as! Array<String>;
                
                cell.titleLabel?.text = section3Data[0]
                
                if indexPath.row == 3{
                
                    let defaults = NSBundle.mainBundle().infoDictionary;
                    
                    let version = defaults!["CFBundleShortVersionString"] as! String;
                    
                    cell.detailTitleLabel?.text = "V" + version;
                
                }
            
            }
            cell.accessoryType = .DisclosureIndicator;
            return cell;
        
        }
    }
    
//    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return UIView();
//    }
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIView();
//    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0{
        
            return 0.001;
        }else{
        
            return 5;
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
        
            return 90;
        }else{
        
            return 48;
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
        
        
    }


}
