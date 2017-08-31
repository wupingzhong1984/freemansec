//
//  NodataView.m
//  freemansec
//
//  Created by adamwu on 2017/8/31.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "NodataView.h"

@implementation NodataView


- (id)initWithTitle:(NSString*)title{
    
    if (self = [super initWithFrame:CGRectMake(0, 0, K_UIScreenWidth, 0)]) {
        
        UIView *bg = [[UIView alloc] init];
        bg.backgroundColor = UIColor_82b432;
        bg.size = CGSizeMake(130, 130);
        bg.layer.cornerRadius = bg.width/2;
        bg.y = 0;
        bg.centerX = self.width/2;
        [self addSubview:bg];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nodata_icon.png"]];
        icon.center = bg.center;
        [self addSubview:icon];
        icon.y -= 5;
        
        UILabel *lbl = [UILabel createLabelWithFrame:CGRectZero text:title textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
        [lbl sizeToFit];
        lbl.y = bg.maxY + 15;
        lbl.centerX = bg.centerX;
        [self addSubview:lbl];
        
        self.height = lbl.maxY;
    }
    
    return self;
}


@end
