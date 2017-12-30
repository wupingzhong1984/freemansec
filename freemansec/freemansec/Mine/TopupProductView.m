//
//  TopupProductView.m
//  freemansec
//
//  Created by adamwu on 2017/11/27.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "TopupProductView.h"

@interface TopupProductView ()
@property (nonatomic,strong) UIImageView *bgImgV;
@property (nonatomic,strong) UILabel *nameLbl;
@property (nonatomic,strong) UILabel *costDescLbl;
@end

@implementation TopupProductView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.bgImgV = [[UIImageView alloc] init];
        _bgImgV.size = self.size;
        _bgImgV.image = [UIImage imageNamed:@"topup_btn_bg.png"];
        [self addSubview:_bgImgV];
        
        self.nameLbl = [[UILabel alloc] init];
        _nameLbl.textColor = [UIColor darkGrayColor];
        _nameLbl.font = [UIFont systemFontOfSize:18];
        _nameLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameLbl];
        
        self.costDescLbl = [[UILabel alloc] init];
        _costDescLbl.textColor = UIColor_3ecafb;
        _costDescLbl.font = [UIFont systemFontOfSize:18];
        _costDescLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_costDescLbl];
        
        self.touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _touchBtn.size = self.size;
        [self addSubview:_touchBtn];
    }
    
    return self;
}

- (void)setProductName:(NSString *)productName {
    
    _nameLbl.text = productName;
    [_nameLbl sizeToFit];
    _nameLbl.x = 0;
    _nameLbl.width = self.width;
    _nameLbl.centerY = self.height/3;
}

- (void)setCostDesc:(NSString *)costDesc {
    
    _costDescLbl.text = costDesc;
    [_costDescLbl sizeToFit];
    _costDescLbl.x = 0;
    _costDescLbl.width = self.width;
    _costDescLbl.centerY = self.height*2/3;
}

- (void)setSelected:(BOOL)selected {
    
    if (selected) {
        
        _bgImgV.image = [UIImage imageNamed:@"topup_btn_bg_h.png"];
        _nameLbl.textColor = [UIColor whiteColor];
        _costDescLbl.textColor = [UIColor whiteColor];
        
    } else {
        
        _bgImgV.image = [UIImage imageNamed:@"topup_btn_bg.png"];
        _nameLbl.textColor = [UIColor darkGrayColor];
        _costDescLbl.textColor = UIColor_3ecafb;
    }
}
@end
