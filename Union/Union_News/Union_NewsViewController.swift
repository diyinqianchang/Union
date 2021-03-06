//
//  Union_NewsViewController.swift
//  Union
//
//  Created by 万联 on 16/4/7.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class Union_NewsViewController: UIViewController {

    var tabView:TabView = {
    
        let tabArray = ["头条","视频","赛事","靓照","囧图","壁纸"];
        
        let tabView = TabView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 40));
        tabView.dataArray = tabArray;
        return tabView;
    
    }();
    var mainScrollView:UIScrollView = {
    
        let scrollView = UIScrollView(frame: CGRectMake(0,40,SCREEN_WIDTH,SCREEN_HEIGHT-153));
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 6.0,SCREEN_HEIGHT-153);
        scrollView.pagingEnabled = true;
        scrollView.directionalLockEnabled = true;
        scrollView.showsHorizontalScrollIndicator = false;
        return scrollView;
    
    }();
    var newsTopTableView:Union_News_TableView_View?  //头条
    
    var prettyCharmingPicturesView:Union_News_PrettyPictures_View? //靓照
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.addSubview(self.tabView);
        self.tabView.tabIndex_Block = ({[weak self](selectIndex:NSInteger)->Void in
        
            let se = selectIndex;
            self!.switchViewBySelectIndex(se);
            
        });
        self.loadAllViews();

        
    }
    /**
        切换视图
     
     - parameter selectIndex: 编号
     */
    func switchViewBySelectIndex(selectIndex:NSInteger){
    
        self.mainScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.mainScrollView.frame) * CGFloat(selectIndex), 0);
    
    }
    func loadAllViews() {
        //头条
        self.view.addSubview(self.mainScrollView);
        self.mainScrollView.delegate = self;
        self.loadNewsTableViews();
        self.loadPicturesViews()
    
    }
    
    func loadPicturesViews(){
        
       
      
        do{  //靓图
            
            
            
             let picturesVc = Union_News_Pictures_Scroll_ViewController();
              picturesVc.hidesBottomBarWhenPushed = true;
            
            self.prettyCharmingPicturesView = Union_News_PrettyPictures_View(frame: CGRectMake(CGRectGetWidth(self.mainScrollView.frame) * 3,0,CGRectGetWidth(self.mainScrollView.frame),CGRectGetHeight(self.mainScrollView.frame)));
            self.prettyCharmingPicturesView?.urlString = NSString(format: News_PrettyPicturesURL, "beautifulWoman","%ld") as String;
            self.prettyCharmingPicturesView?.prettyPictures_View_Block = {[weak self](galleryId)->Void in
                
               
                print(NSString(format: "%@%@", News_PicturesURL,galleryId) as String);
                picturesVc.picturesString = News_PicturesURL + galleryId //NSString(format: "%@%@", News_PicturesURL,galleryId) as String
                print(picturesVc.picturesString)
                
//                self?.navigationController?.pushViewController(picturesVc, animated: true);
                
                self?.presentViewController(picturesVc, animated: true, completion: { () -> Void in
                
                });
            
            }
            
            self.mainScrollView.addSubview(self.prettyCharmingPicturesView!);
            
        
        }
        
    
    
    
    
    
    }
    
    func loadNewsTableViews(){
    
        do{  //头条
            
            let detailVc:Union_News_DetailViewController = Union_News_DetailViewController();
            detailVc.hidesBottomBarWhenPushed = true;
            
            
            self.newsTopTableView = Union_News_TableView_View(frame: CGRectMake(0,0,CGRectGetWidth(self.mainScrollView.frame),CGRectGetHeight(self.mainScrollView.frame)));
            self.newsTopTableView?.scrollPage = 0;
            self.newsTopTableView?.detailBlock = {[weak self](string:String,type:String) -> Void in
            
               
                detailVc.urlString = News_WebViewURl + string; 
                detailVc.type = type;
                self?.navigationController?.pushViewController(detailVc, animated: true);
            
            }
            self.newsTopTableView?.topicBlock = {(string:String,type:String) -> Void in
            
                
                print("\(string)hehe\(type)");
            
            }
            self.newsTopTableView?.urlString = NSString(format: kNews_ListURL as NSString, "headlineNews","%ld") as String;
            self.mainScrollView.addSubview(self.newsTopTableView!);
        }
       
    
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

    
}
extension Union_NewsViewController:UIScrollViewDelegate{

 
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width);
        print("page === \(page)");
        self.tabView.selectIndex = page;
        
        
    }




}
