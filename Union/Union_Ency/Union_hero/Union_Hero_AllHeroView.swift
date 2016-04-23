//
//  Union_Hero_AllHeroView.swift
//  Union
//
//  Created by 万联 on 16/4/22.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit


typealias HeroDetailBlock = (heroName:String) -> Void


class Union_Hero_AllHeroView: UIView {
    
    var heroDetailBlock:HeroDetailBlock?
    
    
    var filterView:FilterView?
    var searchView:UIView?
    var searchTF:UITextField?
    
    var allHeroCollView:AllHeroCollectionView?
    
    var attachVc:Union_Hero_ViewController = Union_Hero_ViewController(){
    
        willSet{
        
            if self.attachVc != newValue{
            
                self.attachVc = newValue;
            
            }
            
        }
        didSet{
        
        
        }
    
    
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.whiteColor();
        self.initFilterView();
        self.initSearchView();
        self.initAllHeroCollectionView();
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initFilterView(){
    
        let fmModel1 = FilterMenuModel()
        fmModel1.menuTitle = "英雄类型";
        fmModel1.menuDic = ["default" :["全部类型","坦克","刺客","法师","战士","射手","辅助", "新手" ]]
        
        let fmModel2 = FilterMenuModel();
        fmModel2.menuTitle = "英雄位置";
        fmModel2.menuDic = ["default" :["全部","上单","中单","ADC","打野" ]];
        
        let fmModel3 = FilterMenuModel();
        fmModel3.menuTitle = "英雄价格";
        fmModel3.menuDic = ["default" :["不限"] ,"点卷":["1000","1500","2000","2500","3000","3500","4000","4500"],"金币":["450","1350","3150","4800","6300","7800"]];
        let fmModel4 = FilterMenuModel();
        fmModel4.menuTitle = "排序";
        fmModel4.menuDic = ["default":["默认","物攻","法伤","防御","操作","金币","点劵"]];
        
        self.filterView = FilterView(frame: CGRectMake(0,40,CGRectGetWidth(self.frame),40));
        self.filterView?.dataArray = [fmModel1,fmModel2,fmModel3,fmModel4];
        self.filterView?.delegate = self;
        self.addSubview(self.filterView!);
    
    
    }
    
    func initSearchView(){
    
        self.searchView = UIView(frame: CGRectMake(0,0,CGRectGetWidth(self.frame),40));
        self.searchView?.backgroundColor = RGB(245, g: 245, b: 245);
        self.addSubview(self.searchView!);
        
        self.searchTF = UITextField(frame: CGRectMake(10,5,SCREEN_WIDTH - 20,30))
        self.searchTF?.placeholder = "搜索";
        self.searchTF?.textAlignment = .Center;
        self.searchTF?.delegate = self;
        self.searchTF?.returnKeyType = .Search;
        self.searchTF?.borderStyle = .RoundedRect;
        self.searchTF?.keyboardType = .Default;
        self.searchTF?.adjustsFontSizeToFitWidth = true;
        self.searchTF?.clearsOnBeginEditing = true;
        self.searchTF?.clearButtonMode = .Always;
        
        self.searchView?.addSubview(self.searchTF!);
    
    }
    
    func initAllHeroCollectionView(){
    
        let flowLayOut:UICollectionViewFlowLayout = UICollectionViewFlowLayout();
        flowLayOut.itemSize = CGSizeMake((CGRectGetWidth(self.frame) - 50) / 4, (CGRectGetWidth(self.frame) - 50) / 4 + 30);
        flowLayOut.minimumInteritemSpacing = 10;
        flowLayOut.minimumLineSpacing = 10;
        flowLayOut.scrollDirection = .Vertical;
        flowLayOut.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
        
        self.allHeroCollView = AllHeroCollectionView(frame: CGRectMake(0,80,CGRectGetWidth(self.frame),CGRectGetHeight(self.frame) - 80), collectionViewLayout: flowLayOut);
        self.allHeroCollView?.allHeroView_Block = {(heroName)->Void in
        
            self.heroDetailBlock!(heroName: heroName);
        
        }
        self.addSubview(self.allHeroCollView!);
    
    
    }

   

}
extension Union_Hero_AllHeroView:FilterViewDelegate,UITextFieldDelegate{


    func selectedScreeningConditions(condition: String, type: String) {
        
    
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        
        if ((self.searchTF?.text)! as NSString).length >= 10{
            
            let alertVc = UIAlertController(title: "温馨提示", message: "不能超过10个字", preferredStyle: UIAlertControllerStyle.Alert);
            let action = UIAlertAction(title: "返回", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                
            });
            alertVc.addAction(action);
            self.attachVc.presentViewController(alertVc, animated: true, completion: { () -> Void in
                
            });
//            self.searchTF?.resignFirstResponder();
//            UIView.addNotifier(text: "不能超过10个字", dismissAutomatically: true);
            return false;
        }
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    


}
