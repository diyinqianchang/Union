//
//  NetworkStatus.swift
//  Union
//
//  Created by 万联 on 16/4/13.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import Foundation

enum CoreNetWorkStatus:Int{
    //未知网络
    case Unknown = 0,
    /** 无网络 */
     None,
    /** 蜂窝网络 */
     WWAN,
    /** Wifi网络 */
     Wifi,
    /** 2G网络*/
     Status2G,
    /** 3G网络 */
    Status3G,
    /** 4G网络 */
    Status4G
   
}

