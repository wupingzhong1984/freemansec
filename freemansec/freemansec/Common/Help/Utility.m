//
//  Utility.m
//  freemansec
//
//  Created by adamwu on 2017/7/22.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (BOOL)validateEmail:(NSString *)str2validate
{
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailPredicate evaluateWithObject:str2validate];
}

+(UILabel*)formatLabel:(UILabel*)lbl text:(NSString*)text font:(UIFont*)font lineSpacing:(CGFloat)lineSpacing{
    
    //    NSString * brief = [text stringByRemovingPercentEncoding];
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:text]; //brief
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])]; //brief
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedString.length)];
    
    [lbl setAttributedText:attributedString];
    [lbl sizeToFit];
    
    return lbl;
}
@end
