//
//  StatusCellFrame.m
//  iWeibo
//
//  Created by dengwei on 15/8/2.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "StatusCellFrame.h"
#import "StatusModel.h"
#import "UserModel.h"
#import "IconView.h"
#import "ImageListView.h"

@implementation StatusCellFrame

-(void)setStatus:(StatusModel *)status
{
    [super setStatus:status];
    
    _cellHeight +=  kStatusDockHeight;
}

@end
