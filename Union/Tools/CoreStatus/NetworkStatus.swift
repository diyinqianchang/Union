//
//  NetworkStatus.swift
//  Union
//
//  Created by 万联 on 16/4/13.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import Foundation

enum CoreNetWorkStatus:Int {
    //未知网络
    case CoreNetWorkStatusUnknown = -1,
    /** 无网络 */
     CoreNetWorkStatusNone = 0,
    /** 蜂窝网络 */
     CoreNetWorkStatusWWAN = 1,
    /** Wifi网络 */
     CoreNetWorkStatusWifi = 2
   
}

enum CoreNetWorkStatusWWAN:Int{

    /** 2G网络 */
   case CoreNetWorkStatus2G = 3,
    /** 3G网络 */
    CoreNetWorkStatus3G,
    /** 4G网络 */
    CoreNetWorkStatus4G

}