//
//  NSUserDefault+UserInfo.m
//  CherryAPP
//
//  Created by 开发者 on 15/6/2.
//  Copyright (c) 2015年 开发者. All rights reserved.
//

#import "UIFont+MyFont.h"

@implementation UIFont (MyFont)

+ (UIFont *)systemFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"HelveticaNeue" size:fontSize]; //HelveticaNeue-Light,HelveticaNeue,HelveticaNeue-Medium,HelveticaNeue-Bold
}

+ (UIFont *)mediumBoldSystemFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize];
}

+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize];
}

@end
