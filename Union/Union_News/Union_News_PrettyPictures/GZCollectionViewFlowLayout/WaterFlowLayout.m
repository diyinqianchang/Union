//
//  WaterFlowLayout.m
//  PhotoKitTestDemo
//
//  Created by 万联 on 15/11/4.
//  Copyright © 2015年 wl.wanlian. All rights reserved.
//

#import "WaterFlowLayout.h"

//static const NSInteger KColumnCount =2;
//static const float KInterIntemSpacing= 10.0f;
//static const float KLineSpacing = 10.0f;
//
//#define  KScreenWidth [UIScreen mainScreen].bounds.size.width
//#define  KItemWidth (KScreenWidth-(KColumnCount-1)*KInterItemSpacing)/KColumnCount


#define  KColumnCount 2
#define  KScreenWidth [UIScreen mainScreen].bounds.size.width
#define  KInterItemSpacing 10.0f
#define  KLineSpacing 10.0f
#define  KItemWidth (KScreenWidth - (KColumnCount-1)*KInterItemSpacing)/2.0
@implementation WaterFlowLayout

-(instancetype)init{

   self=[super init];
    if (self) {
        
    }
    return self;

}



-(void)prepareLayout{
    
    [super prepareLayout];
    //初始化间距和行距
    self.minimumInteritemSpacing = KInterItemSpacing;
    self.minimumLineSpacing = KLineSpacing;
    
    self.delegate=(id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    
    
    //初始化存储容器
    _attributes = [NSMutableDictionary dictionary];  //存放cell的位置信息
    
    _colMuArray = [NSMutableArray arrayWithCapacity:KColumnCount];
    for (int i=0; i<KColumnCount; i++) { //列数
        [_colMuArray addObject:@(.0f)];
    }
    //遍历所有Item获取位置信息并行存储
    NSUInteger sectionCount = [self.collectionView numberOfSections];
    for (int section=0; section<sectionCount; section++) {
        NSUInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        for (int item = 0; item<itemCount; item++) {
            [self layoutItemFrameAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
        }
        NSLog(@"121212===%d===%d===%f",section,itemCount,KItemWidth);
    }
    
}


/**
 *
 * 用来设置每一个item的尺寸，然后和indexPath存储起来
 *
 */
- (void)layoutItemFrameAtIndexPath: (NSIndexPath *)indexPath{
    //随机生成size
    CGSize itemSize =[self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    //    CGSizeMake(KItemWidth, 100+arc4random()%101);
    //获取当前三列的高度中高度最低的一列
    NSUInteger smallestCol = 0;
    //    double shortHeight = 0.0;
    CGFloat lessHeight = [_colMuArray[smallestCol] doubleValue];
    
    for (int col = 1; col<_colMuArray.count; col++) {
        if ([_colMuArray[col] doubleValue]<lessHeight) {
            lessHeight = [_colMuArray[col] doubleValue];
            smallestCol = col;
        }
    }
    
    UIEdgeInsets insets = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:indexPath.row];
    NSLog(@"98===%f",insets.top);
    CGFloat x= insets.left +smallestCol *(insets.left +itemSize.width);
    CGRect frame ={x,insets.top+lessHeight,itemSize};
    
    [_attributes setValue:indexPath forKey:NSStringFromCGRect(frame)];
    //     NSLog(@"%@",_attributes);
    [_colMuArray replaceObjectAtIndex:smallestCol withObject:@(CGRectGetMaxY(frame))];
    NSLog(@"%@",_colMuArray);
    
}


/**
 *  返回所有当前可视范围内的item的布局属性
 */
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect{
    
    //获取当前所有可是Item和indexPath。 通过调用父类获取布局实行数组会缺失
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSString *rectStr in _attributes) {
        CGRect cellRect = CGRectFromString(rectStr);
        if (CGRectIntersectsRect(cellRect, rect)) {
            NSIndexPath *indexPath = _attributes[rectStr];
            [indexPaths addObject:indexPath];
        }
    }
    //获取当前要显示所有item的布局属性
    NSMutableArray *layoutAttributes= [NSMutableArray arrayWithCapacity:indexPaths.count];
    [indexPaths enumerateObjectsUsingBlock: ^(NSIndexPath * indexPath, NSUInteger idx, BOOL * stop) {
        
        UICollectionViewLayoutAttributes * attributes = [self layoutAttributesForItemAtIndexPath: indexPath];
        
        [layoutAttributes addObject: attributes];
        
    }];
    //    NSLog(@"====%@",layoutAttributes);
    
    return layoutAttributes;
    
}

/**
 * 返回对应indexPath的布局属性
 */
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath: indexPath];
    
    for (NSString * frame in _attributes) {
        
        if (_attributes[frame] == indexPath) {
            
            attributes.frame = CGRectFromString(frame);
            
            break;
        }
    }
    return attributes;
}

/**
 * 设置collectionView的可滚动范围（瀑布流必要实现）
 */
-(CGSize)collectionViewContentSize{
    __block CGFloat maxHeight = [_colMuArray[0] floatValue];
    [_colMuArray enumerateObjectsUsingBlock:^(NSNumber *height, NSUInteger idx, BOOL *  stop) {
        if (height.floatValue>maxHeight) {
            maxHeight =height.floatValue;
        }
    }];
    CGSize size = CGSizeMake(CGRectGetWidth(self.collectionView.frame), maxHeight+self.collectionView.contentInset.bottom);
    NSLog(@"54545===%f,%f",size.width,size.height);
    return size;
}
/**
 * 在collectionView的bounds发生改变的时候刷新布局
 */
-(BOOL)shouldInvalidateLayoutForBoundsChange: (CGRect)newBounds{
    
    return !CGRectEqualToRect(self.collectionView.bounds, newBounds);
}







@end
