//
//  LogoutBtn.m
//  iWeibo
//
//  Created by dengwei on 15/7/30.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "LogoutBtn.h"

@implementation LogoutBtn

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat x = 10;
    CGFloat y = 0;
    CGFloat width = contentRect.size.width - 2 * x;
    CGFloat height = contentRect.size.height;
    
    return CGRectMake(x, y, width, height);
}

-(void)setFrame:(CGRect)frame
{
    frame.origin.x = kButtonBorderWidth;
    frame.size.width -= 2 * kButtonBorderWidth;
    
    [super setFrame:frame];
}

@end
