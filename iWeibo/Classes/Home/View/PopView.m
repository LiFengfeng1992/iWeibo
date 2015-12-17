//
//  PopView.m
//  iWeibo
//
//  Created by dengwei on 15/12/17.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "PopView.h"
#import "UIImage+X.h"

#define kMarginX 5
#define kMarginY 13

@interface PopView()

@property (nonatomic, weak) UIImageView *containView;

@end

@implementation PopView

- (UIImageView *)containView
{
    if (_containView == nil) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage resizableWithImageName:@"popover_background"];
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        _containView = imageView;
    }
    return _containView;
}

+ (instancetype)popView
{
    PopView *p = [[PopView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    
    return p;
}

- (void)showInRect:(CGRect)rect
{
    self.containView.frame = rect;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)setContentView:(UIView *)contentView
{
    _contentView = contentView;
    
    [self.containView addSubview:_contentView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x = kMarginX;
    CGFloat y = kMarginY;
    CGFloat w = _containView.width - kMarginX * 2;
    CGFloat h = _containView.height - kMarginY * 2;
    
    _contentView.frame = CGRectMake(x, y, w, h);
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
    
    if ([_delegate respondsToSelector:@selector(popViewDidDismiss:)]) {
        [_delegate popViewDidDismiss:self];
    }
}

@end
