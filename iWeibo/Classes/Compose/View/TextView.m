//
//  TextView.m
//  iWeibo
//
//  Created by dengwei on 15/8/9.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "TextView.h"

@interface TextView ()

@property (nonatomic, weak) UILabel *placeTextLabel;

@end

@implementation TextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.font = [UIFont systemFontOfSize:15];
        
    }
    return self;
}

- (void)setHidePlaceHolder:(BOOL)hidePlaceHolder
{
    _hidePlaceHolder = hidePlaceHolder;
    
    self.placeTextLabel.hidden = hidePlaceHolder;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UILabel *)placeTextLabel
{
    if (_placeTextLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        _placeTextLabel = label;
        [self addSubview:label];
    }
    return _placeTextLabel;
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = [placeHolder copy];
    
    
    self.placeTextLabel.text = placeHolder;
    [self.placeTextLabel sizeToFit];
    self.placeTextLabel.x = 5;
    self.placeTextLabel.y = 8;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeTextLabel.font = font;
    
}

@end
