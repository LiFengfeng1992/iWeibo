//
//  TitleButton.m
//  iWeibo
//
//  Created by dengwei on 15/12/17.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "TitleButton.h"
#import "UIImage+X.h"

#define kNavgationBarTitleFont [UIFont boldSystemFontOfSize:14]

@implementation TitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.adjustsImageWhenHighlighted = NO;
        
        self.titleLabel.font = kNavgationBarTitleFont;
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
        
        [self setBackgroundImage:[UIImage resizableWithImageName:@"navigationbar_filter_background_highlighted"] forState:UIControlStateHighlighted];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.x = self.imageView.x;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame)+5;
    
}

- (void)setFrame:(CGRect)frame
{
    frame.size.width += 2;
    [super setFrame:frame];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    
    [self sizeToFit];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    // 自动算好尺寸
    [self sizeToFit];
}

@end
