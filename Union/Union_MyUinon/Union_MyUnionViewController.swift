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
        
        
        
            self.myTableView = UITableView(frame: CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - 113), style: .Grouped);
            self.myTableView?.backgroundColor = RGB(245, g: 245, b: 245);
            self.myTableView?.registerClass(MyUnion_TableViewCell.classForCoder(), forCellReuseIdentifier: "cell");
            self.myTableView?.delegate = self;
            self.myTableView?.dataSource = self;
            
        
             self.view.addSubview(self.myTableView!);
        
            print(self.dictArr);

       
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath);
        
        
        return cell;
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


}
