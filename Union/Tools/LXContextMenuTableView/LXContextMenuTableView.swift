//
//  LXContextMenuTableView.swift
//  Union
//
//  Created by 万联 on 16/4/23.
//  Copyright © 2016年 wl.wanlian. All rights reserved.
//

import UIKit



let defaultDuration:CGFloat = 0.3;

let defaultViewAnchorPoint =  CGPointMake(0.5, 0.5);

let menuCellIdentifier = "rotationCell";

enum Direction:NSInteger{

   case right,top,botton
}
enum AnimatingState:NSInteger{

    case Hiding = -1,Stable,Showing

}

typealias completionBlock = (completion:Bool) -> Void


@objc protocol LXContextMenuTableViewDelegate:NSObjectProtocol{

    optional  func contextMenuTableView(contextTableView:LXContextMenuTableView,indexPath:NSIndexPath);
}
class LXContextMenuTableView: UITableView {

    var menuTitles:NSArray?
    var menuIcons:NSArray?
    weak var LXDelegate:LXContextMenuTableViewDelegate?
    var animationDuration:CGFloat?
    
    
    var animatingIndex:NSInteger?
    var topCells:NSMutableArray = NSMutableArray()
    var bottomCells:NSMutableArray = NSMutableArray()
    var animatingState:AnimatingState?
    var dismissalIndexPath:NSIndexPath?
    
    
    init(){
        super.init(frame: CGRectZero, style: UITableViewStyle.Plain);
        self.delegate = self;
        self.dataSource = self;
        self.animatingState = AnimatingState.Stable;
        self.animationDuration = defaultDuration;
        self.animatingIndex = 0;
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7);
        self.separatorColor = RGB(181, g: 181, b: 181);
        self.tableFooterView = UIView();
        
        let cellNib:UINib = UINib(nibName: "ContextMenuCell", bundle: nil);
        self.registerClass(cellNib.classForCoder, forCellReuseIdentifier: menuCellIdentifier);
    
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func showInView(superView superView:UIView,edgeInsets:UIEdgeInsets,animated:Bool){
    
        if self.animatingState != AnimatingState.Stable{
        
            return
        }
        
        for (_,cell) in self.visibleCells.enumerate(){
        
            cell.contentView.hidden = true;
        }
//        self.dismissalIndexPath = nil;
        
        superView.addSubView(self, insets: edgeInsets);
        if animated{
        
            self.animatingState = AnimatingState.Showing;
            self.alpha = 0.0;
            self.userInteractionEnabled = false;
            UIView.animateWithDuration(Double(self.animationDuration!), animations: { () -> Void in
                self.alpha = 1.0
                }, completion: { (finished) -> Void in
                    
                    self.show(true, animated: true);
                    self.userInteractionEnabled = true;
                    
            })
            
        
        
        }else{
        
            self.show(true, animated: false)
        
        }
       
    
    }
    
   private func show(show:Bool,animated:Bool){
    
        let visibleCells = self.visibleCells;
        
        if visibleCells.count == 0 || self.animatingIndex == visibleCells.count{
        
            self.animatingIndex = 0;
            self.userInteractionEnabled = true;
            self.reloadData();
            self.animatingState = AnimatingState.Stable;
            return;
        }
  
       let visibleCell:ContextMenuCell? = visibleCells[self.animatingIndex!] as! ContextMenuCell
    
        if visibleCell != nil{
            
            
        
        
        }
    
    
    
    
    }
    
    
   

}
extension LXContextMenuTableView:UITableViewDataSource,UITableViewDelegate{

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 66;
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuTitles!.count;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(menuCellIdentifier, forIndexPath: indexPath) as! ContextMenuCell;
        cell.menuTitleLabel.text = self.menuTitles?.objectAtIndex(indexPath.row) as? String;
        cell.menuImageView.image = self.menuIcons?.objectAtIndex(indexPath.row) as? UIImage;
        return cell;
    }

    
    //MARK:动画Cells
    func prepareCellForShowAnimation(cell:LXContextMenuCell){
    
    
    
    }
    



}
