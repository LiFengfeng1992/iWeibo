//
//  UIImage+X.m
//  iWeibo
//
//  Created by dengwei on 15/7/29.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "UIImage+X.h"
#import "NSString+X.h"

@implementation UIImage (X)

#pragma mark 加载全屏的图片
+(UIImage *)fullScreenImage:(NSString *)imageName
{
    //1.如果是iPhone5，对文件名特殊处理
    if (iPhone5) {
        imageName = [imageName fileAppend:@"-568h@2x"];
        
        XLog(@"iPhone5");
    }
    
    //加载图片
    return [self imageNamed:imageName];
}

#pragma mark 可以自由拉伸不会变形的图片
+(UIImage *)resizedImage:(NSString *)imageName
{
    
    return [self resizedImage:imageName xPos:0.5 yPos:0.5];
    
}


+ (UIImage *)resizedImage:(NSString *)imageName xPos:(CGFloat)xPos yPos:(CGFloat)yPos
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * xPos topCapHeight:image.size.height * yPos];
}

+ (instancetype)imageWithStretchableName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

+ (instancetype)resizableWithImageName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    
}

@end
