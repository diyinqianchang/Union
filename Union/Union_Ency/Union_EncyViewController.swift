//
//  Union_EncyViewController.swift
//  Union
//
//  Created by 万联 on 16/4/7.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class Union_EncyViewController: UIViewController {

    lazy var mainScrollView:UIScrollView = {
    
        let scrollView = UIScrollView(frame: CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - 113));
    
        return scrollView;
    
    
    }()
    var dataArray:NSMutableArray = NSMutableArray()
    var itemViewArray:NSMutableArray = NSMutableArray()
    var pictureArray:NSMutableArray = NSMutableArray()
    
   
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("pictureDataArray"), name: "PictureDataArray", object: nil);
        
        
    }
    deinit{
    
//        NSNotificationCenter.defaultCenter().removeObserver(self);
    
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.mainScrollView);
        
        self.loadMenuData();
        
    }
    
    func loadMenuData(){
    
        let nameArr = ["英雄","装备","天赋","符文","最佳阵容","召唤师技能"];
        
        let iconArr = ["ency_demaxiya","ency_nuokesasi","ency_aiouniya",
                        "ency_zhanzhengxueyuan","ency_bierjiwote","ency_zuoen"];
        
        for i in nameArr.indices{
        
            let encyModel = EncyModel(name: nameArr[i], iconName: iconArr[i]);
            
            let encyModel1 = EncyModel1(name:nameArr[i],iconName:iconArr[i]);
            
            print(encyModel1.name);
            
            self.dataArray.addObject(encyModel);
        
        }
        self.loadItemView();
        
    
    }
    
    func loadItemView(){
    
        let itemWidth = SCREEN_WIDTH / 3.0;
        
        var x:CGFloat = 0.0;
        var y:CGFloat = 0.0;
        
        for(index,encyModel) in self.dataArray.enumerate(){
        
            let model:EncyModel = encyModel as! EncyModel
            
            let tap = UITapGestureRecognizer(target: self, action: Selector("encyItemAction:"));
            
            let itemView = EncyItemView(frame: CGRectMake(x, y, itemWidth, itemWidth));
            itemView.model = model;
            itemView.addGestureRecognizer(tap);
            self.mainScrollView.addSubview(itemView);
            self.itemViewArray.addObject(itemView);
           
            if index % 2 != 0{
            
                itemView.backgroundColor = RGB(246, g: 246, b: 246);
            
            }
            if index == 0{
            
                itemView.frame = CGRectMake(x, y, itemWidth * 2, itemWidth * 2);
                x += itemWidth * 2;
            
            }else if index == 1{
            
                y += itemWidth
            
            }else{
            
                if index % 3 == 2{
                
                    x = 0; y += itemWidth;
                
                }else{
                
                    x += itemWidth;
                
                }
            }
        }
        
        self.mainScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.mainScrollView.frame), y);
    }
    
    func encyItemAction(tap:UITapGestureRecognizer){
    
        
        let imgV = (tap.view as! EncyItemView).imageView;
        
        
        let center = imgV!.center;
        let size = imgV!.frame.size;
        
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            
            imgV?.frame.size = CGSizeMake((size.width) / 2.0,(size.height) / 2.0)
            imgV?.center = center
            
            }) { (finished) -> Void in
                
                UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    
                    imgV?.frame.size = size
                    imgV?.center = center
                    
                    }, completion: {[weak self] (finished) -> Void in
                        
                        self?.toDetailVc(tap.view as! EncyItemView)
                        
                        
                })
        }
    }
    
    func toDetailVc(view:EncyItemView){
    
    
        switch (self.itemViewArray.indexOfObject(view)){
        
        case 0:
            
            let heroVc = Union_Hero_ViewController();
            heroVc.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(heroVc, animated: true);
            
            break;
        default:
            break;
        
        
        }
    
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
extension Union_EncyViewController{




}