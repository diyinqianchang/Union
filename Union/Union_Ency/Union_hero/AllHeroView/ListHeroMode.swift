//
//  ListHeroMode.swift
//  Union
//
//  Created by 万联 on 16/4/23.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit

class ListHeroMode: NSObject {
    
    var cnName:String?
    var enName:String?
    var location:String?
    var price:String?
    var rating:String?
    var tags:String?
    var title:String?
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    override func valueForUndefinedKey(key: String) -> AnyObject? {
        return NSNull()
    }
    

}
