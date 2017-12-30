//
//  LiveGiftView.m
//  freemansec
//
//  Created by adamwu on 2017/11/27.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "LiveGiftView.h"

@interface LiveGiftView ()
@property (nonatomic,strong) UIImageView *giftImgV;
@property (nonatomic,strong) UILabel *nameLbl;
@property (nonatomic,strong) UILabel *coinLbl;
@end

@implementation LiveGiftView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.bgImgV = [[UIImageView alloc] init];
        _bgImgV.size = self.size;
        [self addSubview:_bgImgV];
        
        self.giftImgV = [[UIImageView alloc] init];
        _giftImgV.contentMode = UIViewContentModeCenter;
        _giftImgV.frame = CGRectMake(0, 4, self.width, 43);
        [self addSubview:_giftImgV];
        
        self.nameLbl = [[UILabel alloc] init];
        _nameLbl.textColor = [UIColor whiteColor];
        _nameLbl.font = [UIFont systemFontOfSize:12];
        _nameLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameLbl];
        
        self.coinLbl = [[UILabel alloc] init];
        _coinLbl.textColor = [UIColor whiteColor];
        _coinLbl.font = [UIFont systemFontOfSize:10];
        _coinLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_coinLbl];
        
        self.touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _touchBtn.size = self.size;
        [self addSubview:_touchBtn];
    }
    
    return self;
}

- (void)setGiftImgUrl:(NSString *)giftImgUrl {
    
    [_giftImgV sd_setImageWithURL:[NSURL URLWithString:giftImgUrl]];
}

- (void)setGiftName:(NSString *)giftName {
    
    _nameLbl.text = giftName;
    [_nameLbl sizeToFit];
    _nameLbl.x = 0;
    _nameLbl.width = self.width;
    _nameLbl.centerY = self.height - 21;
}

- (void)setCoin:(NSString *)coin {
    
    _coinLbl.text = coin;
    [_coinLbl sizeToFit];
    _coinLbl.x = 0;
    _coinLbl.width = self.width;
    _coinLbl.centerY = self.height - 10;
}

@end
