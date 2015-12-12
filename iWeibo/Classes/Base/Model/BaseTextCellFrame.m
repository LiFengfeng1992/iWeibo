//
//  BaseTextCellFrame.m
//  iWeibo
//
//  Created by dengwei on 15/8/4.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "BaseTextCellFrame.h"
#import "IconView.h"
#import "BaseText.h"
#import "UserModel.h"

@implementation BaseTextCellFrame

-(void)setBaseText:(BaseText *)baseText
{
    _baseText = baseText;
    
    // 整个cell的宽度,需要剪掉两边的间距（2 * kTableBorderWidth）
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width - 2 * kTableBorderWidth;
    
    // 1.头像
    CGFloat iconX = kCellBorderWidth;
    CGFloat iconY = kCellBorderWidth;
    CGSize iconSize = [IconView iconSizeWithType:kIconTypeSmall];
    _iconFrame = CGRectMake(iconX, iconY, iconSize.width, iconSize.height);
    //_iconFrame = CGRectMake(iconX, iconY, kIconSmallW + kVertifyW * 0.5, kIconSmallH + kVertifyH * 0.5);
    
    // 2.昵称
    CGFloat screenNameX = CGRectGetMaxX(_iconFrame) + kCellBorderWidth;
    CGFloat screenNameY = iconY;
    //CGSize screenNameSize = [status.user.screenName sizeWithFont:kScreenNameFont];
    CGSize screenNameSize = X_TEXTSIZE(baseText.user.screenName, kScreenNameFont);
    _screenNameFrame = (CGRect){{screenNameX, screenNameY}, screenNameSize};
    
    // 会员图标
    if (baseText.user.mbtype != kMBTypeNone) {
        CGFloat mbIconX = CGRectGetMaxX(_screenNameFrame) + kCellBorderWidth;
        CGFloat mbIconY = screenNameY + (screenNameSize.height - kMBIconH) * 0.5;
        _mbIconFrame = CGRectMake(mbIconX, mbIconY, kMBIconW, kMBIconH);
    }
    
    // 3.内容
    CGFloat textX = screenNameX;
    CGFloat textY = CGRectGetMaxY(_screenNameFrame) + kCellBorderWidth;
    CGFloat textWidth = cellWidth - kCellBorderWidth - textX;
    CGSize textSize = [baseText.text sizeWithFont:kTextFont constrainedToSize:CGSizeMake(textWidth, MAXFLOAT)];
    _textFrame = (CGRect){{textX, textY}, textSize};
    
    // 4.时间
    CGFloat timeX = textX;
    CGFloat timeY = CGRectGetMaxY(_textFrame) + kCellBorderWidth;
    CGSize timeSize = CGSizeMake(textWidth, kTimeFont.lineHeight);
    _timeFrame = (CGRect){{timeX, timeY}, timeSize};
    
//    // 3.时间
//    CGFloat timeX = screenNameX;
//    CGFloat timeY = CGRectGetMaxY(_screenNameFrame) + kCellBorderWidth;
//    //CGSize timeSize = [status.createdAt sizeWithFont:kTimeFont];
//    CGSize timeSize = X_TEXTSIZE(baseText.createdAt, kTimeFont);
//    _timeFrame = (CGRect){{timeX, timeY}, timeSize};
//    
//    // 4.内容
//    CGFloat textX = iconX;
//    CGFloat maxY = MAX(CGRectGetMaxY(_timeFrame), CGRectGetMaxY(_iconFrame));
//    CGFloat textY = maxY + kCellBorderWidth;
//    CGSize textSize = [baseText.text sizeWithFont:kTextFont constrainedToSize:CGSizeMake(cellWidth - 2 * kCellBorderWidth, MAXFLOAT)];
//    _textFrame = (CGRect){{textX, textY}, textSize};
    
    //5.cell的高度
    _cellHeight = CGRectGetMaxY(_timeFrame) + kCellBorderWidth;
}

@end
