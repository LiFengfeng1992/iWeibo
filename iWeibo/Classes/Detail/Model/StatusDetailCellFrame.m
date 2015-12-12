//
//  StatusDetailCellFrame.m
//  iWeibo
//
//  Created by dengwei on 15/8/3.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "StatusDetailCellFrame.h"
#import "StatusModel.h"

@implementation StatusDetailCellFrame

-(void)setStatus:(StatusModel *)status
{
    [super setStatus:status];
    
    if (status.retweetedStatus) {
        _retweetedFrame.size.height += kRetweetedDockHeight;
        _cellHeight += kRetweetedDockHeight;
    }
    
}

@end
