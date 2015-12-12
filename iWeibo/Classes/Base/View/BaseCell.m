//
//  BaseCell.m
//  iWeibo
//
//  Created by dengwei on 15/8/5.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "BaseCell.h"

@interface BaseCell ()


@end

@implementation BaseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //设置背景
        [self setBackground];
    }
    
    return self;
}

-(void)setBackground
{
    UIImageView *bg = [[UIImageView alloc]init];
    
    self.backgroundView = bg;
    _bg = bg;
    
    UIImageView *selectedBg = [[UIImageView alloc]init];
    self.selectedBackgroundView = selectedBg;
    _selectedBg = selectedBg;
}

@end
