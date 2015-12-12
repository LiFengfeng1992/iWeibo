//
//  DetailHeader.h
//  iWeibo
//
//  Created by dengwei on 15/8/4.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StatusModel;
@class DetailHeader;

typedef enum {
    kDetailHeaderBtnTypeRepost, //转发
    kDetailHeaderBtnTypeComment //评论
}DetailHeaderBtnType;

@protocol DetailHeaderDelegate <NSObject>

@optional
-(void)detailHeader:(DetailHeader *)header btnClick:(DetailHeaderBtnType)index;

@end

@interface DetailHeader : UIImageView

+ (instancetype)header;
- (IBAction)btnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *hint;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (weak, nonatomic) IBOutlet UIButton *repost;
@property (weak, nonatomic) IBOutlet UIButton *attitude;

@property (nonatomic, strong)StatusModel *status;
@property (nonatomic, weak)id<DetailHeaderDelegate> delegate;

@property (nonatomic, assign, readonly)DetailHeaderBtnType currentType;

@end
