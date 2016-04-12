//
//  PictureCycleView.swift
//  Union
//
//  Created by 万联 on 16/4/12.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

typealias PictureCycle_SelectedPicBlock = (model:PictureCycleModel)->Void

class PictureCycleView: UIView {
    
    
    var dataArray:NSMutableArray?
    var timeInterval:NSTimeInterval?
    var isPicturePlay:Bool?
    override init(frame: CGRect) {
        super.init(frame: frame);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    

}
