//
//  UIViewController-Extensions.m
//  myplan
//
//  Created by adamwu on 17/2/3.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "UIViewController-Extensions.h"

@implementation UIViewController (CS_Extensions)

- (UILabel*)commNaviTitle:(NSString*)title color:(UIColor*)color {
    
    UILabel *lbl = [UILabel createLabelWithFrame:CGRectZero text:title textColor:color font:[UIFont systemFontOfSize:17]];
    lbl.textAlignment = NSTextAlignmentCenter;
    [lbl sizeToFit];
    if (lbl.width > 200) {
        lbl.textAlignment = NSTextAlignmentLeft;
        lbl.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    lbl.width = 200;
    lbl.center = CGPointMake(K_UIScreenWidth/2, 20 + (self.navigationController.navigationBar.maxY-20)/2);
    return lbl;
}

- (UIBarButtonItem*)buildBarButtonItemWithImage:(NSString*)imgName acrion:(nullable SEL)action {
    
    UIImage *leftBarImg = [[UIImage imageNamed:imgName]
                           imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    return [[UIBarButtonItem alloc]
            initWithImage:leftBarImg
            style:UIBarButtonItemStylePlain
            target:self
            action:action];
}
@end
