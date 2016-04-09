//
//  Union_SummonerModel.swift
//  Union
//
//  Created by 万联 on 16/4/9.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

@objc
class SummonerModel: NSObject {
    
    var sID:String?
    var serverName:String?
    var serverFullName:String?
    var summonerName:String?
    var level:String?
    var icon:String?
    var zdl:String?
    var tier:String?
    var rank:String?
    var tierDesc:String?
    var leaguePoints:String?
    
    override func setValue(value: AnyObject?, forKey key: String) {
        super.setValue(value, forKey: key);
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }

}
