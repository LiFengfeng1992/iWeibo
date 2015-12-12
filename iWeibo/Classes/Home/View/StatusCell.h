//
//  StatusCell.h
//  iWeibo
//
//  Created by dengwei on 15/8/2.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//
//  展示一条微博

#import "BaseStatusCell.h"
#import "StatusOptionDock.h"

@interface StatusCell : BaseStatusCell

@property(nonatomic, strong)StatusOptionDock *dock; //每条微博底部操作条

@end
