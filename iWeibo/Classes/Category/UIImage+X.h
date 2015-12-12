//
//  UIImage+X.h
//  iWeibo
//
//  Created by dengwei on 15/7/29.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (X)

//加载全屏的图片
+(UIImage *)fullScreenImage:(NSString *)imageName;

//可以自由拉伸不会变形的图片
+(UIImage *)resizedImage:(NSString *)imageName;

//pragma mark 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imageName xPos:(CGFloat)xPos yPos:(CGFloat)yPos;

+ (instancetype)imageWithStretchableName:(NSString *)imageName;

@end
