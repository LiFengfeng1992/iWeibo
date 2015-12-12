//
//  ComposePhotosView.h
//  iWeibo
//
//  Created by dengwei on 15/8/9.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposePhotosView : UIView

@property (nonatomic, strong) NSMutableArray *images;
- (void)addImage:(UIImage *)image;

@end
