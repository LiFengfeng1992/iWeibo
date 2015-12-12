//
//  ImageListView.h
//  iWeibo
//
//  Created by dengwei on 15/8/2.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//  配图列表（1~9）

#import <UIKit/UIKit.h>

@interface ImageListView : UIView

// 所有图片的url
@property (nonatomic, strong) NSArray *imageUrls;

+ (CGSize)imageListSizeWithCount:(int)count;
@end