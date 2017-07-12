//
//  UIViewController-Extensions.h
//  myplan
//
//  Created by adamwu on 17/2/3.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CS_Extensions)
- (UILabel*_Nonnull)commNaviTitle:(NSString*_Nonnull)title color:(UIColor*_Nonnull)color;
- (UIBarButtonItem*_Nonnull)buildBarButtonItemWithImage:(NSString*_Nonnull)imgName acrion:(nullable SEL)action;
@end
