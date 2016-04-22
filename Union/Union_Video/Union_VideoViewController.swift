//
//  Union_VideoViewController.swift
//  Union
//
//  Created by 万联 on 16/4/7.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class Union_VideoViewController: UIViewController {
    
    
    lazy var tabView:TabView = {
    
        let tabArr = ["分类","最新"];
        
        let tab = TabView(frame: CGRectMake(0,0,SCREEN_WIDTH,40));
        
        tab.dataArray = tabArr;
        return tab;
    
    
    }()
    
    lazy var sortView:Union_Video_SortCollectionView = {
    
        let flowLayOut = UICollectionViewFlowLayout();
        
        flowLayOut.itemSize = CGSizeMake((SCREEN_WIDTH - 50) / 4,(SCREEN_WIDTH - 50) / 4 + 20);
        flowLayOut.minimumInteritemSpacing = 10;
        flowLayOut.minimumLineSpacing = 10;
        flowLayOut.scrollDirection = .Vertical;
        flowLayOut.sectionInset = UIEdgeInsetsMake(10 , 10 , 10 , 10 );
        
        let sortCollView = Union_Video_SortCollectionView(frame: CGRectMake(0,40,SCREEN_WIDTH,SCREEN_HEIGHT - 113), collectionViewLayout: flowLayOut);
        
        return sortCollView;
     }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tabView);
        self.tabView.tabIndex_Block = {(selectIndex) -> Void in
        
            print(selectIndex)
        
        }
        self.view.addSubview(self.sortView);
        self.sortView.itemClickBlock = {(tag,name) -> Void in
        
            print("\(tag) \(name)");
        
        }
        self.sortView.sortSearchBlock = {(videoName)->Void in
            
            print(videoName);
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}

extension Union_VideoViewController{








}
