//
//  WaterFlowLayout.h
//  PhotoKitTestDemo
//
//  Created by 万联 on 15/11/4.
//  Copyright © 2015年 wl.wanlian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign)id<UICollectionViewDelegateFlowLayout>delegate;   //用于传递信息 高度，ed等


@property(nonatomic, strong)NSMutableArray *colMuArray;         //存放列的高度
@property(nonatomic, strong)NSMutableDictionary *attributes; //cell的属性

@end
