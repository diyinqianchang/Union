//
//  FeedBackViewController.swift
//  Union
//
//  Created by 万联 on 16/4/12.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit


class FeedBackViewController: UIViewController {

    var textView:UITextView?
    var wordCountLabel:UILabel?
    lazy var HUD:MBProgressHUD={
    
        let hud = MBProgressHUD(view: self.view);
        return hud;
    
    }()
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        self.navigationItem.rightBarButtonItem?.enabled = false;
        self.textView?.becomeFirstResponder();
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor();
        self.title = "意见反馈";
        self.addRightButton();
        
        self.textView = UITextView(frame: CGRectMake(5,20,SCREEN_WIDTH-10,150));
        self.textView?.textColor = UIColor.grayColor();
        self.textView?.backgroundColor = RGB(245, g: 245, b: 245);
        self.textView?.layer.borderWidth = 0.2;
        self.textView?.layer.borderColor = RGB(220, g: 220, b: 220).CGColor;
        self.textView?.layer.cornerRadius = 5;
        self.textView?.layer.masksToBounds = true;
        self.textView?.font = UIFont.boldSystemFontOfSize(16);
        self.textView?.delegate = self;
        self.textView?.returnKeyType = UIReturnKeyType.Send;
        self.view.addSubview(self.textView!);
        
        self.wordCountLabel = UILabel(frame: CGRectMake(CGRectGetWidth(self.textView!.frame) - 60,CGRectGetHeight(self.textView!.frame) - 30,60,30));
        self.wordCountLabel?.textColor = UIColor.grayColor();
        self.wordCountLabel?.text = "200";
        self.wordCountLabel?.textAlignment = .Center;
        self.textView?.addSubview(self.wordCountLabel!);
        
        self.HUD.labelText = "发送中...";
        self.HUD.delegate = self;
        self.view.addSubview(self.HUD);
        self.view.bringSubviewToFront(self.HUD);


    }
    func addRightButton(){
    
        let rightBarBtn = UIBarButtonItem(title: "完成", style:UIBarButtonItemStyle.Done , target: self, action: Selector("rightBarButtonAction:"));
        rightBarBtn.tintColor = UIColor.whiteColor();
        self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func rightBarButtonAction(btn:UIBarButtonItem){
       
        if ((self.textView?.text)! as NSString).length > 0{
        
            self.textView?.resignFirstResponder();
            self.HUD.show(true);
            let mail:SKPSMTPMessage = SKPSMTPMessage();
            mail.subject = "UnionFeedBack";
            mail.toEmail = "2591149786@qq.com";
            mail.fromEmail = "zhangguolin-1990@163.com";
            mail.relayHost = "smtp.163.com";
            mail.requiresAuth = true;
            mail.login = "zhangguolin-1990@163.com";
            mail.pass = "18825138091";
            mail.wantsSecure = true;
            mail.delegate = self;
            
            let plainPart:Dictionary = [kSKPSMTPPartContentTypeKey:"text/plain",kSKPSMTPPartMessageKey:self.textView!.text,kSKPSMTPPartContentTransferEncodingKey:"8bit"];
            mail.parts = [plainPart];
            mail.send();
        
        }
    
    }
    

    
}
extension FeedBackViewController:UITextViewDelegate,MBProgressHUDDelegate,SKPSMTPMessageDelegate{
    
    func messageFailed(message: SKPSMTPMessage!, error: NSError!) {
        
        self.HUD.customView = UIImageView(image: UIImage(named: "iconfont-guanbicuowu"));
        self.HUD.mode = MBProgressHUDMode.CustomView;
        self.HUD.labelText = "发送失败,重新发送";
        self.HUD.hide(true, afterDelay: 2.0);

        self.textView?.becomeFirstResponder();
        print(error);
    }
    func messageSent(message: SKPSMTPMessage!) {
        
        self.HUD.customView = UIImageView(image: UIImage(named: "37x-Checkmark"));
        self.HUD.mode = MBProgressHUDMode.CustomView;
        self.HUD.labelText = "发送成功,感谢您的宝意见";
        self.HUD.hide(true, afterDelay: 2.0);
        self.textView?.text = "";
        self.wordCountLabel?.text = "200";
        
        GCDQueue.executeInMainQueue({[weak self] () -> Void in
            
            self?.navigationController?.popViewControllerAnimated(true);
            
            }, afterDelaySeconds: 2.0);
        
        
    }
    
    
    func textViewDidChange(textView: UITextView) {
        self.wordCountLabel?.text = NSString(format: "%ld", 200 - (self.textView!.text as NSString).length) as String;
        
        if (textView.text as NSString).length >= 5{
        
            self.navigationItem.rightBarButtonItem?.enabled = true;
            
        }else{
          
            self.navigationItem.rightBarButtonItem?.enabled = false;
          
        }
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if (textView.text as NSString).length >= 200{
        
            return false;
          
        }
        return true;
        
    }
    

    func hudWasHidden(hud: MBProgressHUD!) {
        hud.customView = nil;
        hud.mode = MBProgressHUDMode.Indeterminate;
        hud.labelText = "发送中...";
    }



}
