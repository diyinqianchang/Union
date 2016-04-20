//
//  GZCollectionViewFlowLayout.swift
//  Union
//
//  Created by 万联 on 16/4/20.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit





class GZCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
   
    weak var delegate:UICollectionViewDelegateFlowLayout?
    
    var colMuArray:NSMutableArray?
    var attributes:NSMutableDictionary?
    
    var columnCount:NSInteger = 2{
    
        willSet{
            
            if self.columnCount != newValue{
                
                self.columnCount = newValue;
                
            }
            
        }
        didSet{
            
        }

    
    }
    var interItemSpacing:CGFloat = 10.0{
    
        willSet{
        
            if self.interItemSpacing != newValue{
            
                self.interItemSpacing = newValue;
            
            }
          
        }
        didSet{
        
        }
    
    }
    var lineSpaceing:CGFloat = 10.0{
        
        willSet{
            
            if self.lineSpaceing != newValue{
                
                self.lineSpaceing = newValue;
                
            }
            
        }
        didSet{
            
        }
        
    }

    
   
    
    override init() {
        super.init();
    }
    
    override func prepareLayout() {
        super.prepareLayout();
        
        self.minimumInteritemSpacing = self.interItemSpacing;
        self.minimumLineSpacing = self.lineSpaceing;
        
        //把界面传给这里
        self.delegate = self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout;
        
        self.attributes = NSMutableDictionary();
        self.colMuArray = NSMutableArray(capacity: self.columnCount);
        
        for _ in 0...self.columnCount{
        
            self.colMuArray?.addObject(0.0);
        
        }
        
        //网格的section
        let sectionCount = self.collectionView?.numberOfSections();
        
        for section in 0...sectionCount!{
            let itemCount = self.collectionView?.numberOfItemsInSection(section);
            for item in 0...itemCount!{
                self.layoutItemFrameAtIndexPath(NSIndexPath(forItem: item, inSection: section));
            }
        }
    }
    
    func layoutItemFrameAtIndexPath(indexPath:NSIndexPath){
    
        let itemSize:CGSize? = self.delegate?.collectionView!(self.collectionView!, layout: self, sizeForItemAtIndexPath: indexPath);
        
        var smallCol = 0;
        var lessHeight = self.colMuArray![0] as! CGFloat
        
        for col in 1...self.colMuArray!.count{
            if ((self.colMuArray![col] as! CGFloat) < lessHeight) {
                lessHeight = self.colMuArray![col] as! CGFloat;
                smallCol = col;
            }
        }
        
        let insets = self.delegate?.collectionView!(self.collectionView!, layout: self, insetForSectionAtIndex: indexPath.row);
        
        let x = (insets?.left)! + CGFloat(smallCol) * ((insets?.left)! + (itemSize?.width)!);
        
        let frame:CGRect = CGRect( x: x,y: (insets?.top)! + lessHeight,width: (itemSize?.width)!,height: (itemSize?.height)!)
        
        self.colMuArray?.replaceObjectAtIndex(smallCol, withObject: CGRectGetMaxY(frame));
        
        
    
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let indexPaths:NSMutableArray = NSMutableArray();
        
        for(_,rectStr) in self.attributes!.allKeys.enumerate(){
        
            let cellRect = CGRectFromString(rectStr as! String);
            if CGRectIntersectsRect(cellRect, rect){
            
                let indexPath = self.attributes![rectStr as! String] as! NSIndexPath
                indexPaths.addObject(indexPath);
            }
        
        }
        
        //获取当前要显示所有item的布局属性
        var layoutAttributes:[UICollectionViewLayoutAttributes] = Array();
        indexPaths.enumerateObjectsUsingBlock { (indexPath, idx, stop) -> Void in
            
            let attributes = self.layoutAttributesForItemAtIndexPath(indexPath as! NSIndexPath);
            
            layoutAttributes.append(attributes!)
            
            
        }
        return layoutAttributes
        
        
        
        
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath);
        for (_,frame) in self.attributes!.allKeys.enumerate(){
        
            attributes.frame = CGRectFromString(frame as! String);
            break;
        
        }
        return attributes;
        
    }
    
    
    override func collectionViewContentSize() -> CGSize {
        
        var maxHeight = self.colMuArray![0].floatValue;
        
        self.colMuArray?.enumerateObjectsUsingBlock({ (height, idx, stop) -> Void in
            
            if height as! Float > maxHeight{
            
                maxHeight = height.floatValue
            
            }
            
        })
        let size:CGSize = CGSizeMake(CGRectGetWidth(self.collectionView!.frame),  CGFloat(maxHeight) + self.collectionView!.contentInset.bottom);
        
        return size;
        
    }

    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        
        return !CGRectEqualToRect(self.collectionView!.bounds, newBounds);
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    

}
