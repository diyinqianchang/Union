//
//  Union_News_DetailViewController.swift
//  Union
//
//  Created by 万联 on 16/4/13.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class Union_News_DetailViewController: UIViewController {

    
    var type:String {
        willSet{
            if self.type != newValue{
                print(newValue);
                self.type = newValue;
            }
        }
        didSet{
        
         
        }
    
    }
    var urlString:String{
        willSet{
            if self.urlString != newValue {self.urlString = newValue}
        }
        didSet{
           
            self.loadData();
        }
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.type = String();
        self.urlString = String()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        
       
    
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    lazy var webView:UIWebView = {
        
        let webView = UIWebView(frame: CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - 64));
        webView.scalesPageToFit = false;
        webView.dataDetectorTypes = .All;
        webView.delegate = self;
        return webView
    }()
    var htmlTitle:String?
    var htmlStr:String?
    
    lazy var loadingView:LoadingView = {
        
        let loadView:LoadingView = LoadingView(frame: CGRectMake(0,0,CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame) - 64));
        
        loadView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.0);
        loadView.loadingColor = MAINCOLOR;
//        loadView.viewHidden = true;
        loadView.hidden = true;
        return loadView;
    
    }();
    lazy var reloadImageView:UIImageView = {
       
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("reloadImageViewTapAction:"));
        
        let imageV:UIImageView = UIImageView(frame: CGRectMake(0,0,200,200));
        imageV.center = CGPointMake(SCREEN_WIDTH / 2,(SCREEN_HEIGHT - 64) / 2);
        imageV.image = UIImage(named: "reloadImage")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate);
        imageV.tintColor = UIColor.lightGrayColor();
        imageV.backgroundColor = UIColor.clearColor();
        imageV.userInteractionEnabled = true;
        imageV.hidden = true;
        imageV.addGestureRecognizer(tap);
        return imageV;
    
    }()
    
    lazy var videoListTableView:Union_VideoListTableView = {
    
        let tableView:Union_VideoListTableView = Union_VideoListTableView();
        tableView.rootVc = self;
        return tableView;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "资讯详情";
        self.addShareBarButton();

       
    }
    func addShareBarButton(){
    
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "iconfont-sharebutton"), style: UIBarButtonItemStyle.Done, target: self, action: Selector("rightBarButtonAction:"));
        rightBarButton.tintColor = UIColor.whiteColor();
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }
    func rightBarButtonAction(barBtn:UIBarButtonItem){
    
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func reloadImageViewTapAction(tap:UITapGestureRecognizer){
        self.loadData();
    }
    
    func loadData(){
        //添加数据
        self.view.addSubview(self.webView);
        self.webView.addSubview(self.loadingView);
        self.webView.bringSubviewToFront(self.loadingView);
        
        self.view.addSubview(self.reloadImageView);
        
//        self.loadingView.viewHidden = false;
        self.loadingView.hidden = false;
        
        self.reloadImageView.hidden = true;
        
        self.webView.loadHTMLString("", baseURL: NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath));
        AFNetWorkingTool.getDataFromNet(self.urlString, params: NSDictionary(), success: {[weak self] (responseObject) -> Void in
            
                if responseObject != nil{
                
                self?.JSONSerializationWithData(responseObject);
                
                    self?.reloadImageView.hidden = true;
                }else{
//                    self?.loadingView.viewHidden = true;
                    self?.loadingView.hidden = true;
                    self?.reloadImageView.hidden = false;
                }
            
            
            }) {[weak self] (error) -> Void in
            
                self?.reloadImageView.hidden = false;
//                self?.loadingView.viewHidden = true; //重写hidden的get set方法
                self?.loadingView.hidden = true;
        }
    
    }
    
    func JSONSerializationWithData(data:AnyObject?){
        
//           self.loadingView.viewHidden = true;
        self.loadingView.hidden = true;
        
        if data != nil{
            do{
                let dict:NSDictionary = data as! NSDictionary
                self.htmlStr = (dict.valueForKey("data") as! NSDictionary).valueForKey("content") as? String;
                self.htmlTitle = (dict.valueForKey("data") as! NSDictionary).valueForKey("title") as? String;
                self.webView.loadHTMLString(self.htmlStr!, baseURL: NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath));
            }
        }
    
    }
    

    
}
extension Union_News_DetailViewController:UIWebViewDelegate{

    func webViewDidStartLoad(webView: UIWebView) {
        
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        
//        self.loadingView.viewHidden = true;
    }
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if request.URL!.isEqual(NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath)){
            return true;
        }else{
            
            let urlStr = request.URL?.absoluteString;
            
            if self.type != String() {
                if self.type == "video"{
                    self.webViewVideoWithUrl(urlStr!);
                }else if self.type == "news"{
                   UIApplication.sharedApplication().openURL(request.URL!)
                   
                    return false;
                }
            }else{
                UIApplication.sharedApplication().openURL(request.URL!);
                return false;
            }
        
        }
        
        return false;
    }
    func webViewVideoWithUrl(var urlString:String){
    
        if urlString.hasPrefix("http://box.dwstatic.com/unsupport"){
        
            
            var vid:String?
            var type:String?
            
            urlString = (urlString as NSString).stringByReplacingOccurrencesOfString("http://box.dwstatic.com/unsupport", withString: "");
            let range = (urlString as NSString).rangeOfString("?");
            urlString = (urlString as NSString).substringFromIndex(range.location + range.length);
            
            let tempArray = urlString.componentsSeparatedByString("&");
            
            for (_,item) in tempArray.enumerate(){
            
                if item.hasPrefix("vid="){
                    vid = (item as NSString).substringFromIndex(4);
                }
                if item.hasPrefix("lolboxAction="){
                    type = (item as NSString).substringFromIndex(13);
                }
            
            }
            
            if vid != nil && type != nil{
            
                if type == "videoPlay"{
                
                    self.videoListTableView.netWorkingGetVideoDetails(vid: vid!, title: self.htmlTitle!);
                    
                }else if type == "videoDownLoad"{
                
                
                }
            
            }
        
        }
    
    }


}







