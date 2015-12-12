//
//  OptionStatusController.h
//  iWeibo
//
//  Created by dengwei on 15/8/22.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextView;
@interface OptionStatusController : UIViewController

/**
 *  被选中要评论或转发的微博id
 */
@property(nonatomic, assign)long long statusId;

@property (nonatomic, weak) TextView *textView;

-(void)send;

@end
