//
//  UpdateUserLiveTitleView.m
//  freemansec
//
//  Created by adamwu on 2017/8/2.
//  Copyright © 2017年 adamwu. All rights reserved.
//

#import "UpdateUserLiveTitleView.h"

@implementation UpdateUserLiveTitleView

-(id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.size = CGSizeMake(K_UIScreenWidth, K_UIScreenHeight);
        
        UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_prepare_bg.png"]];
        bgImg.center = self.center;
        [self addSubview:bgImg];
        
        self.bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bgBtn.size = self.size;
        _bgBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:_bgBtn];
        
        UIView *grayBg = [[UIView alloc] init];
        grayBg.backgroundColor = UIColor_vc_bgcolor_lightgray;
        grayBg.size = CGSizeMake(284,195);
        grayBg.center = self.center;
        grayBg.layer.cornerRadius = 4;
        [self addSubview:grayBg];
        
        UIImageView *cancel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];//todo
        cancel.center = CGPointMake(grayBg.maxX -16, grayBg.y + 16);
        [self addSubview:cancel];
        
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(grayBg.maxX-32, grayBg.y, 32, 32);
        [self addSubview:_cancelBtn];
        
        //todo
        //get room num
        self.roomIdLbl = [UILabel createLabelWithFrame:CGRectZero text:[NSString stringWithFormat:@"房间号%@",@""] textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:17]];
        [_roomIdLbl sizeToFit];
        _roomIdLbl.textAlignment = NSTextAlignmentCenter;
        _roomIdLbl.width = grayBg.width;
        _roomIdLbl.centerX = grayBg.centerX;
        _roomIdLbl.centerY = grayBg.y + 30;
        [self addSubview:_roomIdLbl];
        
        UIView *tfBg = [[UIView alloc] initWithFrame:CGRectMake(grayBg.x+12, grayBg.y + 60, grayBg.width-24, 88)];
        tfBg.backgroundColor = [UIColor whiteColor];
        tfBg.layer.cornerRadius = 4;
        tfBg.layer.borderWidth = 1;
        tfBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:tfBg];
        
        self.titleTF = [[UITextField alloc] init];
        _titleTF.frame = CGRectMake(tfBg.x + 10, (tfBg.height-20)/2 + tfBg.y, tfBg.width-20, 20);
        _titleTF.font = [UIFont systemFontOfSize:16];
        _titleTF.textColor = [UIColor darkGrayColor];
        _titleTF.placeholder = @"直播标题";//NSLocalizedString
        [self addSubview:_titleTF];
        
        self.startLiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startLiveBtn.frame = CGRectMake(tfBg.x, tfBg.maxY + 37, tfBg.width, 40);
        _startLiveBtn.backgroundColor = UIColor_82b432;
        _startLiveBtn.layer.cornerRadius = 4;
        [_startLiveBtn setTitle:@"开始直播" forState:UIControlStateNormal];//NSLocalizedString
        [_startLiveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _startLiveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_startLiveBtn];
    }
    
    return self;
}

@end
