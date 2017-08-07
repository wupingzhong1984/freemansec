//
//  Utility.h
//  freemansec
//
//  Created by adamwu on 2017/7/22.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utility : NSObject

+ (BOOL)validateEmail:(NSString *)str2validate;
+(UILabel*)formatLabel:(UILabel*)lbl text:(NSString*)text font:(UIFont*)font lineSpacing:(CGFloat)lineSpacing;
+ (UIImage *)fixOrientation:(UIImage *)aImage;
+ (NSArray*)getRGBByColor:(UIColor*)color;
+ (NSString*)convertToJSONData:(id)infoDict;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (UIAlertController *)createAlertWithTitle:(NSString*)titleStr content:(NSString*)content okBtnTitle:(NSString*)btnStr;
@end
