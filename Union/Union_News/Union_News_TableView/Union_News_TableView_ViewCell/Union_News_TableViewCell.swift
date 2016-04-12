//
//  Union_News_TableViewCell.swift
//  Union
//
//  Created by 万联 on 16/4/8.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class Union_News_TableViewCell: UITableViewCell {
    
    var photoImageView:UIImageView?;
    var titleLabel:UILabel?;
    var contentLabel:UILabel?
    var timeLabel:UILabel?;
    var readCountLabel:UILabel?;
    var readWordLabel:UILabel?;
    var photoVideoLabel:UILabel?;
    var whiteView:UIView?;
    
    var model:Union_News_TableView_Model?
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        do{
            self.whiteView = UIView();
            self.whiteView?.backgroundColor = UIColor.whiteColor();
            self.contentView.addSubview(self.whiteView!);
        }
        do{
            self.photoImageView = UIImageView(image: UIImage(named: "imagedefault")?.imageWithRenderingMode(.AlwaysTemplate));
            self.photoImageView?.tintColor = UIColor.lightGrayColor();
            self.whiteView?.addSubview(self.photoImageView!);
        }
        do{
            self.photoVideoLabel = UILabel();
            self.photoVideoLabel?.textColor = UIColor.whiteColor();
            self.photoVideoLabel?.font = UIFont.systemFontOfSize(12.0);
            self.photoVideoLabel?.textAlignment = .Center;
            self.photoImageView?.addSubview(self.photoVideoLabel!);
        }
        //MARK: 初始化标题
        do{
            self.titleLabel = UILabel();
            self.titleLabel?.font = UIFont.systemFontOfSize(14.0);
            self.titleLabel?.textColor = UIColor.blackColor();
            self.titleLabel?.textAlignment = .Left;
            self.whiteView?.addSubview(self.titleLabel!);
        }
        do{
            self.contentLabel = UILabel();
            self.contentLabel?.font = UIFont.systemFontOfSize(12);
            self.contentLabel?.textColor = UIColor.grayColor();
            self.contentLabel?.textAlignment = .Left;
            self.whiteView?.addSubview(self.contentLabel!);
        }
        
        do{
            self.timeLabel = UILabel();
            self.timeLabel?.font = UIFont.systemFontOfSize(12.0);
            self.timeLabel?.textColor = UIColor.lightGrayColor();
            self.timeLabel?.textAlignment = .Left;
            self.whiteView?.addSubview(self.timeLabel!);
        }

        do{
            self.readCountLabel = UILabel();
            self.readCountLabel?.font = UIFont.systemFontOfSize(12.0);
            self.readCountLabel?.textColor = UIColor.lightGrayColor();
            self.readCountLabel?.textAlignment = .Right;
            self.whiteView?.addSubview(self.readCountLabel!);
        }
    }

    
    
    override  func layoutSubviews() {
        super.layoutSubviews()
        
        let rect = self.frame;
        //白色底部
        self.whiteView?.frame = CGRectMake(10, 10, rect.size.width-20, 80-20);
        //图片
        self.photoImageView?.frame = CGRectMake(0, 0, 80, 60);
        //图片上是否显示视频
        self.photoVideoLabel?.frame = CGRectMake(CGRectGetMaxX(self.photoImageView!.frame)-27, CGRectGetMaxY(self.photoImageView!.frame)-15, 27, 15);
        //标题
        self.titleLabel?.frame = CGRectMake(90, 0, self.whiteView!.frame.size.width - self.photoImageView!.frame.size.width - 10, 16);
        
        self.contentLabel?.frame = CGRectMake(90, 16, CGRectGetWidth(self.titleLabel!.frame), CGRectGetHeight(self.contentLabel!.frame));
        
       
        //时间
        
        self.timeLabel?.frame = CGRectMake(90, CGRectGetHeight(self.whiteView!.frame)-12, CGRectGetWidth(self.titleLabel!.frame)/2.0, 14);
       
        
        //阅读人数
        self.readCountLabel?.frame = CGRectMake(self.whiteView!.frame.size.width - 80 , self.whiteView!.frame.size.height - 12  , 80, 14);
        
        
    }
    
    
    func fillCellWithModel(model:Union_News_TableView_Model){
    
        if self.model != model {
        
            self.model = model;
        
        }
    
        self.titleLabel?.text = self.model?.title?.removeSensitiveWordsWithArray(["手机盒子","手机饭盒","多玩饭盒","多玩","饭盒","盒子"]);
        if self.model?.readCount == "0" {
            self.readCountLabel?.hidden = true;
        }else{
            self.readCountLabel?.hidden = false;
            self.readCountLabel?.text = (self.model?.readCount)! + "阅读";
        }
        
        //加载图片
        
        self.photoImageView?.sd_setImageWithURL(NSURL(string: (self.model?.photo!)!), placeholderImage: UIImage(named:"imagedefault"));
    
        self.heightContentTitle((self.model?.content)!);
        
        self.judgeCellType();
        
        self.timeLabel?.text = TimeFormattor.timeTransform(self.model!.time!)
    
    
    }
    
    func heightContentTitle(var text:String){
    
        text = text.removeSensitiveWordsWithArray(["手机盒子"]);
        let height = String.getHeightWithString(text, width: CGRectGetWidth(self.titleLabel!.frame), fontSize: 12);
        
//        print("gaodu"+"\(height)");
        
        
        self.contentLabel?.frame = CGRectMake(80 + 10, 16, self.titleLabel!.frame.size.width, height > 30 ? 30 : height);
        
        //自动换行
        
        self.contentLabel?.numberOfLines = 0;
        
        self.contentLabel?.text = text;
        
        //先赋值在计算
//        let size = self.contentLabel?.sizeThatFits(CGSize(width: CGRectGetWidth(self.titleLabel!.frame),height: CGFloat.max));
//        print("errr"+"\(size!.height)")

    
    }
    
    func judgeCellType(){
    
        if self.model?.type == "topic"{
        
            self.photoVideoLabel?.text = "专题";
            self.photoVideoLabel?.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.8);
            print("cloore")
            self.photoVideoLabel?.hidden = false;
            self.readCountLabel?.hidden = true;
            self.timeLabel?.hidden = true;
            self.contentLabel?.frame = CGRectMake(80 + 10 , 20 , self.whiteView!.frame.size.width - self.photoImageView!.frame.size.width - 10 , 45);
        
        }
        if self.model?.type == "news"{
        
            self.photoVideoLabel?.hidden = true;
            self.readCountLabel?.hidden = false;
        
        }
        if self.model?.type == "video"{
        
            self.photoVideoLabel?.hidden = false;
            self.photoVideoLabel?.text = "视频";
            self.photoVideoLabel?.textColor = UIColor.whiteColor();
            self.photoVideoLabel?.backgroundColor = MAINCOLOR.colorWithAlphaComponent(0.8);
            self.readCountLabel?.hidden = false;
        
        }
    
    
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
