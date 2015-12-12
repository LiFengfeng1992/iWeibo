//
//  StatusCell.m
//  iWeibo
//
//  Created by dengwei on 15/8/2.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "StatusCell.h"
#import "StatusCellFrame.h"


@interface StatusCell()

@end

@implementation StatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //操作条
        CGFloat y = self.frame.size.height - kStatusDockHeight;
        _dock = [[StatusOptionDock alloc]initWithFrame:CGRectMake(0, y, 0, 0)];
        [self.contentView addSubview:_dock];
    }
    return self;
}

-(void)setCellFrame:(BaseStatusCellFrame *)cellFrame
{
    [super setCellFrame:cellFrame];
    
    //操作条
    _dock.status = cellFrame.status;
    
}

@end
