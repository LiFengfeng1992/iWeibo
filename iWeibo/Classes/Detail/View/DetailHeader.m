//
//  DetailHeader.m
//  iWeibo
//
//  Created by dengwei on 15/8/4.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "DetailHeader.h"
#import "StatusModel.h"

@interface DetailHeader ()
{
    UIButton *_selectedBtn;
}

@end

@implementation DetailHeader

+(instancetype)header
{
    return [[NSBundle mainBundle] loadNibNamed:@"DetailHeader" owner:nil options:nil][0];
}

#pragma mark 监听按钮点击
- (IBAction)btnClick:(UIButton *)sender {
    
    //控制状态
    _selectedBtn.enabled = YES;
    sender.enabled = NO;
    _selectedBtn = sender;
    
    //移动小三角形
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint center = _hint.center;
        center.x = sender.center.x;
        _hint.center = center;
    }];
    
    DetailHeaderBtnType type = (sender == _repost) ? kDetailHeaderBtnTypeRepost : kDetailHeaderBtnTypeComment;
    
    _currentType = type;
    
    //通知代理
    if ([_delegate respondsToSelector:@selector(detailHeader:btnClick:)]) {
        
        [_delegate detailHeader:self btnClick:type];
    }
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)awakeFromNib
{
    self.backgroundColor = kGlobalBackgroundColor;
    [self btnClick:_comment];
}

-(void)setStatus:(StatusModel *)status
{
    _status = status;
    
    [self setButton:_comment title:@"评论" count:status.commentsCount];
    [self setButton:_repost title:@"转发" count:status.repostsCount];
    [self setButton:_attitude title:@"赞" count:status.attitudesCount];
}

#pragma mark 设置按钮文字
-(void)setButton:(UIButton *)btn title:(NSString *)title count:(NSInteger)count
{
    if (count >= 10000) {  //上万
        CGFloat final = count / 10000.0;
        title = [NSString stringWithFormat:@"%@ %.1f万", title, final];
        //替换".0"为空串
        title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        [btn setTitle:title forState:UIControlStateNormal];
        
    }else if(count > 0){ //一万以内
        title = [NSString stringWithFormat:@"%@ %ld", title, count];
        [btn setTitle:title forState:UIControlStateNormal];
    }else{ //没有
        [btn setTitle:title forState:UIControlStateNormal];
    }
}

//-(void)drawRect:(CGRect)rect
//{
//    UIImage *image = [UIImage resizedImage:@"statusdetail_comment_top_background.png"];
//    
//    [image drawInRect:rect];
//}


@end
