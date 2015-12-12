//
//  BaseStatusCell.h
//  iWeibo
//
//  Created by dengwei on 15/8/3.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "BaseWordCell.h"

@class BaseStatusCellFrame;
@interface BaseStatusCell : BaseWordCell
{
    UIImageView *_retweeted; // 被转发微博的父控件
}

@property(nonatomic, strong)BaseStatusCellFrame *cellFrame;

@end
