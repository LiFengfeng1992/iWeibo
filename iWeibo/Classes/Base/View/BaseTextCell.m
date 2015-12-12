//
//  BaseTextCell.m
//  iWeibo
//
//  Created by dengwei on 15/8/4.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "BaseTextCell.h"
#import "IconView.h"
#import "BaseTextCellFrame.h"
#import "BaseText.h"
#import "UserModel.h"
#import "UIImage+X.h"

@interface BaseTextCell ()

@end

@implementation BaseTextCell



-(void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    //1.获得图片文件名
    int count = (int)[_myTableView numberOfRowsInSection:indexPath.section];
    NSString *bgName = @"statusdetail_comment_background_middle.png";
    NSString *selectedBgName = @"statusdetail_comment_background_middle_highlighted.png";

    if (count - 1 == indexPath.row) { //末行
        bgName = @"statusdetail_comment_background_bottom.png";
        selectedBgName = @"statusdetail_comment_background_bottom_highlighted.png";
    }
    
    //2.设置背景
    _bg.image = [UIImage resizedImage:bgName];
    _selectedBg.image = [UIImage resizedImage:selectedBgName];
}



-(void)setFrame:(CGRect)frame
{
    //XLog(@"%@", NSStringFromCGRect(frame));
    frame.origin.x = kTableBorderWidth;
    //frame.origin.y += kTableBorderWidth; //使用MJRefresh引入问题，刷新之后tableview的头部y值成立负数，显示不好
    frame.size.width -= 2 * kTableBorderWidth;
    //frame.size.height -= kCellMargin;
    
    [super setFrame:frame];
}

-(void)setCellFrame:(BaseTextCellFrame *)cellFrame
{
    _cellFrame = cellFrame;
    
    BaseText *baseText = cellFrame.baseText;
    
    //1.头像
    _icon.frame = cellFrame.iconFrame;
    _icon.user = baseText.user;
    
    // 2.昵称
    _screenName.frame = cellFrame.screenNameFrame;
    _screenName.text = baseText.user.screenName;
    
    // 3.判断是不是会员
    if (baseText.user.mbtype == kMBTypeNone) {
        _screenName.textColor = kScreenNameColor;
        _mbIcon.hidden = YES;
    } else {
        _screenName.textColor = kMBScreenNameColor;
        _mbIcon.hidden = NO;
        _mbIcon.frame = cellFrame.mbIconFrame;
    }
    
    // 4.内容
    _text.frame = cellFrame.textFrame;
    _text.text = baseText.text;
    
    // 5.时间
    _time.frame = cellFrame.timeFrame;
    _time.text = baseText.createdAt;
}

@end
