//
//  BaseTextCell.h
//  iWeibo
//
//  Created by dengwei on 15/8/4.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "BaseWordCell.h"

@class BaseTextCellFrame;

@interface BaseTextCell : BaseWordCell

@property(nonatomic, strong)BaseTextCellFrame *cellFrame;

@property(nonatomic, strong)NSIndexPath *indexPath;
@property(nonatomic, weak)UITableView *myTableView;

@end
